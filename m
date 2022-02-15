Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69164B6928
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 11:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiBOKYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 05:24:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236458AbiBOKYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 05:24:18 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2EA22BC0
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 02:24:08 -0800 (PST)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1F98B1EC053C;
        Tue, 15 Feb 2022 11:23:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1644920639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YMEDspMueOD9ny1l4hFIylPEZFOXYFx2U0095V28zwk=;
        b=P5VdaizqzMiRFWOmyV4HlFBxmzoca+iGR2xKTrDbb3xERvDfbywq8DlOoPUgBkLrA3vZQo
        9PmoGaHkWXGKFUkoukVszGXGu8kM3R3mmOXDf50vn9KU/CYcGSJgjSR6LB9YqBgEP8hfwi
        Y24GQTXajM+Awd7RPS/4WbQ8IWrcKJY=
Date:   Tue, 15 Feb 2022 11:24:01 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Message-ID: <Ygt/QSTSMlUJnzFS@zn.tnic>
References: <5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com>
 <YgqToxbGQluNHABF@zn.tnic>
 <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
 <YgrltbToK8+tG2qK@zn.tnic>
 <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 04:20:14PM -0800, Pawan Gupta wrote:
> ... we are calling tsx_clear_cpuid() unconditionally.

I know, that's why I asked...

> > If those CPUs which support only disabling TSX through MSR_IA32_TSX_CTRL
> > but don't have MSR_TSX_FORCE_ABORT - if those CPUs set
> > X86_FEATURE_RTM_ALWAYS_ABORT too, then this should work.

... this^^.

IOW, what are you fixing here exactly?

Let's look at the two callsites of tsx_clear_cpuid():

1. tsx_init: that will do something on X86_FEATURE_RTM_ALWAYS_ABORT CPUs.

2. init_intel: that will get called when

	tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT

But TSX_CTRL_RTM_ALWAYS_ABORT gets set only when
X86_FEATURE_RTM_ALWAYS_ABORT is set. I.e., the first case, in
tsx_init().

So, IIUC, you wanna fix the case where CPUs which set
X86_FEATURE_RTM_ALWAYS_ABORT but *don't* have MSR_TSX_FORCE_ABORT, those
CPUs should still disable TSX through MSR_IA32_TSX_CTRL.

Correct?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
