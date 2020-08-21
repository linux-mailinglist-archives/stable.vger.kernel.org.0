Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9A924E380
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 00:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgHUWeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 18:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbgHUWeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 18:34:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8125E20738;
        Fri, 21 Aug 2020 22:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598049253;
        bh=e9TgfbzPxbZ0RMettD6UjC9e/skty4Ij7sI3PWfvkKA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E5Ry6Ii/g8IEKJsBAvTX0xghUOft+EGvmMStVB6/N9ULp3ZpMRXQs3s0ezsgFilBf
         N6gV871jS2Pyiysa3OKhRrRl3FJKe410XDCgbjddqnkl8k88ua0GbgLIZjHzHzHuBa
         2uMzvkYf96ddYZ9ZWAXJnrXpp2IkefCJHhZD44Cs=
Date:   Fri, 21 Aug 2020 15:34:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: Track page table modifications in
 __apply_to_page_range()
Message-Id: <20200821153412.5902e4ed0699615d8de4a595@linux-foundation.org>
In-Reply-To: <20200821123746.16904-1-joro@8bytes.org>
References: <20200821123746.16904-1-joro@8bytes.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 21 Aug 2020 14:37:46 +0200 Joerg Roedel <joro@8bytes.org> wrote:

> The __apply_to_page_range() function is also used to change and/or
> allocate page-table pages in the vmalloc area of the address space.
> Make sure these changes get synchronized to other page-tables in the
> system by calling arch_sync_kernel_mappings() when necessary.
> 
> Tested-by: Chris Wilson <chris@chris-wilson.co.uk> #x86-32
> Cc: <stable@vger.kernel.org> # v5.8+

I'm trying to figure out how you figured out that this is 5.8+.  Has a
particular misbehaving commit been identified?

