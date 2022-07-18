Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAE557875E
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 18:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbiGRQ25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 12:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiGRQ2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 12:28:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4702AC55;
        Mon, 18 Jul 2022 09:28:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CE006202EE;
        Mon, 18 Jul 2022 16:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658161712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9b4Wqp8N5OITLHBHNLTdaMUCfhXN9N9nneM6F+8cgIM=;
        b=oyczfGqqfhAeG+kWYNBxlKge0MxJjFa0h+av/G+GeqrT1PDjxPB1tydLNMOyBfF4MxomJA
        CkgbQwqxTRLY/Ex1L1rLasRRvau+YLhXC4f4TYUjOcXYBSHdvklKiqvl/CIkFsfRZggwbF
        m+HsOctQFz1AWH9vPD3r3af0vIXvIPQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658161712;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9b4Wqp8N5OITLHBHNLTdaMUCfhXN9N9nneM6F+8cgIM=;
        b=DnbCGbA6B+uRIRtyaPFImifiyxs9XZcSx+uOPKpUeW1GTSiA88i5PFt0sZMPJIAY0wM61S
        GSq/qmGzjtcrIFCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BF7E613A37;
        Mon, 18 Jul 2022 16:28:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9xCzLjCK1WLcdgAAMHmgww
        (envelope-from <bp@suse.de>); Mon, 18 Jul 2022 16:28:32 +0000
Date:   Mon, 18 Jul 2022 18:28:27 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        x86@kernel.org, ardb@kernel.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Poimboeuf <jpoimboe@kernel.org>, stable@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
Message-ID: <YtWKK2ZLib1R7itI@zn.tnic>
References: <20220715194550.793957-1-cascardo@canonical.com>
 <YtVG8VBmFikS6GMn@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YtVG8VBmFikS6GMn@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 18, 2022 at 01:41:37PM +0200, Peter Zijlstra wrote:
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 10a3bfc1eb23..f934dcdb7c0d 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -297,6 +297,8 @@ do {									\
>  	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
>  			      spec_ctrl_current() | SPEC_CTRL_IBRS,	\
>  			      X86_FEATURE_USE_IBRS_FW);			\
> +	altnerative_msr_write(MSR_IA32_PRED_CMD, PRED_CMD_IBPB,		\
> +			      X86_FEATURE_USE_IBPB_FW);			\
>  } while (0)

So I'm being told we need to untrain on return from EFI to protect the
kernel from it. Ontop of yours.

Asm looks correct but lemme run it through the test builds first...

---
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 38a3e86e665e..e58f18555022 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -62,6 +62,12 @@
 	dec	reg;				\
 	jnz	771b;
 
+#ifdef CONFIG_CPU_UNRET_ENTRY
+#define CALL_ZEN_UNTRAIN_RET	"call zen_untrain_ret"
+#else
+#define CALL_ZEN_UNTRAIN_RET	""
+#endif
+
 #ifdef __ASSEMBLY__
 
 /*
@@ -128,12 +134,6 @@
 .Lskip_rsb_\@:
 .endm
 
-#ifdef CONFIG_CPU_UNRET_ENTRY
-#define CALL_ZEN_UNTRAIN_RET	"call zen_untrain_ret"
-#else
-#define CALL_ZEN_UNTRAIN_RET	""
-#endif
-
 /*
  * Mitigate RETBleed for AMD/Hygon Zen uarch. Requires KERNEL CR3 because the
  * return thunk isn't mapped into the userspace tables (then again, AMD
@@ -169,6 +169,16 @@ extern void __x86_return_thunk(void);
 extern void zen_untrain_ret(void);
 extern void entry_ibpb(void);
 
+#if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_IBPB_ENTRY)
+# define UNTRAIN_RET						\
+	asm volatile(ALTERNATIVE_2(ANNOTATE_RETPOLINE_SAFE "nop", \
+		     CALL_ZEN_UNTRAIN_RET, X86_FEATURE_UNRET,	\
+		     "call entry_ibpb", X86_FEATURE_ENTRY_IBPB)	\
+		     ::)
+#else
+# define UNTRAIN_RET
+#endif
+
 #ifdef CONFIG_RETPOLINE
 
 #define GEN(reg) \
@@ -306,6 +316,7 @@ do {									\
 	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
 			      spec_ctrl_current(),			\
 			      X86_FEATURE_USE_IBRS_FW);			\
+	UNTRAIN_RET;							\
 	preempt_enable();						\
 } while (0)
 

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
