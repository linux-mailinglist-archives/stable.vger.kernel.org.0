Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02CB6141F18
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 17:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgASQlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 11:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgASQli (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jan 2020 11:41:38 -0500
Received: from localhost (96-81-74-198-static.hfc.comcastbusiness.net [96.81.74.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1B8420679;
        Sun, 19 Jan 2020 16:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579452097;
        bh=8RY3dVu0co497bINTl6DWMYKBPZFv8aJCOyvSBPPz0E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vt6n6X5AeJsfakgOUw6tIUZeFk10jXDZ4IsqMNG8uh1Do+oDp0b0lzoIkIQ5MBYvl
         pZKTE/CZAqTKt2F//acuzDBcBlaF3VDnLWc6yzV6GjGWk60u1YTo/WMRSkvBB2BiCk
         VthF9KLScG1uM/Yu4XG1l43qgAziw3Q8daSDzXnI=
Date:   Sun, 19 Jan 2020 11:41:33 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     kirill@shutemov.name, akpm@linux-foundation.org,
        aneesh.kumar@linux.vnet.ibm.com, dan.j.williams@intel.com,
        kirill.shutemov@linux.intel.com, otto.g.bruggeman@intel.com,
        stable@vger.kernel.org, thomas.willhalm@intel.com,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm/huge_memory.c: thp: fix conflict of
 above-47bit hint" failed to apply to 4.19-stable tree
Message-ID: <20200119164133.GV1706@sasha-vm>
References: <157944690224276@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157944690224276@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 04:15:02PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 97d3d0f9a1cf132c63c0b8b8bd497b8a56283dd9 Mon Sep 17 00:00:00 2001
>From: "Kirill A. Shutemov" <kirill@shutemov.name>
>Date: Mon, 13 Jan 2020 16:29:10 -0800
>Subject: [PATCH] mm/huge_memory.c: thp: fix conflict of above-47bit hint
> address and PMD alignment
>
>Patch series "Fix two above-47bit hint address vs.  THP bugs".
>
>The two get_unmapped_area() implementations have to be fixed to provide
>THP-friendly mappings if above-47bit hint address is specified.
>
>This patch (of 2):
>
>Filesystems use thp_get_unmapped_area() to provide THP-friendly
>mappings.  For DAX in particular.
>
>Normally, the kernel doesn't create userspace mappings above 47-bit,
>even if the machine allows this (such as with 5-level paging on x86-64).
>Not all user space is ready to handle wide addresses.  It's known that
>at least some JIT compilers use higher bits in pointers to encode their
>information.
>
>Userspace can ask for allocation from full address space by specifying
>hint address (with or without MAP_FIXED) above 47-bits.  If the
>application doesn't need a particular address, but wants to allocate
>from whole address space it can specify -1 as a hint address.
>
>Unfortunately, this trick breaks thp_get_unmapped_area(): the function
>would not try to allocate PMD-aligned area if *any* hint address
>specified.
>
>Modify the routine to handle it correctly:
>
> - Try to allocate the space at the specified hint address with length
>   padding required for PMD alignment.
> - If failed, retry without length padding (but with the same hint
>   address);
> - If the returned address matches the hint address return it.
> - Otherwise, align the address as required for THP and return.
>
>The user specified hint address is passed down to get_unmapped_area() so
>above-47bit hint address will be taken into account without breaking
>alignment requirements.
>
>Link: http://lkml.kernel.org/r/20191220142548.7118-2-kirill.shutemov@linux.intel.com
>Fixes: b569bab78d8d ("x86/mm: Prepare to expose larger address space to userspace")
>Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>Reported-by: Thomas Willhalm <thomas.willhalm@intel.com>
>Tested-by: Dan Williams <dan.j.williams@intel.com>
>Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
>Cc: "Bruggeman, Otto G" <otto.g.bruggeman@intel.com>
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Conflict due to missing b3b07077b01e ("mm/huge_memory.c: make
__thp_get_unmapped_area static"), I've just queued both for 4.19 and
4.14.

-- 
Thanks,
Sasha
