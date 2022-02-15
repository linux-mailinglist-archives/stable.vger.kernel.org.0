Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56934B7820
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243673AbiBOTeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 14:34:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243675AbiBOTeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 14:34:03 -0500
X-Greylist: delayed 32989 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 11:33:53 PST
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E355C1CB8;
        Tue, 15 Feb 2022 11:33:53 -0800 (PST)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DB31E1EC0518;
        Tue, 15 Feb 2022 20:33:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1644953628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=meapHTkDicDHTqTRDUN8X2JnxCKucH0EDtj9t2Mp+f8=;
        b=pJFTcQAnhEGXoRv7eZbwUIX2WRgVwGwSsGH8+boQ6QAAU+41nKDaDQZW8rMypTNB1Z0+F1
        RZBy72AJlO8niJCkhI65qrgBgHOXxGZ+ZShnx0pBTPpm4ov0vFrNepzh14/4j24Hlbkkxe
        vix9Bf/cCr1dVBVjsSTv3XErNsLgjPo=
Date:   Tue, 15 Feb 2022 20:33:49 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Message-ID: <YgwAHU7gCnik8Kv6@zn.tnic>
References: <5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com>
 <YgqToxbGQluNHABF@zn.tnic>
 <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
 <YgrltbToK8+tG2qK@zn.tnic>
 <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
 <Ygt/QSTSMlUJnzFS@zn.tnic>
 <20220215121103.vhb2lpoygxn3xywy@guptapa-mobl1.amr.corp.intel.com>
 <YgvVcdpmFCCn20A7@zn.tnic>
 <20220215181931.wxfsn2a3npg7xmi2@guptapa-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220215181931.wxfsn2a3npg7xmi2@guptapa-mobl1.amr.corp.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 10:19:31AM -0800, Pawan Gupta wrote:
> I admit it has gotten complicated with so many bits associated with TSX.

Yah, and looka here:

https://github.com/andyhhp/xen/commit/ad9f7c3b2e0df38ad6d54f4769d4dccf765fbcee

It seems it isn't complicated enough. ;-\

Andy just made me aware of this thing where you guys have added a new
MSR bit:

MSR_MCU_OPT_CTRL[1] which is called something like
MCU_OPT_CTRL_RTM_ALLOW or so. And lemme quote from that patch:

            /*
             * Probe for the February 2022 microcode which de-features TSX on
             * TAA-vulnerable client parts - WHL-R/CFL-R.
             *
             * RTM_ALWAYS_ABORT (read above) enumerates the new functionality,
             * but is read as zero if MCU_OPT_CTRL.RTM_ALLOW has been set
             * before we run.  Undo this.
             */

so MCU_OPT_CTRL.RTM_ALLOW=1 would have
CPUID.X86_FEATURE_RTM_ALWAYS_ABORT=0, which means, we cannot tie TSX disabling on
X86_FEATURE_RTM_ALWAYS_ABORT only.

So this would need more work, it seems to me.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
