Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D5A55D0D8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiF1HJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 03:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiF1HJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 03:09:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEBAB1F7;
        Tue, 28 Jun 2022 00:09:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04115B81C52;
        Tue, 28 Jun 2022 07:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64907C3411D;
        Tue, 28 Jun 2022 07:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656400148;
        bh=KnezzPTo8Q9ZlvqT1K8y4aDTmHK/lvlmr89a7q7X7AY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bwWKIZpcQgl01V43jknNke+c7QERjiyVYr/1S+vMI76fgbiPRCCtanZJj8p6+GE2W
         UGOwEWmm63w/OvylJOo7FZFgc1BTkHRybjZJj1eOntMjPuA/8ZVXwBQHFlGWXlgLAO
         fiffY81sAwbmN+5uRO0xJH40HKesOhTFpit9LXLA=
Date:   Tue, 28 Jun 2022 09:09:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Baoquan He <bhe@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 5.18 112/181] vmcore: convert copy_oldmem_page() to take
 an iov_iter
Message-ID: <YrqpEZV3yu31t6E2@kroah.com>
References: <20220627111944.553492442@linuxfoundation.org>
 <20220627111947.945731832@linuxfoundation.org>
 <YrnaYJA675eGIy03@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrnaYJA675eGIy03@osiris>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 06:27:12PM +0200, Heiko Carstens wrote:
> On Mon, Jun 27, 2022 at 01:21:25PM +0200, Greg Kroah-Hartman wrote:
> > From: Matthew Wilcox (Oracle) <willy@infradead.org>
> > 
> > [ Upstream commit 5d8de293c224896a4da99763fce4f9794308caf4 ]
> > 
> > Patch series "Convert vmcore to use an iov_iter", v5.
> > 
> > For some reason several people have been sending bad patches to fix
> > compiler warnings in vmcore recently.  Here's how it should be done.
> > Compile-tested only on x86.  As noted in the first patch, s390 should take
> > this conversion a bit further, but I'm not inclined to do that work
> > myself.
> > 
> > This patch (of 3):
> > 
> > Instead of passing in a 'buf' and 'userbuf' argument, pass in an iov_iter.
> > s390 needs more work to pass the iov_iter down further, or refactor, but
> > I'd be more comfortable if someone who can test on s390 did that work.
> > 
> > It's more convenient to convert the whole of read_from_oldmem() to take an
> > iov_iter at the same time, so rename it to read_from_oldmem_iter() and add
> > a temporary read_from_oldmem() wrapper that creates an iov_iter.
> > 
> > Link: https://lkml.kernel.org/r/20220408090636.560886-1-bhe@redhat.com
> > Link: https://lkml.kernel.org/r/20220408090636.560886-2-bhe@redhat.com
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Cc: Heiko Carstens <hca@linux.ibm.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/arm/kernel/crash_dump.c     | 27 +++-------------
> >  arch/arm64/kernel/crash_dump.c   | 29 +++--------------
> >  arch/ia64/kernel/crash_dump.c    | 32 +++----------------
> >  arch/mips/kernel/crash_dump.c    | 27 +++-------------
> >  arch/powerpc/kernel/crash_dump.c | 35 +++------------------
> >  arch/riscv/kernel/crash_dump.c   | 26 +++------------
> >  arch/s390/kernel/crash_dump.c    | 13 +++++---
> >  arch/sh/kernel/crash_dump.c      | 29 +++--------------
> >  arch/x86/kernel/crash_dump_32.c  | 29 +++--------------
> >  arch/x86/kernel/crash_dump_64.c  | 41 +++++++-----------------
> >  fs/proc/vmcore.c                 | 54 ++++++++++++++++++++------------
> >  include/linux/crash_dump.h       |  9 +++---
> >  12 files changed, 91 insertions(+), 260 deletions(-)
> 
> This one breaks s390. You would also need to apply the following two commits:
> 
> cc02e6e21aa5 ("s390/crash: add missing iterator advance in copy_oldmem_page()")
> af2debd58bd7 ("s390/crash: make copy_oldmem_page() return number of bytes copied")

Both of them are also in the 5.18-rc queue here, right?

thanks,

greg k-h
