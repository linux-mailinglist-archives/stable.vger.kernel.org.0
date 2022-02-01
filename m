Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5EF4A545F
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 02:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiBABB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 20:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiBABBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 20:01:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF16C06173B;
        Mon, 31 Jan 2022 17:01:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C3916114C;
        Tue,  1 Feb 2022 01:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2B1C340EC;
        Tue,  1 Feb 2022 01:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643677284;
        bh=0gFRkMeBrEbAJtvV7jiZaYWjZsJplBWCxekudIaSp9A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qVY6JB8ceUixUrS/C2NR5cD+aF6hRCO00ofiUauUPVPyEHCcvBXiO1N1E5SOaqL8Z
         3mPjfEK4a/hIKGi9VvvbDBZKyvIlOHCq0mp/xE4l14hkCBJcHtu1i/Um6BGldYqaLO
         DN1QgqpNs8tHSQ151UisvL2O0jv4M916ev+7OnWk=
Date:   Mon, 31 Jan 2022 17:01:23 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v1] drivers/base/memory: add memory block to memory
 group after registration succeeded
Message-Id: <20220131170123.42d7f46ecea0da1cb1579113@linux-foundation.org>
In-Reply-To: <20220128144540.153902-1-david@redhat.com>
References: <20220128144540.153902-1-david@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 28 Jan 2022 15:45:40 +0100 David Hildenbrand <david@redhat.com> wrote:

> If register_memory() fails, we freed the memory block but already added
> the memory block to the group list, not good. Let's defer adding the
> block to the memory group to after registering the memory block device.
> 
> We do handle it properly during unregister_memory(), but that's not
> called when the registration fails.
> 

I guess this has never been known to happen.  So I queued the fix for
5.18-rc1, cc:stable.

