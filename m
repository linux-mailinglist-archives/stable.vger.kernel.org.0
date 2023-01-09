Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988E9663253
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbjAIVKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237814AbjAIVKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 16:10:17 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE0415FE9
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 13:02:36 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso14134921pjp.4
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 13:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tArBw7JBeEVTc5EGXt4PhIx50ytwWPAkG24PDiKWec=;
        b=f3LImm00eWXSV4A2LzDQZRNi8zwsHroLz3HuxUA4DpKCFGNUSEcR/iitH5k7dfzKwo
         rlKE+nJamlo26ncOhVv0wzUv9Ed/981mNk6aPSXg2cjI9+ykNzY1IeH3qhrQ3zy0Q0Uh
         nw890LMTklsqiYSQMkz2heUf9zJocSD/pjdEGyH84g0Fysv/QZLa5aOlmLW5QXe4nw9p
         dDC5FPAeDfKWJPHW9p4YE9nBqQQM7O6qZ9DH2f2Q9/2d2GNOxNDf1ZuRefG9FUHzFDPB
         wBB4wO2fvuFLSR6Lt0t9OgXC6rmoy+m+YkN9jrb6R1RgNw5OMz4D7jG5qJZLEjBLJR3h
         2xRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+tArBw7JBeEVTc5EGXt4PhIx50ytwWPAkG24PDiKWec=;
        b=FwgPFDL0QIMFUf4zTuPotceQoy1icOWXeUf73Dvz1a5pbJXxsZN+C8xyC9DLR1+GmV
         UmY9tG7JuYFfad28Fl8+vfvyb8vEM9NIFI6X2ICCN4ggfYl6xVhiUXRPfeTJYmkmSpod
         QslG2Ul+Ji8tHEGCwCxEkpusSjO6SYW60WkEhDGMx2a9pSaHnryFPm4oevIC6io7jZHy
         0bcyS0/RjrqGTSCDLbWrUvdjosMCAHsruSwoOHABWaqFYNLb6GgU6/JsdqimupOg9iVo
         9YK7ClmVpsAWk6Mmcw7i7aAgYVhOdNluxmoe5jg03o1+BGzYYmmJnu8eyyTui78l0pTy
         pmDg==
X-Gm-Message-State: AFqh2kqksl6zs9QSA+iEl5xdZU8a/2BfpnYunKDMo4fJuxwxAivD1Vnf
        JCC98JsmbzfPoycutYTCGscwfVqzp/NfzmWriRY=
X-Google-Smtp-Source: AMrXdXtE7UjIdMKFV8ozy8Rcwu7BXCWUd08Yk8w3fQGfpmFaAlvcF8j0TvjFpNhPBSEV1G0rxD26NQ==
X-Received: by 2002:a05:6a20:3d17:b0:a4:efdd:a9b9 with SMTP id y23-20020a056a203d1700b000a4efdda9b9mr95255077pzi.44.1673298155964;
        Mon, 09 Jan 2023 13:02:35 -0800 (PST)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm5559482pgp.71.2023.01.09.13.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 13:02:35 -0800 (PST)
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
Subject: [PATCH 5.15 3/6] x86/fpu: Add a pkru argument to copy_uabi_to_xstate()
Date:   Mon,  9 Jan 2023 13:02:11 -0800
Message-Id: <20230109210214.71068-4-khuey@kylehuey.com>
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

commit 2c87767c35ee upstream

In preparation for adding PKRU handling code into copy_uabi_to_xstate(),
add an argument that copy_uabi_from_kernel_to_xstate() can use to pass the
canonical location of the PKRU value. For
copy_sigframe_from_user_to_xstate() the kernel will actually restore the
PKRU value from the fpstate, but pass in the thread_struct's pkru location
anyways for consistency.

Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-4-khuey%40kylehuey.com
---
 arch/x86/kernel/fpu/xstate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 555b9870e9ba..8abce8015b72 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1092,7 +1092,7 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
 
 
 static int copy_uabi_to_xstate(struct xregs_state *xsave, const void *kbuf,
-			       const void __user *ubuf)
+			       const void __user *ubuf, u32 *pkru)
 {
 	unsigned int offset, size;
 	struct xstate_header hdr;
@@ -1161,7 +1161,7 @@ static int copy_uabi_to_xstate(struct xregs_state *xsave, const void *kbuf,
  */
 int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf, u32 *pkru)
 {
-	return copy_uabi_to_xstate(xsave, kbuf, NULL);
+	return copy_uabi_to_xstate(xsave, kbuf, NULL, pkru);
 }
 
 /*
@@ -1172,7 +1172,7 @@ int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf,
 int copy_sigframe_from_user_to_xstate(struct task_struct *tsk,
 				      const void __user *ubuf)
 {
-	return copy_uabi_to_xstate(&tsk->thread.fpu.state.xsave, NULL, ubuf);
+	return copy_uabi_to_xstate(&tsk->thread.fpu.state.xsave, NULL, ubuf, &tsk->thread.pkru);
 }
 
 static bool validate_xsaves_xrstors(u64 mask)
-- 
2.25.1

