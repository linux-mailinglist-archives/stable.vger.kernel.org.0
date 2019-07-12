Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48F9662A1
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 02:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbfGLAE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 20:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728102AbfGLAE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 20:04:57 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5782221019;
        Fri, 12 Jul 2019 00:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562889896;
        bh=RUU96y3CL94NXnq05VuKbhkW/5unmwebIUCOiqzgxbQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0e1mYioNDELxTwqtfNeRxo4F/NiP6+z1joxUw2rSKLIqaxwRW7LGFZ25qSs7yBtCT
         JocX2GL9SkEb944Md8/x8Nuzyuq+CaS5jwPvuTNjuWOv2Lqt+hzZ2305ibIarJCj9h
         OVu7ifwlkMq23nofZGVRpJCrYE4xnTBZZvJUfFKI=
Date:   Thu, 11 Jul 2019 17:04:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jan Kara <jack@suse.cz>
Cc:     <linux-mm@kvack.org>, mgorman@suse.de, mhocko@suse.cz,
        stable@vger.kernel.org
Subject: Re: [PATCH RFC] mm: migrate: Fix races of __find_get_block() and
 page migration
Message-Id: <20190711170455.5a9ae6e659cab1a85f9aa30c@linux-foundation.org>
In-Reply-To: <20190711125838.32565-1-jack@suse.cz>
References: <20190711125838.32565-1-jack@suse.cz>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Jul 2019 14:58:38 +0200 Jan Kara <jack@suse.cz> wrote:

> buffer_migrate_page_norefs() can race with bh users in a following way:
> 
> CPU1					CPU2
> buffer_migrate_page_norefs()
>   buffer_migrate_lock_buffers()
>   checks bh refs
>   spin_unlock(&mapping->private_lock)
> 					__find_get_block()
> 					  spin_lock(&mapping->private_lock)
> 					  grab bh ref
> 					  spin_unlock(&mapping->private_lock)
>   move page				  do bh work
> 
> This can result in various issues like lost updates to buffers (i.e.
> metadata corruption) or use after free issues for the old page.
> 
> Closing this race window is relatively difficult. We could hold
> mapping->private_lock in buffer_migrate_page_norefs() until we are
> finished with migrating the page but the lock hold times would be rather
> big. So let's revert to a more careful variant of page migration requiring
> eviction of buffers on migrated page. This is effectively
> fallback_migrate_page() that additionally invalidates bh LRUs in case
> try_to_free_buffers() failed.

Is this premature optimization?  Holding ->private_lock while messing
with the buffers would be the standard way of addressing this.  The
longer hold times *might* be an issue, but we don't know this, do we? 
If there are indeed such problems then they could be improved by, say,
doing more of the newpage preparation prior to taking ->private_lock.

