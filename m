Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01484B6BC0
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 13:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235363AbiBOMLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 07:11:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiBOMLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 07:11:20 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E47AF68EA;
        Tue, 15 Feb 2022 04:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644927066; x=1676463066;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bvHEaZ2uSpy8y3b69ROVRV1b0rGK089uqW/KMJ+6S0E=;
  b=Pp9iUDi718wqnswlcyVor+N7Dyi3l1LNa4KpENcFCTjpVByfOINkw2Cz
   d4vgLkg2aWwQptB36jG8/2gjh84zvT6fHCmM81I/7rn0Yu/WIX7KirBc8
   iu0Vf6AxJ3P3FgFq7mpMOQD/onTlDfNzp8HhJZ9F/QibfFxyFd3VEsMpx
   L/u3LUlK3vxZMd5U8lGTzyW3KIMSsTzoaNVfnNpvdDxTCDAnWaAJvvpED
   fQreunBlPN25RoRYLq34d2A0KCBizzaY0aVhE3N1keZod0b9KfQp7x5dh
   vIrdj6TrWIf+aWtcIJfnHrdd8F7Xv0J+395JFnixtmEuMrWg+BpjWarIF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="237742214"
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="237742214"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 04:11:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="570794182"
Received: from guptapa-mobl1.amr.corp.intel.com ([10.212.198.79])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 04:11:05 -0800
Date:   Tue, 15 Feb 2022 04:11:03 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Message-ID: <20220215121103.vhb2lpoygxn3xywy@guptapa-mobl1.amr.corp.intel.com>
References: <5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com>
 <YgqToxbGQluNHABF@zn.tnic>
 <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
 <YgrltbToK8+tG2qK@zn.tnic>
 <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
 <Ygt/QSTSMlUJnzFS@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <Ygt/QSTSMlUJnzFS@zn.tnic>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.02.2022 11:24, Borislav Petkov wrote:
>On Mon, Feb 14, 2022 at 04:20:14PM -0800, Pawan Gupta wrote:
>> ... we are calling tsx_clear_cpuid() unconditionally.
>
>I know, that's why I asked...
>
>> > If those CPUs which support only disabling TSX through MSR_IA32_TSX_CTRL
>> > but don't have MSR_TSX_FORCE_ABORT - if those CPUs set
>> > X86_FEATURE_RTM_ALWAYS_ABORT too, then this should work.
>
>... this^^.
>
>IOW, what are you fixing here exactly?
>
>Let's look at the two callsites of tsx_clear_cpuid():
>
>1. tsx_init: that will do something on X86_FEATURE_RTM_ALWAYS_ABORT CPUs.
>
>2. init_intel: that will get called when
>
>	tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT
>
>But TSX_CTRL_RTM_ALWAYS_ABORT gets set only when
>X86_FEATURE_RTM_ALWAYS_ABORT is set. I.e., the first case, in
>tsx_init().
>
>So, IIUC, you wanna fix the case where CPUs which set
>X86_FEATURE_RTM_ALWAYS_ABORT but *don't* have MSR_TSX_FORCE_ABORT, those
>CPUs should still disable TSX through MSR_IA32_TSX_CTRL.
>
>Correct?

That is exactly what this patch is fixing. Please let me know if you
have any questions.

Thanks,
Pawan
