Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BEB4B808A
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 07:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiBPGIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 01:08:41 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBPGIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 01:08:40 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F50166E2C;
        Tue, 15 Feb 2022 22:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644991708; x=1676527708;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=17B1tG6qWPiba58hIphPz6b0Xse84huEgceNoiiY6q8=;
  b=kg+h0J72NQzfoQFb4Z2lxUmVL2LuC2eTmyhAQV0hlnkXr3w8NuBJw8D4
   e52HrJWsjFADQ9Wcj+CZrvLGfGAq6qy4qHLFgaWk8gcOWYvxIwVsBQUlQ
   SRIiElxwdSWWQlQTEOOTdCGQWQxAYGSGYa/JN9BKjP3vGRQa/tCRsPcKe
   Mjih9t2VGZqRMM8KOMU7e923QeEt9sAOr9K0hj17KksgsfX5V2R2YjUMe
   q1aZO4UGLUIWRHtfa0+bfeAX2IL4cA8SakqffjLlEcoEdAnTfRsQMm8Y1
   dWQmBT0ms8d54ZychM61O2c+DKvgUn32JcDbH07+PSlnzf9L5NjOeXr2G
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="311272240"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="311272240"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 22:08:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="486704058"
Received: from guptapa-mobl1.amr.corp.intel.com ([10.209.113.151])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 22:08:27 -0800
Date:   Tue, 15 Feb 2022 22:08:26 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Andrew Cooper <Andrew.Cooper3@citrix.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "antonio.gomez.iglesias@linux.intel.com" 
        <antonio.gomez.iglesias@linux.intel.com>,
        "neelima.krishnan@intel.com" <neelima.krishnan@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Message-ID: <20220216060826.dwki2jk6kzft4f7c@guptapa-mobl1.amr.corp.intel.com>
References: <YgrltbToK8+tG2qK@zn.tnic>
 <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
 <Ygt/QSTSMlUJnzFS@zn.tnic>
 <20220215121103.vhb2lpoygxn3xywy@guptapa-mobl1.amr.corp.intel.com>
 <YgvVcdpmFCCn20A7@zn.tnic>
 <20220215181931.wxfsn2a3npg7xmi2@guptapa-mobl1.amr.corp.intel.com>
 <YgwAHU7gCnik8Kv6@zn.tnic>
 <20220216003950.5jxecuf773g2kuwl@guptapa-mobl1.amr.corp.intel.com>
 <6724088f-c7cf-da92-e894-d8970f13bf1e@citrix.com>
 <20220216012841.vxlnugre2j4pczp7@guptapa-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220216012841.vxlnugre2j4pczp7@guptapa-mobl1.amr.corp.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.02.2022 17:28, Pawan Gupta wrote:
>On 16.02.2022 00:49, Andrew Cooper wrote:
>>On 16/02/2022 00:39, Pawan Gupta wrote:
>>>On 15.02.2022 20:33, Borislav Petkov wrote:
>>>>On Tue, Feb 15, 2022 at 10:19:31AM -0800, Pawan Gupta wrote:
>>>>>I admit it has gotten complicated with so many bits associated with
>>>>>TSX.
>>>>
>>>>Yah, and looka here:
>>>>
>>>>https://github.com/andyhhp/xen/commit/ad9f7c3b2e0df38ad6d54f4769d4dccf765fbcee
>>>>
>>>>
>>>>It seems it isn't complicated enough. ;-\
>>>>
>>>>Andy just made me aware of this thing where you guys have added a new
>>>>MSR bit:
>>>>
>>>>MSR_MCU_OPT_CTRL[1] which is called something like
>>>>MCU_OPT_CTRL_RTM_ALLOW or so.
>>>
>>>RTM_ALLOW bit was added to MSR_MCU_OPT_CTRL, but its not set by default,
>>>and it is *not* recommended to be used in production deployments [1]:
>>>
>>>  Although MSR 0x122 (TSX_CTRL) and MSR 0x123 (IA32_MCU_OPT_CTRL) can be
>>>  used to reenable Intel TSX for development, doing so is not recommended
>>>  for production deployments. In particular, applying MD_CLEAR flows for
>>>  mitigation of the Intel TSX Asynchronous Abort (TAA) transient
>>>execution
>>>  attack may not be effective on these processors when Intel TSX is
>>>  enabled with updated microcode. The processors continue to be mitigated
>>>  against TAA when Intel TSX is disabled.
>>
>>The purpose of setting RTM_ALLOW isn't to enable TSX per say.
>>
>>The purpose is to make MSR_TSX_CTRL.RTM_DISABLE behaves consistently on
>>all hardware, which reduces the complexity and invasiveness of dealing
>>with this special case, because the TAA workaround will still turn TSX
>>off by default.
>>
>>The configuration you don't want to be running with is RTM_ALLOW &&
>>!RTM_DISABLE, because that is "still vulnerable to TSX Async Abort".
>
>I am not sure how a system can end up with RTM_ALLOW && !RTM_DISABLE? I
>have no problem taking care of this case, I am just debating why we need
>it.
>
>One way to get to this state is BIOS sets RTM_ALLOW (dont know why?) and
>linux cmdline has tsx=on.

If RTM_ALLOW is set for any reason, we can still deny tsx=on request.
Below patch should do that (I haven't tested it yet).

Alternatively, we can reset RTM_ALLOW, which will set
CPUID.RTM_ALWAYS_ABORT and may require re-enumeration of CPU features or
otherwise setup_force_cpu_cap(X86_FEATURE_RTM_ALWAYS_ABORT) should also
work.

---
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3faf0f97edb1..2ef58bcfb1e4 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -131,6 +131,8 @@
  /* SRBDS support */
  #define MSR_IA32_MCU_OPT_CTRL		0x00000123
  #define RNGDS_MITG_DIS			BIT(0)
+#define MCU_OPT_CTRL_RTM_ALLOW		BIT(1)
+#define MCU_OPT_CTRL_RTM_LOCKED		BIT(2)
  
  #define MSR_IA32_SYSENTER_CS		0x00000174
  #define MSR_IA32_SYSENTER_ESP		0x00000175
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 2835fa89fc6f..8ac085ac597f 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -142,6 +142,29 @@ void tsx_clear_cpuid(void)
  	}
  }
  
+/*
+ * When the microcode released in Feb 2022 is applied, TSX will be disabled by
+ * default on some processors. MSR 0x122 (TSX_CTRL) and MSR 0x123
+ * (IA32_MCU_OPT_CTRL) can be used to re-enable TSX for development, doing so is
+ * not recommended for production deployments. In particular, applying MD_CLEAR
+ * flows for mitigation of the Intel TSX Asynchronous Abort (TAA) transient
+ * execution attack may not be effective on these processors when TSX is
+ * enabled with updated microcode.
+ *
+ * Detect if this unsafe TSX development mode is enabled.
+ */
+static bool tsx_is_unsafe(void)
+{
+	u64 mcu_opt_ctrl;
+
+	if (!boot_cpu_has(X86_FEATURE_SRBDS_CTRL))
+		return false;
+
+	rdmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_opt_ctrl);
+
+	return !!(mcu_opt_ctrl & MCU_OPT_CTRL_RTM_ALLOW);
+}
+
  void __init tsx_init(void)
  {
  	char arg[5] = {};
@@ -163,6 +186,13 @@ void __init tsx_init(void)
  	if (!tsx_ctrl_is_supported()) {
  		tsx_ctrl_state = TSX_CTRL_NOT_SUPPORTED;
  		return;
+	} else if (tsx_is_unsafe()) {
+		/* Do not allow tsx=on, when TSX is unsafe to use */
+		tsx_ctrl_state = TSX_CTRL_DISABLE;
+		tsx_disable();
+		setup_clear_cpu_cap(X86_FEATURE_RTM);
+		setup_clear_cpu_cap(X86_FEATURE_HLE);
+		return;
  	}
  
  	ret = cmdline_find_option(boot_command_line, "tsx", arg, sizeof(arg));
