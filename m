Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071965BF9AB
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 10:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiIUIsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 04:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiIUIrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 04:47:49 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50988992D;
        Wed, 21 Sep 2022 01:47:48 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e77f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e77f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2044A1EC026E;
        Wed, 21 Sep 2022 10:47:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663750063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=tzMHhEDZuTOBGQYO9nZSxmxDwWOqbotCVVhf4wZFx9I=;
        b=rNxXZgjonwEW/Ld03lcLz37OjGRogsgsOhBQKAj7qTCeRpoTWeJ38fWf72a/srUbmoE8oD
        967VuTVwVpj5dvvicWxSVXBZ2RpdTEc5M0SPtcunGBdz+AQNIwMM8nL97l3E5Wo3kuln+Q
        yeas9l0yzMdsu4N+/b35KJpW2qe/iIY=
Date:   Wed, 21 Sep 2022 10:47:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     K Prateek Nayak <kprateek.nayak@amd.com>
Cc:     linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, andi@lisas.de,
        puwen@hygon.cn, mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Message-ID: <YyrPqlo/ysCeh4qU@zn.tnic>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220921063638.2489-1-kprateek.nayak@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 12:06:38PM +0530, K Prateek Nayak wrote:
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 16a1663d02d4..18850aa2b79b 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -528,8 +528,11 @@ static int acpi_idle_bm_check(void)
>  static void wait_for_freeze(void)
>  {
>  #ifdef	CONFIG_X86
> -	/* No delay is needed if we are in guest */
> -	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
> +	/*
> +	 * No delay is needed if we are in guest or on a processor
> +	 * based on the Zen microarchitecture.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_HYPERVISOR) || boot_cpu_has(X86_FEATURE_ZEN))

s/boot_cpu_has/cpu_feature_enabled/g

while at it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
