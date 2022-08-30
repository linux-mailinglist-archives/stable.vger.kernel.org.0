Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F88A5A647C
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 15:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiH3NO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 09:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiH3NOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 09:14:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD55CD34DB
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 06:14:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1EA3B81B86
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 13:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA85C4314B;
        Tue, 30 Aug 2022 13:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661865273;
        bh=sfy8qyT3bwz/Re/91xvKl4V0IPR9XNd5ClAO2FAIGjs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WWg8SB6XjIMLqwktpHLmZBG7L2ATZaeRdKMzEvujLbgTUXAqFTBLWLINQS6YpExVK
         yCNy/oOX5y2thz03O7VSUV9BsH7vbebjmIO/fORw2x24PySHSM5XIDccX/p3L4icbX
         ClzYZL5IvuRFD5ibAeSIqknglByDC7r/vB2V7REA=
Date:   Tue, 30 Aug 2022 15:14:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lucas Wei <lucaswei@google.com>
Cc:     stable@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Will Deacon <willdeacon@google.com>,
        Robin Peng <robinpeng@google.com>,
        Aaron Ding <aaronding@google.com>
Subject: Re: Request to cherry-pick into v5.15: arm64: errata: Add
 Cortex-A510 to the repeat tlbi list
Message-ID: <Yw4NNohloar87zVX@kroah.com>
References: <CAPTxkvQJHAxYOSmXCro7Cf1uR4y202HTrYLVPCY0JNGc30Y0aA@mail.gmail.com>
 <CAPTxkvQXXeawY-LmmfVsM76MCUOQHRRQN=Sim7Fza0s0aAY6Rw@mail.gmail.com>
 <Yw2mylTWhMxTSSHY@kroah.com>
 <CAPTxkvTXTcbxsGY_oPQp53p-HYu6WizabyJ8L1B74s86G=o7Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPTxkvTXTcbxsGY_oPQp53p-HYu6WizabyJ8L1B74s86G=o7Bg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 09:00:40PM +0800, Lucas Wei wrote:
> Hi Greg,
> 
> For v5.19, I can cherry-pick this patch directly from commit
> 39fdb65f52e9 ("arm64:
> errata: Add Cortex-A510 to the repeat tlbi list") to linux-5.19.y
> without conflicts.
> For v5.15, below is my working backport based on linux-5.15.y.
> 
> Please let me know if anything can be refined or needs to be changed.
> Thanks for your help and review!
> ----
> >From d4722275e4d7b686dc79363159e141b71f62f7d4 Mon Sep 17 00:00:00 2001
> From: James Morse <james.morse@arm.com>
> Date: Mon, 4 Jul 2022 16:57:32 +0100
> Subject: [PATCH] arm64: errata: Add Cortex-A510 to the repeat tlbi list
> 
> Cortex-A510 is affected by an erratum where in rare circumstances the
> CPUs may not handle a race between a break-before-make sequence on one
> CPU, and another CPU accessing the same page. This could allow a store
> to a page that has been unmapped.
> 
> Work around this by adding the affected CPUs to the list that needs
> TLB sequences to be done twice.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Link: https://lore.kernel.org/r/20220704155732.21216-1-james.morse@arm.com
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Lucas Wei <lucaswei@google.com>
> ---
>  Documentation/arm64/silicon-errata.rst |  2 ++
>  arch/arm64/Kconfig                     | 17 +++++++++++++++++
>  arch/arm64/kernel/cpu_errata.c         |  8 +++++++-
>  3 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/arm64/silicon-errata.rst
> b/Documentation/arm64/silicon-errata.rst
> index 7c1750bcc5bd..46644736e583 100644
> --- a/Documentation/arm64/silicon-errata.rst
> +++ b/Documentation/arm64/silicon-errata.rst
> @@ -92,6 +92,8 @@ stable kernels.
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A77      | #1508412        |
> ARM64_ERRATUM_1508412       |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Cortex-A510     | #2441009        |
> ARM64_ERRATUM_2441009       |
> ++----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-N1     | #1188873,1418040|
> ARM64_ERRATUM_1418040       |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-N1     | #1349291        | N/A
>              |
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 69e7e293f72e..9d80c783142f 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -666,6 +666,23 @@ config ARM64_ERRATUM_1508412
> 
>     If unsure, say Y.
> 
> +config ARM64_ERRATUM_2441009
> + bool "Cortex-A510: Completion of affected memory accesses might not
> be guaranteed by completion of a TLBI"
> + default y
> + select ARM64_WORKAROUND_REPEAT_TLBI
> + help
> +   This option adds a workaround for ARM Cortex-A510 erratum #2441009.
> +
> +   Under very rare circumstances, affected Cortex-A510 CPUs
> +   may not handle a race between a break-before-make sequence on one
> +   CPU, and another CPU accessing the same page. This could allow a
> +   store to a page that has been unmapped.
> +
> +   Work around this by adding the affected CPUs to the list that needs
> +   TLB sequences to be done twice.
> +
> +   If unsure, say Y.
> +
>  config CAVIUM_ERRATUM_22375
>   bool "Cavium erratum 22375, 24313"
>   default y
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index c67c19d70159..e1be45fc7f5b 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -211,6 +211,12 @@ static const struct arm64_cpu_capabilities
> arm64_repeat_tlbi_list[] = {
>   /* Kryo4xx Gold (rcpe to rfpe) => (r0p0 to r3p0) */
>   ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
>   },
> +#endif
> +#ifdef CONFIG_ARM64_ERRATUM_2441009
> + {
> + /* Cortex-A510 r0p0 -> r1p1. Fixed in r1p2 */
> + ERRATA_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1),
> + },
>  #endif
>   {},
>  };
> @@ -427,7 +433,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  #endif
>  #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
>   {
> - .desc = "Qualcomm erratum 1009, or ARM erratum 1286807",
> + .desc = "Qualcomm erratum 1009, or ARM erratum 1286807, 2441009",
>   .capability = ARM64_WORKAROUND_REPEAT_TLBI,
>   .type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
>   .matches = cpucap_multi_entry_cap_matches,


This patch is corrupted and obviously can not be applied :(

Please fix up your email client to not do this.

thanks,

greg k-h
