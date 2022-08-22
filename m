Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35AE959BA46
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiHVHaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiHVHaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA921D0DA
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 00:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91B7CB80E69
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 07:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5D2C433C1;
        Mon, 22 Aug 2022 07:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661153415;
        bh=RUyHT2rS/eqvbY1Y6kk3vy89gAXXPPAkkZu8MoDjfs0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UrkA+vbDfblCKRLGNf2ATDbtqnIdpahmCgLMfJ7mmZheCtC46sDuDPlkNN0EjSIhv
         f448ommp6B1UDLG0XnbyIS72VvA2SquAm2QC+Q2UuroRHZarcCr3we1N0+m3uWyPEg
         YzIt+2TzE8YX+2+xJ8txdyGgCi1fTAlXaTVTTmAc=
Date:   Mon, 22 Aug 2022 09:30:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Cc:     Coiby Xu <coxu@redhat.com>, bhe@redhat.com, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.15-stable tree
Message-ID: <YwMwhJ1sFJi+/RBj@kroah.com>
References: <16605775859368@kroah.com>
 <20220818040938.pllzarythgusnyzf@Rk>
 <Yv+hC9QyHn55uVAo@kroah.com>
 <YwEl3xUF8mwpuVrB@kroah.com>
 <20220821072410.GG28810@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220821072410.GG28810@kitsune.suse.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 21, 2022 at 09:24:10AM +0200, Michal Suchánek wrote:
> On Sat, Aug 20, 2022 at 08:20:15PM +0200, Greg KH wrote:
> > On Fri, Aug 19, 2022 at 04:41:15PM +0200, Greg KH wrote:
> > > On Thu, Aug 18, 2022 at 12:09:38PM +0800, Coiby Xu wrote:
> > > > Hi Greg,
> > > > 
> > > > This patch depends on three prerequisites. This full list of commit ids
> > > > should be backported is shown below,
> > > > 
> > > > 1. 65d9a9a60fd7 ("kexec_file: drop weak attribute from functions")
> > > > 2. 689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
> > > > 3. c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
> > > > 4. 0d519cadf751 ("arm64: kexec_file: use more system keyrings to verify kernel image signature")
> > > > 
> > > > And I can confirm they can be applied to linux-5.15.y branch
> > > > successfully,
> > > >     $ git checkout -b arm_key_5.15.y stable/linux-5.15.y
> > > >     branch 'arm_key_5.15.y' set up to track 'stable/linux-5.15.y'.
> > > >     Switched to a new branch 'arm_key_5.15.y'
> > > >     $ git cherry-pick 65d9a9a60fd7 689a71493bd2 c903dae8941d 0d519cadf751
> > > >     Auto-merging arch/arm64/include/asm/kexec.h
> > > >     Auto-merging arch/powerpc/include/asm/kexec.h
> > > >     Auto-merging arch/s390/include/asm/kexec.h
> > > >     Auto-merging arch/x86/include/asm/kexec.h
> > > >     Auto-merging include/linux/kexec.h
> > > >     Auto-merging kernel/kexec_file.c
> > > >     [arm_key_5.15.y 7c7844771360] kexec_file: drop weak attribute from functions
> > > >      Author: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> > > >      Date: Fri Jul 1 13:04:04 2022 +0530
> > > >      6 files changed, 61 insertions(+), 40 deletions(-)
> > > >     Auto-merging include/linux/kexec.h
> > > >     Auto-merging kernel/kexec_file.c
> > > >     [arm_key_5.15.y 4283e2681d86] kexec: clean up arch_kexec_kernel_verify_sig
> > > >      Date: Thu Jul 14 21:40:24 2022 +0800
> > > >      2 files changed, 13 insertions(+), 25 deletions(-)
> > > >     Auto-merging include/linux/kexec.h
> > > >     Auto-merging kernel/kexec_file.c
> > > >     [arm_key_5.15.y c0cf50b9056f] kexec, KEYS: make the code in bzImage64_verify_sig generic
> > > >      Date: Thu Jul 14 21:40:25 2022 +0800
> > > >      3 files changed, 25 insertions(+), 19 deletions(-)
> > > >     [arm_key_5.15.y 40b98256cb89] arm64: kexec_file: use more system keyrings to verify kernel image signature
> > > >      Date: Thu Jul 14 21:40:26 2022 +0800
> > > >      1 file changed, 1 insertion(+), 10 deletions(-)
> > > 
> > > thanks, now queued up.
> > 
> > Nope, it causes build breakages in powerpc :(
> s390
> > 
> > See:
> > 	https://lore.kernel.org/r/YwC6eQjx8xC9y3LD@debian
> > and
> > 	https://lore.kernel.org/r/CA+G9fYtXnZP2vdAi4eU_ApC_YFz6TqTd6Eh5Mumb2=0Y_dK5Yw@mail.gmail.com
> > 
> > for the reports.  I'm dropping these from 5.15.y now, please fix this up
> > and resend if you want them included.
> 
> The offending function was removed in 5.16 by
> commit 277c8389386e ("s390/kexec_file: move kernel image size check")

Great, then someone needs to send me a backported, and tested, set of
patches and I will be glad to queue them up.

thanks,

greg k-h
