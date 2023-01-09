Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A892663256
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237829AbjAIVKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237817AbjAIVKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 16:10:17 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A3715FD8
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 13:02:38 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso11127841pjf.1
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 13:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzeXhG81k1Q2dIZQbpuSfKgzNwwj/jsIfdDGuNOezBA=;
        b=CEn1Kyt+CeDNysFn2pYok1SiNcQgFIBCTqTqLsOG015nf20tdfKGW/QJD7hvA0/3b4
         fQyPhrT/BGzbLTtnA3SUG1U5CpXUVMj6DZTJINyVuufv0g/80OaPpP94Ty6NySwXk17V
         ZPc54J1AUTzwbNPkbDNaMT1qPS73np/bq7+Uu82qpA37n9amLJtizOKRUxVDTzO15gTC
         WybF13KCGErtPTM3nWKzEvC5vpt3QrSOijD/lst4ngRSaZD0Yjc9Kd7xDNaF7YZHBuIX
         iIv/shnhDsfkGvE+9twX5a9/os+S5KGTaF/XYKHukbIC7BS8G1xzeMr2bgxNCfluEOlL
         VCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uzeXhG81k1Q2dIZQbpuSfKgzNwwj/jsIfdDGuNOezBA=;
        b=DP5f/nF5ATA2Juy3XYoNkC2ci6Gznf/Se6ywDQFUBTh/YmM85Fnv0gz9CpO7TyiepX
         W5zuap0gbhF41KVGZz06Di7I0xnACmASfyxZg15OL6puaLCFKK1moUHLsB71zcvbsXOA
         tKtgoxDwbsnNL7o5Tzds6pnwM/1GOZvp495Ix1wNKwP6YwT5ivuLAJhL3Rg9NP7wL3Vl
         vY9esq96HZ59bM0SyKdW9fH+BiLUCVKKqVwnHpvJrzwSlbiaAyg598iLbY30192BpmRY
         2l6dS2LihOYX3APyMJ1KVfaJHs2wO/TKZ8wmGiaHnuxvNdH/+zwG+Is8SEMFFgZ6yfvg
         mj+Q==
X-Gm-Message-State: AFqh2kpKvjqhi4F+B3hCHxELnmvXIEei3f9qbH/CCm5WiljoHezWIz+W
        atgN1yELC5Crc+PdxBbDYuuUQOIH/eKDijgEQsU=
X-Google-Smtp-Source: AMrXdXuiLbnX+0CKtWlzAt58wdwixabhcGYX68LSe/GbEcw3TYxBudnpZz87e7qXp1N8sBOtE9Rjow==
X-Received: by 2002:a17:902:a98a:b0:189:cef2:88e3 with SMTP id bh10-20020a170902a98a00b00189cef288e3mr66870972plb.57.1673298157641;
        Mon, 09 Jan 2023 13:02:37 -0800 (PST)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm5559482pgp.71.2023.01.09.13.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 13:02:37 -0800 (PST)
From:   Kyle Huey <me@kylehuey.com>
X-Google-Original-From: Kyle Huey <khuey@kylehuey.com>
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Kyle Huey <me@kylehuey.com>
Subject: [PATCH 5.15 4/6] x86/fpu: Allow PKRU to be (once again) written by ptrace.
Date:   Mon,  9 Jan 2023 13:02:12 -0800
Message-Id: <20230109210214.71068-5-khuey@kylehuey.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109210214.71068-1-khuey@kylehuey.com>
References: <20230109210214.71068-1-khuey@kylehuey.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Huey <me@kylehuey.com>

commit 4a804c4f8356 upstream

Handle PKRU in copy_uabi_to_xstate() for the benefit of APIs that write
the XSTATE such as PTRACE_SETREGSET with NT_X86_XSTATE.

This restores the pre-5.14 behavior of ptrace. The regression can be seen
by running gdb and executing `p $pkru`, `set $pkru = 42`, and `p $pkru`.
On affected kernels (5.14+) the write to the PKRU register (which gdb
performs through ptrace) is ignored.

Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")
Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-5-khuey%40kylehuey.com
---
 arch/x86/kernel/fpu/xstate.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 8abce8015b72..fe9050c60adc 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1091,6 +1091,29 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
 }
 
 
+/**
+ * copy_uabi_to_xstate - Copy a UABI format buffer to the kernel xstate
+ * @fpstate:	The fpstate buffer to copy to
+ * @kbuf:	The UABI format buffer, if it comes from the kernel
+ * @ubuf:	The UABI format buffer, if it comes from userspace
+ * @pkru:	The location to write the PKRU value to
+ *
+ * Converts from the UABI format into the kernel internal hardware
+ * dependent format.
+ *
+ * This function ultimately has two different callers with distinct PKRU
+ * behavior.
+ * 1.	When called from sigreturn the PKRU register will be restored from
+ *	@fpstate via an XRSTOR. Correctly copying the UABI format buffer to
+ *	@fpstate is sufficient to cover this case, but the caller will also
+ *	pass a pointer to the thread_struct's pkru field in @pkru and updating
+ *	it is harmless.
+ * 2.	When called from ptrace the PKRU register will be restored from the
+ *	thread_struct's pkru field. A pointer to that is passed in @pkru.
+ *	The kernel will restore it manually, so the XRSTOR behavior that resets
+ *	the PKRU register to the hardware init value (0) if the corresponding
+ *	xfeatures bit is not set is emulated here.
+ */
 static int copy_uabi_to_xstate(struct xregs_state *xsave, const void *kbuf,
 			       const void __user *ubuf, u32 *pkru)
 {
@@ -1140,6 +1163,13 @@ static int copy_uabi_to_xstate(struct xregs_state *xsave, const void *kbuf,
 		}
 	}
 
+	if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
+		struct pkru_state *xpkru;
+
+		xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
+		*pkru = xpkru->pkru;
+	}
+
 	/*
 	 * The state that came in from userspace was user-state only.
 	 * Mask all the user states out of 'xfeatures':
-- 
2.25.1

