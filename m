Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBCE613151
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJaHlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiJaHlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:41:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E68224;
        Mon, 31 Oct 2022 00:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 006BB60FD3;
        Mon, 31 Oct 2022 07:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121D8C433C1;
        Mon, 31 Oct 2022 07:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667202103;
        bh=5GUPDbtRVJ0TdbVPO/0lip/6bMyybFgnGpqeW2jqJAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CPkwUIkzvxDJl0PcNlRCuDPG6gRWL0+vaGss+8g0F99tK2uGeZUyv1nKt6qkMe8Ox
         P3r66+AGy8EysoubZvg7AD7Aqf97ml/RkvBPiWW6pHey566oHarmdE3YHIgR9u0anA
         3t+/zY6vLFFWs6gV+GzP90cfX5EYqQgLYVq965m8=
Date:   Mon, 31 Oct 2022 08:39:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Peter Xu <peterx@redhat.com>
Cc:     Yuanzheng Song <songyuanzheng@huawei.com>,
        akpm@linux-foundation.org, david@redhat.com, hughd@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.10 v2] mm/memory: add non-anonymous page check
 in the copy_present_page()
Message-ID: <Y197sOOefgM1Wpvh@kroah.com>
References: <20221028030705.2840539-1-songyuanzheng@huawei.com>
 <Y1vWDbRhXd8jTw8N@x1n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1vWDbRhXd8jTw8N@x1n>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 09:15:57AM -0400, Peter Xu wrote:
> On Fri, Oct 28, 2022 at 03:07:05AM +0000, Yuanzheng Song wrote:
> > The vma->anon_vma of the child process may be NULL because
> > the entire vma does not contain anonymous pages. In this
> > case, a BUG will occur when the copy_present_page() passes
> > a copy of a non-anonymous page of that vma to the
> > page_add_new_anon_rmap() to set up new anonymous rmap.
> > 
> > ------------[ cut here ]------------
> > kernel BUG at mm/rmap.c:1044!
> > Internal error: Oops - BUG: 0 [#1] SMP
> > Modules linked in:
> > CPU: 2 PID: 3617 Comm: test Not tainted 5.10.149 #1
> > Hardware name: linux,dummy-virt (DT)
> > pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
> > pc : __page_set_anon_rmap+0xbc/0xf8
> > lr : __page_set_anon_rmap+0xbc/0xf8
> > sp : ffff800014c1b870
> > x29: ffff800014c1b870 x28: 0000000000000001
> > x27: 0000000010100073 x26: ffff1d65c517baa8
> > x25: ffff1d65cab0f000 x24: ffff1d65c416d800
> > x23: ffff1d65cab5f248 x22: 0000000020000000
> > x21: 0000000000000001 x20: 0000000000000000
> > x19: fffffe75970023c0 x18: 0000000000000000
> > x17: 0000000000000000 x16: 0000000000000000
> > x15: 0000000000000000 x14: 0000000000000000
> > x13: 0000000000000000 x12: 0000000000000000
> > x11: 0000000000000000 x10: 0000000000000000
> > x9 : ffffc3096d5fb858 x8 : 0000000000000000
> > x7 : 0000000000000011 x6 : ffff5a5c9089c000
> > x5 : 0000000000020000 x4 : ffff5a5c9089c000
> > x3 : ffffc3096d200000 x2 : ffffc3096e8d0000
> > x1 : ffff1d65ca3da740 x0 : 0000000000000000
> > Call trace:
> >  __page_set_anon_rmap+0xbc/0xf8
> >  page_add_new_anon_rmap+0x1e0/0x390
> >  copy_pte_range+0xd00/0x1248
> >  copy_page_range+0x39c/0x620
> >  dup_mmap+0x2e0/0x5a8
> >  dup_mm+0x78/0x140
> >  copy_process+0x918/0x1a20
> >  kernel_clone+0xac/0x638
> >  __do_sys_clone+0x78/0xb0
> >  __arm64_sys_clone+0x30/0x40
> >  el0_svc_common.constprop.0+0xb0/0x308
> >  do_el0_svc+0x48/0xb8
> >  el0_svc+0x24/0x38
> >  el0_sync_handler+0x160/0x168
> >  el0_sync+0x180/0x1c0
> > Code: 97f8ff85 f9400294 17ffffeb 97f8ff82 (d4210000)
> > ---[ end trace a972347688dc9bd4 ]---
> > Kernel panic - not syncing: Oops - BUG: Fatal exception
> > SMP: stopping secondary CPUs
> > Kernel Offset: 0x43095d200000 from 0xffff800010000000
> > PHYS_OFFSET: 0xffffe29a80000000
> > CPU features: 0x08200022,61806082
> > Memory Limit: none
> > ---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]---
> > 
> > This problem has been fixed by the commit <fb3d824d1a46>
> > ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap()
> > and page_try_dup_anon_rmap()"), but still exists in the
> > linux-5.10.y branch.
> > 
> > This patch is not applicable to this version because
> > of the large version differences. Therefore, fix it by
> > adding non-anonymous page check in the copy_present_page().
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 70e806e4e645 ("mm: Do early cow for pinned pages during fork() for ptes")
> > Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>
> 
> Acked-by: Peter Xu <peterx@redhat.com>

Now queued up, thanks.

greg k-h
