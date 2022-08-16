Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05805961DF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 20:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbiHPSFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 14:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbiHPSEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 14:04:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1990E8037E;
        Tue, 16 Aug 2022 11:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660673079; x=1692209079;
  h=message-id:date:mime-version:from:to:cc:references:
   subject:in-reply-to:content-transfer-encoding;
  bh=XDyk4xsCNE8jyvhJxm6j5J9uwtu4khyexzPx0UxIYes=;
  b=hOKyhRIoV3OUGK6kkvPcUa4V6nhQOZAN9Dzo5hBxtXw0hje6aST7YfW1
   MZZcAVyJA1Y4M3JK0qM7XZUEOUFd3WEhfIK1v56TwGdx8MI05V+O8fT0V
   G+nAlOo4MHnsBUhqIG0zHB3N7eUWgKynLUNP5IdYkn6rz9PkfIzPpzX/n
   X0X4dcBkD2hsheoxghCba1iaqsCxAoGEdRPzFaQlJ+uxQE+2GtVJ8ZNAR
   w4iH0lFy6g/YpF722wjBvCSwNAevDzwI26iGqDM+FQErs4iS29toIWCSc
   SrK/HNRbS5r/tJ7ApfTMVYgAsVGWbHCnsow0rBmWhZExGhRynqyB5/deO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="354036557"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="354036557"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 11:04:38 -0700
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="852742473"
Received: from jzhu1-mobl.ccr.corp.intel.com (HELO [10.254.68.75]) ([10.254.68.75])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 11:04:37 -0700
Message-ID: <84f4b1ea-d837-9a53-a21c-4ac602ff8e75@linux.intel.com>
Date:   Tue, 16 Aug 2022 11:04:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
From:   Daniel Sneddon <daniel.sneddon@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20220809175513.345597655@linuxfoundation.org>
 <20220809175513.979067723@linuxfoundation.org>
 <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
 <839e2877-bb16-dbb5-d4da-bc611733c7e1@linux.intel.com>
Subject: Re: [PATCH] x86/nospec: Unwreck the RSB stuffing
In-Reply-To: <839e2877-bb16-dbb5-d4da-bc611733c7e1@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/16/22 10:34, Daniel Sneddon wrote:
> On 8/16/22 05:28, Peter Zijlstra wrote:
> 
>>
>> Could you please test this; I've only compiled it.
>>
> When booting I get the following BUG:
> 
> ------------[ cut here ]------------
> kernel BUG at arch/x86/kernel/alternative.c:290!
> invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.0.0-rc1-00001-gb72b03c96999 #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1
> 04/01/2014
> RIP: 0010:apply_alternatives+0x287/0x2d0
> Code: 4c 29 f6 03 74 24 13 89 74 24 13 45 85 c0 0f 85 d2 41 e9 00 41 0f b6 02 83
> e0 fd 3c e9 0f 84 46 ff ff ff e9 5e fe ff ff 0f 0b <0f> 0b f7 c6 00 ff ff ff 0f
> 84 68 ff ff ff 8d 71 fb c6 44 24 12 e9
> RSP: 0000:ffffffff82c03d68 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: ffffffff83728c24 RCX: 0000000000007fff
> RDX: 00000000ffffffea RSI: 0000000000000000 RDI: 000000000000ffff
> RBP: ffffffff82c03d7a R08: e800000010c4c749 R09: 0001e8cc00000001
> R10: 10c48348cc000000 R11: e8ae0feb75ccff49 R12: ffffffff8372fcf8
> R13: 0000000000000000 R14: ffffffff81001a68 R15: 000000000000001f
> FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88813ffff000 CR3: 0000000002c0c001 CR4: 0000000000770ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  ? insn_get_opcode+0xef/0x1c0
>  ? ct_nmi_enter+0xb3/0x180
>  ? ct_nmi_exit+0xbe/0x1d0
>  ? irqentry_exit+0x2d/0x40
>  ? asm_common_interrupt+0x22/0x40
>  alternative_instructions+0x5b/0xf5
>  check_bugs+0xdaf/0xdef
>  start_kernel+0x66a/0x6a2
>  secondary_startup_64_no_verify+0xe0/0xeb
>  </TASK>
> Modules linked in:
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:apply_alternatives+0x287/0x2d0
> Code: 4c 29 f6 03 74 24 13 89 74 24 13 45 85 c0 0f 85 d2 41 e9 00 41 0f b6 02 83
> e0 fd 3c e9 0f 84 46 ff ff ff e9 5e fe ff ff 0f 0b <0f> 0b f7 c6 00 ff ff ff 0f
> 84 68 ff ff ff 8d 71 fb c6 44 24 12 e9
> RSP: 0000:ffffffff82c03d68 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: ffffffff83728c24 RCX: 0000000000007fff
> RDX: 00000000ffffffea RSI: 0000000000000000 RDI: 000000000000ffff
> RBP: ffffffff82c03d7a R08: e800000010c4c749 R09: 0001e8cc00000001
> R10: 10c48348cc000000 R11: e8ae0feb75ccff49 R12: ffffffff8372fcf8
> R13: 0000000000000000 R14: ffffffff81001a68 R15: 000000000000001f
> FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88813ffff000 CR3: 0000000002c0c001 CR4: 0000000000770ef0
> PKRU: 55555554
> Kernel panic - not syncing: Attempted to kill the idle task!
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---
> 
> 
> 
I can get it to work with the below changes.  I had to change the -1 to 0x7FFF
because bit 15 is masked out in apply_alternatives().  Not sure if that's the
right way to fix it, but it boots and has the correct assembly code in
vmx_vmexit, so the alternative does get applied correctly there.

---
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 1a31ae6d758b..c5b55c9f2849 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -420,7 +420,7 @@
 #define X86_FEATURE_V_TSC_AUX          (19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT       (19*32+10) /* "" AMD hardware-enforced
cache coherency */

-#define X86_FEATURE_NEVER              (-1) /* "" Logical complement of ALWAYS */
+#define X86_FEATURE_NEVER              (0x7FFF) /* "" Logical complement of
ALWAYS */

 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 62f6b8b7c4a5..5c476b37b3bc 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -284,6 +284,9 @@ void __init_or_module noinline apply_alternatives(struct
alt_instr *start,
                /* Mask away "NOT" flag bit for feature to test. */
                u16 feature = a->cpuid & ~ALTINSTR_FLAG_INV;

+               if (feature == X86_FEATURE_NEVER)
+                       goto next;
+
                instr = (u8 *)&a->instr_offset + a->instr_offset;
                replacement = (u8 *)&a->repl_offset + a->repl_offset;
                BUG_ON(a->instrlen > sizeof(insn_buff));

