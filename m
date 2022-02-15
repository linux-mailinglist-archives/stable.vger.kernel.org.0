Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B062C4B704A
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbiBOPml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:42:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242279AbiBOPmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:42:19 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DE3CF38F
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 07:37:15 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id s129-20020a254587000000b00621cf68a92fso19866011yba.13
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 07:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nh+sVpD80A6shLvILTn05Ew0Y8LiljouUPL3DGf7rDU=;
        b=Za6kh7UUq6kFoRp3AnGRu+4Sa/Vqbhlt9NgYc6KoqFNbNkhpQnbVp8683+w52g1Bwr
         6autASyVISW8izdNV6Qv9EKfqWfi+zwjgSaawXxCspjhEzSgye0e+VsOdfgW+23XXI19
         TPo34hzsiKbwumJ2QWMnBx+mijIMIGXZ7Ilx4pZLCkbm5KigOwHMTYqqu7kgyFWFO2BB
         9Bb7ALyTwGRpr5PvckbEPT8sg/xc+eERTmr1ZX/+VC+/DiqNNlud7eqmT/iyZsa0msSs
         mieCHsanHE+xf3SbyryOai+Fvc82ebgt1iJ0RSmZgueeAxwm6skeTZ0fyezPz+1t7TtG
         BQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nh+sVpD80A6shLvILTn05Ew0Y8LiljouUPL3DGf7rDU=;
        b=JKHynEhacDu/OVb2THkl0+k+GEPYFpbTYONQmfOwGcaNG3fat+RYhYnWriBuHjb/24
         zhs+yMrCVsx0LiK9CtfNb9ZONksRDQ0J+0GRBjNnsmd6iRVtWhjv3wumaSxQ5icVhtAp
         HJAnUQ/hbfUtXhUiKrvG812WkgYNlbAW0ZebDeBG1n8Egn4ZQL2MRaf8+fLbxAK2eR12
         RS9L/GPFwqqrNzpJUjc55ELujtgWCngJEsERMowgSVIGlWUwsTL24wYd+QXqXTCkj2k4
         R1vzn4XSP+FA2IQCVJ8rnDtVtCtA/bbpZKCftDC2ZH7TRMKw0/ErcK2b890f+YEIlkg5
         pBug==
X-Gm-Message-State: AOAM530U6+F9dSfxgZlb3Yrt1itKr5IWWAO1O+wzqSVvXQI9IdOgttnE
        ycL8MRCS6LXmHFfPtO5ba76gJj1t+bFz
X-Google-Smtp-Source: ABdhPJwZphDpZK5w+SNtxL8aRxpQJ/Br4sTTzmcveEKO1iEOmvKB8/KvFavtIpdL/Yb2ywfIeTfilgCvojRw
X-Received: from bg.sfo.corp.google.com ([2620:15c:11a:202:d51c:4157:9d6d:63e4])
 (user=bgeffon job=sendgmr) by 2002:a81:ee10:: with SMTP id
 l16mr4280164ywm.32.1644939433331; Tue, 15 Feb 2022 07:37:13 -0800 (PST)
Date:   Tue, 15 Feb 2022 07:36:44 -0800
Message-Id: <20220215153644.3654582-1-bgeffon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH] x86/fpu: Correct pkru/xstate inconsistency
From:   Brian Geffon <bgeffon@google.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Brian Geffon <bgeffon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are two issues with PKRU handling prior to 5.13. The first is that
when eagerly switching PKRU we check that current is not a kernel
thread as kernel threads will never use PKRU. It's possible that
this_cpu_read_stable() on current_task (ie. get_current()) is returning
an old cached value. By forcing the read with this_cpu_read() the
correct task is used. Without this it's possible when switching from
a kernel thread to a userspace thread that we'll still observe the
PF_KTHREAD flag and never restore the PKRU. And as a result this
issue only occurs when switching from a kernel thread to a userspace
thread, switching from a non kernel thread works perfectly fine because
all we consider in that situation is the flags from some other non
kernel task and the next fpu is passed in to switch_fpu_finish().

Without reloading the value finish_fpu_load() after being inlined into
__switch_to() uses a stale value of current:

  ba1:   8b 35 00 00 00 00       mov    0x0(%rip),%esi
  ba7:   f0 41 80 4d 01 40       lock orb $0x40,0x1(%r13)
  bad:   e9 00 00 00 00          jmp    bb2 <__switch_to+0x1eb>
  bb2:   41 f6 45 3e 20          testb  $0x20,0x3e(%r13)
  bb7:   75 1c                   jne    bd5 <__switch_to+0x20e>

By using this_cpu_read() and avoiding the cached value the compiler does
insert an additional load instruction and observes the correct value now:

  ba1:   8b 35 00 00 00 00       mov    0x0(%rip),%esi
  ba7:   f0 41 80 4d 01 40       lock orb $0x40,0x1(%r13)
  bad:   e9 00 00 00 00          jmp    bb2 <__switch_to+0x1eb>
  bb2:   65 48 8b 05 00 00 00    mov    %gs:0x0(%rip),%rax
  bb9:   00
  bba:   f6 40 3e 20             testb  $0x20,0x3e(%rax)
  bbe:   75 1c                   jne    bdc <__switch_to+0x215>

The second issue is when using write_pkru() we only write to the
xstate when the feature bit is set because get_xsave_addr() returns
NULL when the feature bit is not set. This is problematic as the CPU
is free to clear the feature bit when it observes the xstate in the
init state, this behavior seems to be documented a few places throughout
the kernel. If the bit was cleared then in write_pkru() we would happily
write to PKRU without ever updating the xstate, and the FPU restore on
return to userspace would load the old value agian.

Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
Signed-off-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Willis Kung <williskung@google.com>
Tested-by: Willis Kung <williskung@google.com>
---
 arch/x86/include/asm/fpu/internal.h |  2 +-
 arch/x86/include/asm/pgtable.h      | 14 ++++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 03b3de491b5e..540bda5bdd28 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -598,7 +598,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
 	 * PKRU state is switched eagerly because it needs to be valid before we
 	 * return to userland e.g. for a copy_to_user() operation.
 	 */
-	if (!(current->flags & PF_KTHREAD)) {
+	if (!(this_cpu_read(current_task)->flags & PF_KTHREAD)) {
 		/*
 		 * If the PKRU bit in xsave.header.xfeatures is not set,
 		 * then the PKRU component was in init state, which means
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 9e71bf86d8d0..aa381b530de0 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -140,16 +140,22 @@ static inline void write_pkru(u32 pkru)
 	if (!boot_cpu_has(X86_FEATURE_OSPKE))
 		return;
 
-	pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
-
 	/*
 	 * The PKRU value in xstate needs to be in sync with the value that is
 	 * written to the CPU. The FPU restore on return to userland would
 	 * otherwise load the previous value again.
 	 */
 	fpregs_lock();
-	if (pk)
-		pk->pkru = pkru;
+	/*
+	 * The CPU is free to clear the feature bit when the xstate is in the
+	 * init state. For this reason, we need to make sure the feature bit is
+	 * reset when we're explicitly writing to pkru. If we did not then we
+	 * would write to pkru and it would not be saved on a context switch.
+	 */
+	current->thread.fpu.state.xsave.header.xfeatures |= XFEATURE_MASK_PKRU;
+	pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
+	BUG_ON(!pk);
+	pk->pkru = pkru;
 	__write_pkru(pkru);
 	fpregs_unlock();
 }
-- 
2.35.1.265.g69c8d7142f-goog

