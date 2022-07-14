Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3426F575259
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 18:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiGNQBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 12:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiGNQBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 12:01:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3237E15A03;
        Thu, 14 Jul 2022 09:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5A4A61FD6;
        Thu, 14 Jul 2022 16:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB72C34114;
        Thu, 14 Jul 2022 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657814469;
        bh=KW36fiDdd/VMDpKD/6Q7toG5lBwxSVebvEd9T4QRPx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KgE475X3ybdFezB0Oly95qbl9WLtvxZ8GqMKNHijCSRaKYts273nZ1ziA3CBaZWmk
         zVw50nHLb+CObD33nIHArY1HSwGUt8ajnoi7O/UeQWWrEBo5RBYu8VT9vrevGqBVcQ
         mmP5+Kn4nc4HC/UyamWc26ElX5dWoVwWJZqLL55HB/XwJKJ/r8cQ93nyy9sm4/YE2c
         ZE/69bU3aXguHi+E8ER1AaA+u+sPcbpJOMn2jUsQsIW0sBz6gsk4yF7/my97nnof1w
         ZtjIlsCj97nN7lkQFzscqX6okEeVFUCOvqXzsYeRsi0LoPfk5HMchv/owRIcEH63uk
         xyZUchucEcIVw==
Date:   Thu, 14 Jul 2022 09:01:06 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH] x86/bugs: Switch to "auto" when "ibrs" selected on
 Enhanced IBRS parts
Message-ID: <20220714160106.c6efowo6ptsu72ne@treble>
References: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
 <Ys/7RiC9Z++38tzq@quatroqueijos>
 <YtABEwRnWrJyIKTY@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YtABEwRnWrJyIKTY@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 01:42:11PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 14, 2022 at 08:17:26AM -0300, Thadeu Lima de Souza Cascardo wrote:
> > On Wed, Jul 13, 2022 at 10:32:37PM -0700, Pawan Gupta wrote:
> > > Currently spectre_v2=ibrs forces write to MSR_IA32_SPEC_CTRL at every
> > > entry and exit. On Enhanced IBRS parts setting MSR_IA32_SPEC_CTRL[IBRS]
> > > only once at bootup is sufficient. MSR write at every kernel entry/exit
> > > incur unnecessary penalty that can be avoided.
> > > 
> > > When Enhanced IBRS feature is present, switch from "ibrs" to "auto" mode
> > > so that appropriate mitigation is selected.
> > > 
> > > Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
> > > Cc: stable@vger.kernel.org # 5.10+
> > > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/bugs.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> > > index 0dd04713434b..7d7ebfdfbeda 100644
> > > --- a/arch/x86/kernel/cpu/bugs.c
> > > +++ b/arch/x86/kernel/cpu/bugs.c
> > > @@ -1303,6 +1303,12 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
> > >  		return SPECTRE_V2_CMD_AUTO;
> > >  	}
> > >  
> > > +	if (cmd == SPECTRE_V2_CMD_IBRS && boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
> > > +		pr_err("%s selected but CPU supports Enhanced IBRS. Switching to AUTO select\n",
> > > +		       mitigation_options[i].option);
> > > +		return SPECTRE_V2_CMD_AUTO;
> > > +	}
> > > +
> > >  	spec_v2_print_cond(mitigation_options[i].option,
> > >  			   mitigation_options[i].secure);
> > >  	return cmd;
> > > 
> > > base-commit: 72a8e05d4f66b5af7854df4490e3135168694b6b
> > > -- 
> > > 2.35.3
> > > 
> > > 
> > 
> > Shouldn't we just use the mitigation the user asked for if it is still
> > possible? We could add the warning advising the user that a different
> > mitigation could be used instead with less penalty, but if the user asked for
> > IBRS and that is available, it should be used.
> > 
> > One of the reasons for that is testing. I know it was useful enough for me and
> > it helped me find some bugs.
> 
> Yeah this; if the user asks for IBRS, we should give him IBRS. I hate
> the 'I know better, let me change that for you' mentality.

eIBRS CPUs don't even have legacy IBRS so I don't see how this is even
possible.

-- 
Josh
