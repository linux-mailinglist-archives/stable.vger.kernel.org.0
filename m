Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37EA599DB6
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 16:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348991AbiHSOlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 10:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348837AbiHSOlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 10:41:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396CCED02A
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 07:41:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C555461199
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 14:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B75C433D6;
        Fri, 19 Aug 2022 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660920079;
        bh=BxW/3UJo6cgR/f10Q+2TotopTdno/FQzb+ganzP0dcQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rOyBUQD8sR7FMmr6hldKdcjKFNlZGjKoN28FZqjcHOEXCBRx3cAgc+BUYf2JZkAHi
         5c5QdD2G0t5/Q5GHRl2mOYTbU7exbsNgS3KX9vs9oeL06TBNs8H2pk6T+K04fhxRhE
         clSvpXmDi3UQXj/gsqHj7/ERY7TeKIe1kGkJGs54=
Date:   Fri, 19 Aug 2022 16:41:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coiby Xu <coxu@redhat.com>
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.15-stable tree
Message-ID: <Yv+hC9QyHn55uVAo@kroah.com>
References: <16605775859368@kroah.com>
 <20220818040938.pllzarythgusnyzf@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818040938.pllzarythgusnyzf@Rk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 12:09:38PM +0800, Coiby Xu wrote:
> Hi Greg,
> 
> This patch depends on three prerequisites. This full list of commit ids
> should be backported is shown below,
> 
> 1. 65d9a9a60fd7 ("kexec_file: drop weak attribute from functions")
> 2. 689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
> 3. c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
> 4. 0d519cadf751 ("arm64: kexec_file: use more system keyrings to verify kernel image signature")
> 
> And I can confirm they can be applied to linux-5.15.y branch
> successfully,
>     $ git checkout -b arm_key_5.15.y stable/linux-5.15.y
>     branch 'arm_key_5.15.y' set up to track 'stable/linux-5.15.y'.
>     Switched to a new branch 'arm_key_5.15.y'
>     $ git cherry-pick 65d9a9a60fd7 689a71493bd2 c903dae8941d 0d519cadf751
>     Auto-merging arch/arm64/include/asm/kexec.h
>     Auto-merging arch/powerpc/include/asm/kexec.h
>     Auto-merging arch/s390/include/asm/kexec.h
>     Auto-merging arch/x86/include/asm/kexec.h
>     Auto-merging include/linux/kexec.h
>     Auto-merging kernel/kexec_file.c
>     [arm_key_5.15.y 7c7844771360] kexec_file: drop weak attribute from functions
>      Author: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>      Date: Fri Jul 1 13:04:04 2022 +0530
>      6 files changed, 61 insertions(+), 40 deletions(-)
>     Auto-merging include/linux/kexec.h
>     Auto-merging kernel/kexec_file.c
>     [arm_key_5.15.y 4283e2681d86] kexec: clean up arch_kexec_kernel_verify_sig
>      Date: Thu Jul 14 21:40:24 2022 +0800
>      2 files changed, 13 insertions(+), 25 deletions(-)
>     Auto-merging include/linux/kexec.h
>     Auto-merging kernel/kexec_file.c
>     [arm_key_5.15.y c0cf50b9056f] kexec, KEYS: make the code in bzImage64_verify_sig generic
>      Date: Thu Jul 14 21:40:25 2022 +0800
>      3 files changed, 25 insertions(+), 19 deletions(-)
>     [arm_key_5.15.y 40b98256cb89] arm64: kexec_file: use more system keyrings to verify kernel image signature
>      Date: Thu Jul 14 21:40:26 2022 +0800
>      1 file changed, 1 insertion(+), 10 deletions(-)

thanks, now queued up.

greg k-h
