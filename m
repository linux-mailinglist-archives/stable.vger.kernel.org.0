Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82FD5856BA
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 00:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbiG2WCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 18:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiG2WCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 18:02:46 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694CA8BA9A;
        Fri, 29 Jul 2022 15:02:45 -0700 (PDT)
Received: from zn.tnic (p57969665.dip0.t-ipconnect.de [87.150.150.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 853D51EC0138;
        Sat, 30 Jul 2022 00:02:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1659132159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=wrKILRxKPGwT6wk7Ajnr1TkkdTUDvWFahFhfVMdrEgo=;
        b=pF1+1BfCwH1/XXlJBgjJaV3EOTk7Sb+S85dpADswCkM4pOFd9M1e5rnX5mLTii8V7XMaZM
        tlVZsJmBjozOkuVowGtAo+7tV7vNoCfN3CZRuy90COxQzqHWmY3c79eWu9xL6gM+npY3pG
        Xta7lO/9dqvyipNeTNUNOfck0CH2Df0=
Date:   Sat, 30 Jul 2022 00:02:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        andrew.cooper3@citrix.com, Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Message-ID: <YuRY+rKaocoV8ECn@zn.tnic>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic>
 <20220729022851.mdj3wuevkztspodh@desk>
 <YuPpKa6OsG9e9nTj@zn.tnic>
 <20220729173609.45o7lllpvsgjttqt@desk>
 <YuRDbuQPYiYBZghm@zn.tnic>
 <20220729214627.wowu5sny226c5pe4@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220729214627.wowu5sny226c5pe4@desk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 29, 2022 at 02:46:27PM -0700, Pawan Gupta wrote:
> Let me see if there is a way to distinguish between 4. and 5. below:
> 
>    CPU category				  X86_BUG_MMIO_STALE_DATA	X86_BUG_MMIO_UNKNOWN
> -----------------------------------------------------------------------------------------------
> 1. Known affected (in cpu list)			1				0
> 2. CPUs with HW immunity (MMIO_NO=1)		0				0
> 3. Other vendors				0				0
> 4. Older Intel CPUs				0				1
> 5. Not affected current CPUs (but MMIO_NO=0)	0				?

Not affected current CPUs should be arch_cap_mmio_immune() == true, no?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
