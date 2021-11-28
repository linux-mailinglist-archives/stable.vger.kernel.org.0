Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5BE46052B
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 09:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356953AbhK1IGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 03:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356239AbhK1IEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 03:04:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EC3C061746
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 00:00:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82DDAB80B58
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 08:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762A1C004E1;
        Sun, 28 Nov 2021 08:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638086445;
        bh=XqhNGzSoqMOUxdiZDwFWRQbasGgB7gqERNKZo7DPvAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VU9YcjX1vJCGXE2Eo3Rd/qodsyYbgVEGiG40AmSdv9Zav1m136sRuB+WPlm+PSdZo
         DfNInGChEe43HdapuipX8jtiFPtsvGK79KkFCE0o7ZDJ9389+Lko/A2BHUKztXsJc8
         Y5D0YRH0aa2JrVu8FNweL80xuob3PSNeD3bvOypw=
Date:   Sun, 28 Nov 2021 09:00:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     YangWei <yang.wei@linux.alibaba.com>
Cc:     Yang Wei <albin.yangwei@alibaba-inc.com>,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19] x86/mm: add cond_resched() in _set_memory_array()
 and set_memory_array_wb()
Message-ID: <YaM3KYP829ZTVKqT@kroah.com>
References: <1637911946-67009-1-git-send-email-albin.yangwei@alibaba-inc.com>
 <YaENEIbE8hA1h19/@kroah.com>
 <9c415df9-9575-8217-03e9-a6bbf20a491a@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c415df9-9575-8217-03e9-a6bbf20a491a@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 28, 2021 at 12:25:23AM +0800, YangWei wrote:
> 在 2021/11/27 00:36, Greg KH 写道:
> > On Fri, Nov 26, 2021 at 03:32:26PM +0800, Yang Wei wrote:
> > > From: Yang Wei <yang.wei@linux.alibaba.com>
> > > 
> > > We found _set_memory_array() and set_memory_array_wb() takes more than
> > > 500ms in kernel space in the following scenario.
> > > So use this patch to trigger schedule for each page, to avoid other
> > > threads getting stuck.
> > > 
> > >      0xffffffff810a34d2 find_next_iomem_res  ([kernel.kallsyms])
> > >      0xffffffff810a3d40 walk_system_ram_range  ([kernel.kallsyms])
> > >      0xffffffff810772ca pat_pagerange_is_ram  ([kernel.kallsyms])
> > >      0xffffffff8107796f reserve_memtype  ([kernel.kallsyms])
> > >      0xffffffff81075e98 _set_memory_array  ([kernel.kallsyms])
> > >      0xffffffffc0ef6083 nv_alloc_system_pages  [nvidia] ([kernel.kallsyms])
> > > 
> > >      0xffffffff810a34d2 find_next_iomem_res  ([kernel.kallsyms])
> > >      0xffffffff810a3d40 walk_system_ram_range  ([kernel.kallsyms])
> > >      0xffffffff810772ca pat_pagerange_is_ram  ([kernel.kallsyms])
> > >      0xffffffff8107745a free_memtype.part.7  ([kernel.kallsyms])
> > >      0xffffffff8107606e set_memory_array_wb  ([kernel.kallsyms])
> > >      0xffffffffc0ef6291 nv_free_system_pages  [nvidia]([kernel.kallsyms])
> > > 
> > > Signed-off-by: Yang Wei <yang.wei@linux.alibaba.com>
> > > Tested-by: Yang Wei <yang.wei@linux.alibaba.com>
> > > ---
> > >   arch/x86/mm/pageattr.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > Why is this 4.19-only?
> > 
> > What commit in Linus's tree resolved this issue?
> > 
> > confused,
> > 
> > greg k-h
> 
> We found that the nvidia driver calling
> nv_alloc_system_pages()/nv_free_system_pages()

For obvious reasons, we do not care about this type of problem at all.
Please contact the vendor responsible for this as they are the only ones
who can do anything about it.

good luck!

greg k-h
