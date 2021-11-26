Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AF345E8D5
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 08:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346328AbhKZHtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 02:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359302AbhKZHrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 02:47:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52C1361106;
        Fri, 26 Nov 2021 07:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637912651;
        bh=jsIUQq1Vlyz1XgcfQcCRKZRqUYrKy+DZG4u5wzP/Yco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FV5fLBN9ZCq+ARtCnHBEGrTJUuydC9SckAVqVuXN56DUaid329vo/gAFmZ5JkR+3z
         Sh26X6awzzQ6iCxA68KpogrHvE/eqi24O6HGkOf+l21O73ceuwi+DDLVS5/x8yc+vm
         XDBlPwV3ylp5R3iO0lkJz897cbDErYAkVogWhyb0=
Date:   Fri, 26 Nov 2021 08:44:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Wei <albin.yangwei@alibaba-inc.com>
Cc:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        stable@vger.kernel.org, yang.wei@linux.alibaba.com
Subject: Re: [PATCH 4.19] x86/mm: add cond_resched() in _set_memory_array()
 and set_memory_array_wb()
Message-ID: <YaCQR3hyt0Hvtegq@kroah.com>
References: <1637911946-67009-1-git-send-email-albin.yangwei@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1637911946-67009-1-git-send-email-albin.yangwei@alibaba-inc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 26, 2021 at 03:32:26PM +0800, Yang Wei wrote:
> From: Yang Wei <yang.wei@linux.alibaba.com>
> 
> We found _set_memory_array() and set_memory_array_wb() takes more than
> 500ms in kernel space in the following scenario.
> So use this patch to trigger schedule for each page, to avoid other
> threads getting stuck.
> 
>     0xffffffff810a34d2 find_next_iomem_res  ([kernel.kallsyms])
>     0xffffffff810a3d40 walk_system_ram_range  ([kernel.kallsyms])
>     0xffffffff810772ca pat_pagerange_is_ram  ([kernel.kallsyms])
>     0xffffffff8107796f reserve_memtype  ([kernel.kallsyms])
>     0xffffffff81075e98 _set_memory_array  ([kernel.kallsyms])
>     0xffffffffc0ef6083 nv_alloc_system_pages  [nvidia] ([kernel.kallsyms])
> 
>     0xffffffff810a34d2 find_next_iomem_res  ([kernel.kallsyms])
>     0xffffffff810a3d40 walk_system_ram_range  ([kernel.kallsyms])
>     0xffffffff810772ca pat_pagerange_is_ram  ([kernel.kallsyms])
>     0xffffffff8107745a free_memtype.part.7  ([kernel.kallsyms])
>     0xffffffff8107606e set_memory_array_wb  ([kernel.kallsyms])
>     0xffffffffc0ef6291 nv_free_system_pages  [nvidia]([kernel.kallsyms])
> 
> Signed-off-by: Yang Wei <yang.wei@linux.alibaba.com>
> Tested-by: Yang Wei <yang.wei@linux.alibaba.com>
> ---
>  arch/x86/mm/pageattr.c | 2 ++
>  1 file changed, 2 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
