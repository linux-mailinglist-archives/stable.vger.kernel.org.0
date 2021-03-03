Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9B032BC17
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383089AbhCCNki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450528AbhCCFef (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 00:34:35 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B1FC061756;
        Tue,  2 Mar 2021 21:33:53 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id c19so3446442pjq.3;
        Tue, 02 Mar 2021 21:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+MSiC6Q+hpJUDnRmNCGx5NmKvF0JakvrOzmHbqYAYAQ=;
        b=jEfwoOFIXglPwdaelMWV0KkBU2KId/ARX5H9ICDj8mSab65rGIh3PUBYaLgW9t/CdR
         XQxkCdJLZ/4xHhpeb2sSN3h35y37CnUnLGTzjKLhpuw3D2LToa7pntLyeaFOLukX7chS
         iKmmyQaLAEtZXfiDkJ3gFdSE6cXhua4mwgP8invwUPA18XvyaGzDx+quJuqf3BianMJe
         1EX6zhK7ilKARyMJx1YHmjpeSxOlXRFRB8zsir1gOQayg6NOTlNxF4tlPpdW/VEDwyLC
         V/sMJRUADFmbQdKusRNbYFyTglr3emO22YHjtPaENgo3LLKGmS4AbO4MWs7hE/ETmJFx
         QEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=+MSiC6Q+hpJUDnRmNCGx5NmKvF0JakvrOzmHbqYAYAQ=;
        b=b575bdKnO4FWKJMhDzsFoGUZUlSJSO5unDRMu2gptMsvdXy+4TXom8BcDKUrmUdv5E
         IDMzBcFV0LHVtnvr7txxZfCWzL+EsBmxicf+WOHvPvO2gCHS3RB2lwXIRPHkHaa5J0Kl
         ZeCHzuPvmrPUUQPzKtXGequVgiZFg4RLdJDp+QguruyNgeubQ9FmHuXPa2HihFeiem4H
         fTqXumjN1t0Vl91PF+0/t4vfH56XWSwHOtqRVXtlQx51wNG4rUP3v5+p4HqeicToSp3s
         qlzth2dwS8MbzxirjafiUPS5zeGR6F1qidFLX2OOTOZDIENtfbH2tVHWcpeyOAS1SGwl
         0VJQ==
X-Gm-Message-State: AOAM531jb5GG5SODwuYXiy6rNsbHCA4+58MEIGdUjVKRvo7ZJNnj50Cb
        mcv391npIbdNn30xH8PdFXXaOsirgZQVeQR4
X-Google-Smtp-Source: ABdhPJxQIpLydLoTGfwLNpcQGmXXEauE+colW/V806X8sSFy3R8RKrRcECbfLRrxDY+x+rUEu3pwew==
X-Received: by 2002:a17:902:8c8f:b029:e0:1663:fd34 with SMTP id t15-20020a1709028c8fb02900e01663fd34mr6693497plo.84.1614749633107;
        Tue, 02 Mar 2021 21:33:53 -0800 (PST)
Received: from localhost.localdomain ([60.247.76.83])
        by smtp.gmail.com with ESMTPSA id bb24sm5511062pjb.5.2021.03.02.21.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 21:33:52 -0800 (PST)
Sender: YunQiang Su <wzssyqa@gmail.com>
From:   YunQiang Su <syq@debian.org>
To:     tsbogend@alpha.franken.de, macro@orcam.me.uk,
        jiaxun.yang@flygoat.com
Cc:     linux-mips@vger.kernel.org,
        YunQiang Su <yunqiang.su@cipunited.com>, stable@vger.kernel.org
Subject: [PATCH v7] MIPS: force use FR=0 or FRE for FPXX binaries
Date:   Wed,  3 Mar 2021 05:33:42 +0000
Message-Id: <20210303053342.5920-1-syq@debian.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YunQiang Su <yunqiang.su@cipunited.com>

The MIPS FPU may have 3 mode:
  FR=0: MIPS I style, all of the FPR are single.
  FR=1: all 32 FPR can be double.
  FRE: redirecting the rw of odd-FPR to the upper 32bit of even-double FPR.

The binary may have 3 mode:
  FP32: can only work with FR=0 and FRE mode
  FPXX: can work with all of FR=0/FR=1/FRE mode.
  FP64: can only work with FR=1 mode

Some binary, for example the output of golang, may be mark as FPXX,
while in fact they are FP32. It is caused by the bug of design and linker:
  Object produced by pure Go has no FP annotation while in fact they are FP32;
  if we link them with the C module which marked as FPXX,
  the result will be marked as FPXX. If these fake-FPXX binaries is executed
  in FR=1 mode, some problem will happen.

In Golang, now we add the FP32 annotation, so the future golang programs
won't have this problem. While for the existing binaries, we need a
kernel workaround.

Currently, FR=1 mode is used for all FPXX binary, it makes some wrong
behivour of the binaries. Since FPXX binary can work with both FR=1 and FR=0,
we force it to use FR=0 or FRE (for R6 CPU).

Reference:

https://web.archive.org/web/20180828210612/https://dmz-portal.mips.com/wiki/MIPS_O32_ABI_-_FR0_and_FR1_Interlinking

https://go-review.googlesource.com/c/go/+/239217
https://go-review.googlesource.com/c/go/+/237058

Signed-off-by: YunQiang Su <yunqiang.su@cipunited.com>
Cc: stable@vger.kernel.org # 4.19+

v6->v7:
	Use FRE mode for pre-R6 binaries on R6 CPU.

v5->v6:
	Rollback to V3, aka remove config option.

v4->v5:
	Fix CONFIG_MIPS_O32_FPXX_USE_FR0 usage: if -> ifdef

v3->v4:
	introduce a config option: CONFIG_MIPS_O32_FPXX_USE_FR0

v2->v3:
	commit message: add Signed-off-by and Cc to stable.

v1->v2:
	Fix bad commit message: in fact, we are switching to FR=0
---
 arch/mips/kernel/elf.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
index 7b045d2a0b51..4d4db619544b 100644
--- a/arch/mips/kernel/elf.c
+++ b/arch/mips/kernel/elf.c
@@ -232,11 +232,16 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
 	 *   that inherently require the hybrid FP mode.
 	 * - If FR1 and FRDEFAULT is true, that means we hit the any-abi or
 	 *   fpxx case. This is because, in any-ABI (or no-ABI) we have no FPU
-	 *   instructions so we don't care about the mode. We will simply use
-	 *   the one preferred by the hardware. In fpxx case, that ABI can
-	 *   handle both FR=1 and FR=0, so, again, we simply choose the one
-	 *   preferred by the hardware. Next, if we only use single-precision
-	 *   FPU instructions, and the default ABI FPU mode is not good
+	 *   instructions so we don't care about the mode.
+	 *   In fpxx case, that ABI can handle all of FR=1/FR=0/FRE mode.
+	 *   Here, we need to use FR=0/FRE mode instead of FR=1, because some binaries
+	 *   may be mark as FPXX by mistake due to bugs of design and linker:
+	 *      The object produced by pure Go has no FP annotation,
+	 *      then is treated as any-ABI by linker, although in fact they are FP32;
+	 *      if any-ABI object is linked with FPXX object, the result will be mark as FPXX.
+	 *      Then the problem happens: run FP32 binaries in FR=1 mode.
+	 * - If we only use single-precision FPU instructions,
+	 *   and the default ABI FPU mode is not good
 	 *   (ie single + any ABI combination), we set again the FPU mode to the
 	 *   one is preferred by the hardware. Next, if we know that the code
 	 *   will only use single-precision instructions, shown by single being
@@ -248,8 +253,9 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
 	 */
 	if (prog_req.fre && !prog_req.frdefault && !prog_req.fr1)
 		state->overall_fp_mode = FP_FRE;
-	else if ((prog_req.fr1 && prog_req.frdefault) ||
-		 (prog_req.single && !prog_req.frdefault))
+	else if (prog_req.fr1 && prog_req.frdefault)
+		state->overall_fp_mode = cpu_has_mips_r6 ? FP_FRE : FP_FR0;
+	else if (prog_req.single && !prog_req.frdefault)
 		/* Make sure 64-bit MIPS III/IV/64R1 will not pick FR1 */
 		state->overall_fp_mode = ((raw_current_cpu_data.fpu_id & MIPS_FPIR_F64) &&
 					  cpu_has_mips_r2_r6) ?
-- 
2.20.1

