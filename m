Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD83575146
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 16:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbiGNO70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 10:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239716AbiGNO7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 10:59:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D890518B36;
        Thu, 14 Jul 2022 07:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657810764; x=1689346764;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3aDp65fTRK/qEt1CuYuJTQdXl0hXhYuKHzT1cCAHkRk=;
  b=HdaZea/I1TBBZ2PSqBKF/+6L0rTcNEtM1gy+d1GSmkMfaXi1e0L/bFN/
   SdrHSe1e/IHE9E8v2ueeYKHlurvikWpD2zDVEt+Ipnwblu1LHPVyIJkvz
   6oHfLPsDUq567ZPGSKf5khbWDE7ndbHxDsQ4eNLLCQEre5YA9XRzReNTr
   s3HL7hvbaFRoV5d5hfEjA6opXrbQd3PoGscZBlYZhyP/Ol965IhYlSFwj
   81MTcaNnh7/7121ckJGM++gPaOJGNL7qhcdTT13xl9/Z48BqpI+QHHq1D
   lzvIlBazClRc2Xfkal4dnLQnQJuKU5/gOJPyY+AJHvOO0Db0nKY8QE3UT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286671465"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="286671465"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 07:59:24 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="593395611"
Received: from jacobode-mobl.amr.corp.intel.com (HELO desk) ([10.212.243.89])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 07:59:24 -0700
Date:   Thu, 14 Jul 2022 07:59:22 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
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
Message-ID: <20220714145922.vs5to67omdzv6nmp@desk>
References: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
 <Ys/7RiC9Z++38tzq@quatroqueijos>
 <YtABEwRnWrJyIKTY@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <YtABEwRnWrJyIKTY@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 01:42:11PM +0200, Peter Zijlstra wrote:
>On Thu, Jul 14, 2022 at 08:17:26AM -0300, Thadeu Lima de Souza Cascardo wrote:
>> On Wed, Jul 13, 2022 at 10:32:37PM -0700, Pawan Gupta wrote:
>> > Currently spectre_v2=ibrs forces write to MSR_IA32_SPEC_CTRL at every
>> > entry and exit. On Enhanced IBRS parts setting MSR_IA32_SPEC_CTRL[IBRS]
>> > only once at bootup is sufficient. MSR write at every kernel entry/exit
>> > incur unnecessary penalty that can be avoided.
>> >
>> > When Enhanced IBRS feature is present, switch from "ibrs" to "auto" mode
>> > so that appropriate mitigation is selected.
>> >
>> > Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
>> > Cc: stable@vger.kernel.org # 5.10+
>> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>> > ---
>> >  arch/x86/kernel/cpu/bugs.c | 6 ++++++
>> >  1 file changed, 6 insertions(+)
>> >
>> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
>> > index 0dd04713434b..7d7ebfdfbeda 100644
>> > --- a/arch/x86/kernel/cpu/bugs.c
>> > +++ b/arch/x86/kernel/cpu/bugs.c
>> > @@ -1303,6 +1303,12 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
>> >  		return SPECTRE_V2_CMD_AUTO;
>> >  	}
>> >
>> > +	if (cmd == SPECTRE_V2_CMD_IBRS && boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
>> > +		pr_err("%s selected but CPU supports Enhanced IBRS. Switching to AUTO select\n",
>> > +		       mitigation_options[i].option);
>> > +		return SPECTRE_V2_CMD_AUTO;
>> > +	}
>> > +
>> >  	spec_v2_print_cond(mitigation_options[i].option,
>> >  			   mitigation_options[i].secure);
>> >  	return cmd;
>> >
>> > base-commit: 72a8e05d4f66b5af7854df4490e3135168694b6b
>> > --
>> > 2.35.3
>> >
>> >
>>
>> Shouldn't we just use the mitigation the user asked for if it is still
>> possible? We could add the warning advising the user that a different
>> mitigation could be used instead with less penalty, but if the user asked for
>> IBRS and that is available, it should be used.
>>
>> One of the reasons for that is testing. I know it was useful enough for me and
>> it helped me find some bugs.
>
>Yeah this; if the user asks for IBRS, we should give him IBRS. I hate
>the 'I know better, let me change that for you' mentality.
>
>If you want to do something, print a warning.

Fair enough, I will change that to a warning.

Thanks,
Pawan
