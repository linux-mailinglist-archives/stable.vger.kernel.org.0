Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA624599DE6
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 16:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349128AbiHSOs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 10:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349401AbiHSOs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 10:48:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61162D11C3
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 07:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE851614B4
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 14:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E30C433C1;
        Fri, 19 Aug 2022 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660920535;
        bh=hzY2hqK680QaEYaXvYeAdm32C1R9w2KWJXae+f/Y8Ow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SrsXQJgOLUyDixqSlFOQjF1QMz1pAFgM4CuBS6Iz3Upk0rMx5BOA+pZx0Kfsdi/kQ
         bbk3+0iRSTNC7OANFOqqG3XB8TL1ZKpPTRJCHdWybQ+TtJGdx/OB7ixpVOI8sePTco
         dU+ytnJCjiyo4tdGJLlVa5XLk6+zy+2LJSZCKZ4Q=
Date:   Fri, 19 Aug 2022 16:48:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coiby Xu <coxu@redhat.com>
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.10-stable tree
Message-ID: <Yv+i1Eo+0c+nw5/n@kroah.com>
References: <166057758686253@kroah.com>
 <20220818041536.5urxrunzmdawkdh7@Rk>
 <Yv+hy5nWTPpei0C5@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv+hy5nWTPpei0C5@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 04:44:27PM +0200, Greg KH wrote:
> On Thu, Aug 18, 2022 at 12:15:36PM +0800, Coiby Xu wrote:
> > Hi Greg,
> > 
> > 
> > This patch depends on three prerequisites. This full list of commit ids
> > should be backported is shown below,
> > 
> > 1. 65d9a9a60fd7 ("kexec_file: drop weak attribute from functions")
> > 2. 689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
> > 3. c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
> > 4. 0d519cadf751 ("arm64: kexec_file: use more system keyrings to verify kernel image signature")
> > 
> > $ git checkout -b arm_key_5.10.y stable/linux-5.10.y
> > Updating files: 100% (33255/33255), done.
> > branch 'arm_key_5.10.y' set up to track 'stable/linux-5.10.y'.
> > Switched to a new branch 'arm_key_5.10.y'
> > $ git cherry-pick 65d9a9a60fd7 689a71493bd2 c903dae8941d 0d519cadf751
> > Auto-merging arch/arm64/include/asm/kexec.h
> > Auto-merging arch/powerpc/include/asm/kexec.h
> > Auto-merging arch/s390/include/asm/kexec.h
> > Auto-merging arch/x86/include/asm/kexec.h
> > Auto-merging include/linux/kexec.h
> > Auto-merging kernel/kexec_file.c
> > [arm_key_5.10.y 624dfcf3b8de] kexec_file: drop weak attribute from functions
> >  Author: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> >  Date: Fri Jul 1 13:04:04 2022 +0530
> >  6 files changed, 61 insertions(+), 40 deletions(-)
> > Auto-merging include/linux/kexec.h
> > Auto-merging kernel/kexec_file.c
> > [arm_key_5.10.y da8cfa52682e] kexec: clean up arch_kexec_kernel_verify_sig
> >  Date: Thu Jul 14 21:40:24 2022 +0800
> >  2 files changed, 13 insertions(+), 25 deletions(-)
> > Auto-merging arch/x86/kernel/kexec-bzimage64.c
> > Auto-merging include/linux/kexec.h
> > Auto-merging kernel/kexec_file.c
> > [arm_key_5.10.y 0bb032082ce6] kexec, KEYS: make the code in bzImage64_verify_sig generic
> >  Date: Thu Jul 14 21:40:25 2022 +0800
> >  3 files changed, 25 insertions(+), 19 deletions(-)
> > [arm_key_5.10.y fde64a36fa74] arm64: kexec_file: use more system keyrings to verify kernel image signature
> >  Date: Thu Jul 14 21:40:26 2022 +0800
> >  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> Now queued up, thanks.

Ooops, nope, that broke the build:

ld: kernel/kexec_file.o: in function `kimage_file_post_load_cleanup':
kexec_file.c:(.text+0xde0): undefined reference to `arch_kimage_file_post_load_cleanup'
make: *** [Makefile:1193: vmlinux] Error 1

Please send me the full set of patches needed here to get this to work,
if it's really needed in the 5.10.y tree.

thanks,

greg k-h
