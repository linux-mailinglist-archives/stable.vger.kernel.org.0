Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58E159623C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 20:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiHPSPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 14:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236996AbiHPSPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 14:15:09 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3427E82FA8;
        Tue, 16 Aug 2022 11:15:07 -0700 (PDT)
Received: from [127.0.0.1] (dynamic-089-204-137-236.89.204.137.pool.telefonica.de [89.204.137.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 730CC1EC01D4;
        Tue, 16 Aug 2022 20:15:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1660673701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TSjMr0/SAf5Byfzo8LZakevLLdvnLz7vcX1LJaoLVPo=;
        b=BUJZuj1Fz7MQNDr8nVE3dnHvIefBxAAgD49dPyF+cNm2UMPfi5UAXw05ItAqI+RhcAAana
        sE33Pygi2lxG833JiFlCn4r847Xu8mRNUFrLrr5MUCUl4f4ciVdnGH5sc34lv2NLMTUk2t
        o4/32sPRGW57jVk0HPi1UPRg1Tj4mFg=
Date:   Tue, 16 Aug 2022 18:14:57 +0000
From:   Boris Petkov <bp@alien8.de>
To:     Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/nospec: Unwreck the RSB stuffing
In-Reply-To: <84f4b1ea-d837-9a53-a21c-4ac602ff8e75@linux.intel.com>
References: <20220809175513.345597655@linuxfoundation.org> <20220809175513.979067723@linuxfoundation.org> <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net> <839e2877-bb16-dbb5-d4da-bc611733c7e1@linux.intel.com> <84f4b1ea-d837-9a53-a21c-4ac602ff8e75@linux.intel.com>
Message-ID: <EA9514A1-7DD7-4707-A104-1A891B602B49@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On August 16, 2022 6:04:36 PM UTC, Daniel Sneddon <daniel=2Esneddon@linux=
=2Eintel=2Ecom> wrote:
>diff --git a/arch/x86/kernel/alternative=2Ec b/arch/x86/kernel/alternativ=
e=2Ec
>index 62f6b8b7c4a5=2E=2E5c476b37b3bc 100644
>--- a/arch/x86/kernel/alternative=2Ec
>+++ b/arch/x86/kernel/alternative=2Ec
>@@ -284,6 +284,9 @@ void __init_or_module noinline apply_alternatives(str=
uct
>alt_instr *start,
>                /* Mask away "NOT" flag bit for feature to test=2E */
>                u16 feature =3D a->cpuid & ~ALTINSTR_FLAG_INV;


I guess it is time for struct altinstr=2Eflags=2E I never liked this INV m=
ask bit=2E=2E=2E

>
>+               if (feature =3D=3D X86_FEATURE_NEVER)
>+                       goto next;
>+
>                instr =3D (u8 *)&a->instr_offset + a->instr_offset;
>                replacement =3D (u8 *)&a->repl_offset + a->repl_offset;
>                BUG_ON(a->instrlen > sizeof(insn_buff));
>


--=20
Sent from a small device: formatting sux and brevity is inevitable=2E 
