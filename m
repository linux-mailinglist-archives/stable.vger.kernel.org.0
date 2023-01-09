Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2376F663257
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237784AbjAIVKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237816AbjAIVKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 16:10:17 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F44186F4
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 13:02:35 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id jn22so10900960plb.13
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 13:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NsZWoD8XwlBuBiOAqZyxJSLmnRQpbTbHkYhQssgGWjk=;
        b=HW3YQzc0MHtDeDVwnu2IFNAcSaP4fA1qlBQPcfokNYCjgZWAsSlGTtVM2n2ipzd/+3
         k3HdiM3Jv1xj+v7QBEGOxhjTYAwFSfXCa/2R1JNvgfQOhddNEasjxewY5twibp1YKzQP
         Ko9sHELKXiOmkpXR/m6PhpXAXWtOsUDbMnXI5Zt+jRTjUYlhk1dyo7IOgAjhUfAAOjrW
         vcJXYepL3Zl84MJ+SA9xHjGudTvUEB6LJwXmjrFaYBo7yMUPDkddThaATBQPOMWFXoQL
         3Y//rkIQqocpznHkOIjC/8MloaKw1E9UCZcEqYHcimfib2mO6ayflRzGmXoYynluBg0A
         ZWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NsZWoD8XwlBuBiOAqZyxJSLmnRQpbTbHkYhQssgGWjk=;
        b=MhY35+S8FsyPt8VUig7vvXoytF0A6679DoHFQIxkBpaPNPl18XL3sla0SFUr9XdY9b
         W3DlmAUmj5h+jxOxvtrNqL6d8/s7YXt/tL+kubjFZf0nOg2yb69u+ctN7nazezHa6MZf
         3lWgkO4lXmk7DFdI/juXBNVQKkgCslgQYfGs8fgnr0iSvCY6zXr9cggLNuWLR+mwUEoc
         UgU5aIuwmuGWttXKeiSCgua5pKDgG+a5C7yEyJE5NLuE3692AZC3TqGxScz8idYWMo2q
         JvlFbbDOiRNaaSEzjSVAg/fxRQw4ZNzCX8FKnLBegMoa47DJvro9oM2s5ct0TqBGu4gz
         Xe2Q==
X-Gm-Message-State: AFqh2krgqdfqeLdjKhCVNv/uQ8eWRHwbZubdye+cYHi07cT6Y8OQZcd5
        HqiRVbyeuzHR00tW3gEDd7Tx3/XP1CRZlQOJW4k=
X-Google-Smtp-Source: AMrXdXuwq/Vt4T6inwQYYuQib2nKFgTXEcoWNgc9WVbho3Xqhj7hHtEdUD6admg8NqKDgKS3SCE+cQ==
X-Received: by 2002:a05:6a20:4290:b0:ad:4642:c671 with SMTP id o16-20020a056a20429000b000ad4642c671mr100604026pzj.12.1673298154306;
        Mon, 09 Jan 2023 13:02:34 -0800 (PST)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm5559482pgp.71.2023.01.09.13.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 13:02:33 -0800 (PST)
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
Subject: [PATCH 5.15 2/6] x86/fpu: Add a pkru argument to copy_uabi_from_kernel_to_xstate().
Date:   Mon,  9 Jan 2023 13:02:10 -0800
Message-Id: <20230109210214.71068-3-khuey@kylehuey.com>
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

commit 1c813ce03055 upstream

ptrace (through PTRACE_SETREGSET with NT_X86_XSTATE) ultimately calls
copy_uabi_from_kernel_to_xstate(). In preparation for eventually handling
PKRU in copy_uabi_to_xstate, pass in a pointer to the PKRU location.

Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-3-khuey%40kylehuey.com
---
 arch/x86/include/asm/fpu/xstate.h | 2 +-
 arch/x86/kernel/fpu/regset.c      | 2 +-
 arch/x86/kernel/fpu/xstate.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index b98b302c2751..d91df71f60fb 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -136,7 +136,7 @@ extern void __init update_regset_xstate_info(unsigned int size,
 
 void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
 int xfeature_size(int xfeature_nr);
-int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf);
+int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf, u32 *pkru);
 int copy_sigframe_from_user_to_xstate(struct task_struct *tsk, const void __user *ubuf);
 
 void xsaves(struct xregs_state *xsave, u64 mask);
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 125cbbe10fef..bd243ae57680 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -163,7 +163,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	}
 
 	fpu_force_restore(fpu);
-	ret = copy_uabi_from_kernel_to_xstate(&fpu->state.xsave, kbuf ?: tmpbuf);
+	ret = copy_uabi_from_kernel_to_xstate(&fpu->state.xsave, kbuf ?: tmpbuf, &target->thread.pkru);
 
 out:
 	vfree(tmpbuf);
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index e1b717427955..555b9870e9ba 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1159,7 +1159,7 @@ static int copy_uabi_to_xstate(struct xregs_state *xsave, const void *kbuf,
  * format and copy to the target thread. This is called from
  * xstateregs_set().
  */
-int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf)
+int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf, u32 *pkru)
 {
 	return copy_uabi_to_xstate(xsave, kbuf, NULL);
 }
-- 
2.25.1

