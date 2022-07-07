Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280EC56AA32
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 20:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbiGGSEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 14:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236048AbiGGSEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 14:04:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59CF13F42;
        Thu,  7 Jul 2022 11:04:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67487B82299;
        Thu,  7 Jul 2022 18:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB409C3411E;
        Thu,  7 Jul 2022 18:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657217047;
        bh=SGueRWIyzVyPJjQ6UwiSli1wQJuF/A3j5F+SxexRI4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2A5xUmgMvNbXPxl0c/R7AwoUOgkkfPPoho0gVa7Al9D4+G4UxVZ5/2GaxeK2Nu180
         KsO0n28XxX7SeLQoxzWNZZUdolFCkDjEusGD0JasBw9Bh2c7UMe//TBl2oVGuIP/iy
         qPRtKS17zKmhXLOdy7QwHCSF1pSAyPDZUbffqPKY=
Date:   Thu, 7 Jul 2022 20:04:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Liu Shixin <liushixin2@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.15 v4] mm/filemap: fix UAF in find_lock_entries
Message-ID: <YscgFKW4tNbl2V5D@kroah.com>
References: <20220707020938.2122198-1-liushixin2@huawei.com>
 <YsZOafRSNZWY0EpM@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsZOafRSNZWY0EpM@casper.infradead.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 07, 2022 at 04:09:29AM +0100, Matthew Wilcox wrote:
> On Thu, Jul 07, 2022 at 10:09:38AM +0800, Liu Shixin wrote:
> > Release refcount after xas_set to fix UAF which may cause panic like this:
> > 
> >  page:ffffea000491fa40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x1247e9
> >  head:ffffea000491fa00 order:3 compound_mapcount:0 compound_pincount:0
> >  memcg:ffff888104f91091
> >  flags: 0x2fffff80010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
> > ...
> > page dumped because: VM_BUG_ON_PAGE(PageTail(page))
> >  ------------[ cut here ]------------
> >  kernel BUG at include/linux/page-flags.h:632!
> >  invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN
> >  CPU: 1 PID: 7642 Comm: sh Not tainted 5.15.51-dirty #26
> > ...
> >  Call Trace:
> >   <TASK>
> >   __invalidate_mapping_pages+0xe7/0x540
> >   drop_pagecache_sb+0x159/0x320
> >   iterate_supers+0x120/0x240
> >   drop_caches_sysctl_handler+0xaa/0xe0
> >   proc_sys_call_handler+0x2b4/0x480
> >   new_sync_write+0x3d6/0x5c0
> >   vfs_write+0x446/0x7a0
> >   ksys_write+0x105/0x210
> >   do_syscall_64+0x35/0x80
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >  RIP: 0033:0x7f52b5733130
> > ...
> > 
> > This problem has been fixed on mainline by patch 6b24ca4a1a8d ("mm: Use
> > multi-index entries in the page cache") since it deletes the related code.
> > 
> > Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")
> > Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> 
> Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Now queued up, thanks.

greg k-h
