Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92A759B274
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiHUHBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiHUHA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596C82A975
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 00:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB0E560CEC
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 07:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8577C433C1;
        Sun, 21 Aug 2022 07:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065227;
        bh=Xd3CivOsiHKumKLPM+7VI1p/eR0Q8qkZwwodztIrwsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DxHsjnY7xhHd8Ysdw4j8C8pQ590FfL2QOkbgkwzN9ddj4Y3Y+fpLJ/3sSP8gx00yU
         cpp/uO9h6EHoDFtujTudI4IwO5y+T+ah4kCuIIsdCAyvLgxuxZ0Qsg1XILEVCrG9yB
         4HPib/HLNlXidp20DA3pwkD9UuGZPASUEbNd7QZA=
Date:   Sat, 20 Aug 2022 20:20:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coiby Xu <coxu@redhat.com>
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.15-stable tree
Message-ID: <YwEl3xUF8mwpuVrB@kroah.com>
References: <16605775859368@kroah.com>
 <20220818040938.pllzarythgusnyzf@Rk>
 <Yv+hC9QyHn55uVAo@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv+hC9QyHn55uVAo@kroah.com>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 04:41:15PM +0200, Greg KH wrote:
> On Thu, Aug 18, 2022 at 12:09:38PM +0800, Coiby Xu wrote:
> > Hi Greg,
> > 
> > This patch depends on three prerequisites. This full list of commit ids
> > should be backported is shown below,
> > 
> > 1. 65d9a9a60fd7 ("kexec_file: drop weak attribute from functions")
> > 2. 689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
> > 3. c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
> > 4. 0d519cadf751 ("arm64: kexec_file: use more system keyrings to verify kernel image signature")
> > 
> > And I can confirm they can be applied to linux-5.15.y branch
> > successfully,
> >     $ git checkout -b arm_key_5.15.y stable/linux-5.15.y
> >     branch 'arm_key_5.15.y' set up to track 'stable/linux-5.15.y'.
> >     Switched to a new branch 'arm_key_5.15.y'
> >     $ git cherry-pick 65d9a9a60fd7 689a71493bd2 c903dae8941d 0d519cadf751
> >     Auto-merging arch/arm64/include/asm/kexec.h
> >     Auto-merging arch/powerpc/include/asm/kexec.h
> >     Auto-merging arch/s390/include/asm/kexec.h
> >     Auto-merging arch/x86/include/asm/kexec.h
> >     Auto-merging include/linux/kexec.h
> >     Auto-merging kernel/kexec_file.c
> >     [arm_key_5.15.y 7c7844771360] kexec_file: drop weak attribute from functions
> >      Author: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> >      Date: Fri Jul 1 13:04:04 2022 +0530
> >      6 files changed, 61 insertions(+), 40 deletions(-)
> >     Auto-merging include/linux/kexec.h
> >     Auto-merging kernel/kexec_file.c
> >     [arm_key_5.15.y 4283e2681d86] kexec: clean up arch_kexec_kernel_verify_sig
> >      Date: Thu Jul 14 21:40:24 2022 +0800
> >      2 files changed, 13 insertions(+), 25 deletions(-)
> >     Auto-merging include/linux/kexec.h
> >     Auto-merging kernel/kexec_file.c
> >     [arm_key_5.15.y c0cf50b9056f] kexec, KEYS: make the code in bzImage64_verify_sig generic
> >      Date: Thu Jul 14 21:40:25 2022 +0800
> >      3 files changed, 25 insertions(+), 19 deletions(-)
> >     [arm_key_5.15.y 40b98256cb89] arm64: kexec_file: use more system keyrings to verify kernel image signature
> >      Date: Thu Jul 14 21:40:26 2022 +0800
> >      1 file changed, 1 insertion(+), 10 deletions(-)
> 
> thanks, now queued up.

Nope, it causes build breakages in powerpc :(

See:
	https://lore.kernel.org/r/YwC6eQjx8xC9y3LD@debian
and
	https://lore.kernel.org/r/CA+G9fYtXnZP2vdAi4eU_ApC_YFz6TqTd6Eh5Mumb2=0Y_dK5Yw@mail.gmail.com

for the reports.  I'm dropping these from 5.15.y now, please fix this up
and resend if you want them included.

thanks,

greg k-h
