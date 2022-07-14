Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0093B574C5C
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 13:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238003AbiGNLmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 07:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238281AbiGNLme (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 07:42:34 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719645B785;
        Thu, 14 Jul 2022 04:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ABDszamnq/YPR0BJynAgiWql0epYMQBc4h0m0YOmd/g=; b=ceetIMm+B4kMOQTz8DK4EQM0ah
        Ui4Vbxi2iIA1XT5HAQaevqiywyiQd9z/+5qyiy5vEXaK5qK6jKy77jnHg0nmZfU/MbCdfTxdMc6Sb
        fkkZBHmS01guDfQL3J61pEDqSy5AhqGRW+DYVSu9lmdRLzYgvGimXHnfoUHBFRTyPKh4YQMB5IhYx
        J+5JstAgMRimfAlsM5ZjoX6sv0lo28q28/WEFRkfn4uap3xYC4xMR2RMWT8E6ytw3j0eLmECZyd9f
        hed5W5NqDR7u8VR9TCni0Lc+WWXXkWbs7fkWa7N4BkUAnZSQTAqHe4OrBcGQZz65orJCSqR1rtC1J
        JZ4+PzeQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBxES-003pJj-Ly; Thu, 14 Jul 2022 11:42:13 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 04EBA98016F; Thu, 14 Jul 2022 13:42:12 +0200 (CEST)
Date:   Thu, 14 Jul 2022 13:42:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: [PATCH] x86/bugs: Switch to "auto" when "ibrs" selected on
 Enhanced IBRS parts
Message-ID: <YtABEwRnWrJyIKTY@worktop.programming.kicks-ass.net>
References: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
 <Ys/7RiC9Z++38tzq@quatroqueijos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys/7RiC9Z++38tzq@quatroqueijos>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 08:17:26AM -0300, Thadeu Lima de Souza Cascardo wrote:
> On Wed, Jul 13, 2022 at 10:32:37PM -0700, Pawan Gupta wrote:
> > Currently spectre_v2=ibrs forces write to MSR_IA32_SPEC_CTRL at every
> > entry and exit. On Enhanced IBRS parts setting MSR_IA32_SPEC_CTRL[IBRS]
> > only once at bootup is sufficient. MSR write at every kernel entry/exit
> > incur unnecessary penalty that can be avoided.
> > 
> > When Enhanced IBRS feature is present, switch from "ibrs" to "auto" mode
> > so that appropriate mitigation is selected.
> > 
> > Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
> > Cc: stable@vger.kernel.org # 5.10+
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/bugs.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> > index 0dd04713434b..7d7ebfdfbeda 100644
> > --- a/arch/x86/kernel/cpu/bugs.c
> > +++ b/arch/x86/kernel/cpu/bugs.c
> > @@ -1303,6 +1303,12 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
> >  		return SPECTRE_V2_CMD_AUTO;
> >  	}
> >  
> > +	if (cmd == SPECTRE_V2_CMD_IBRS && boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
> > +		pr_err("%s selected but CPU supports Enhanced IBRS. Switching to AUTO select\n",
> > +		       mitigation_options[i].option);
> > +		return SPECTRE_V2_CMD_AUTO;
> > +	}
> > +
> >  	spec_v2_print_cond(mitigation_options[i].option,
> >  			   mitigation_options[i].secure);
> >  	return cmd;
> > 
> > base-commit: 72a8e05d4f66b5af7854df4490e3135168694b6b
> > -- 
> > 2.35.3
> > 
> > 
> 
> Shouldn't we just use the mitigation the user asked for if it is still
> possible? We could add the warning advising the user that a different
> mitigation could be used instead with less penalty, but if the user asked for
> IBRS and that is available, it should be used.
> 
> One of the reasons for that is testing. I know it was useful enough for me and
> it helped me find some bugs.

Yeah this; if the user asks for IBRS, we should give him IBRS. I hate
the 'I know better, let me change that for you' mentality.

If you want to do something, print a warning.
