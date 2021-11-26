Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D64245F26E
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 17:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbhKZQvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 11:51:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49558 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237576AbhKZQtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 11:49:42 -0500
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 11:49:42 EST
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E8BC622E5
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 16:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7F8C93056;
        Fri, 26 Nov 2021 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637944594;
        bh=lYcmN+wEgyrMfHD4AL1x9GZdXHBevjqYJTQWyMQpUGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ln/4dldLi/tCmVFkDn8CqOL+MA07fEsyoumsQlQ7+5daY5yNqWGWGTwCX9Mj90RKM
         ZKS2ZWMRxQrQm97++F2LVrrHr1IXW9X6kS5pSlc5enJrCF4DTzITz7LC5RNMYKofY+
         H92X+0feh8gv/VG/aaNEKhjVHG5DSrH7H3Q3Zkio=
Date:   Fri, 26 Nov 2021 17:36:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Wei <albin.yangwei@alibaba-inc.com>
Cc:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        stable@vger.kernel.org, yang.wei@linux.alibaba.com
Subject: Re: [PATCH 4.19] x86/mm: add cond_resched() in _set_memory_array()
 and set_memory_array_wb()
Message-ID: <YaENEIbE8hA1h19/@kroah.com>
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

Why is this 4.19-only?

What commit in Linus's tree resolved this issue?

confused,

greg k-h
