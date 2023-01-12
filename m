Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5959D6677E6
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbjALOuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239931AbjALOuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:50:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9F21A800
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58932B81E69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9684FC433EF;
        Thu, 12 Jan 2023 14:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534208;
        bh=UM9mLuX0Ht3tQ3iSEeO0cPmwXWD2DJoJrneHwJbmh6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhQr+s+IutWjQvmZDf7UwhnbFM5Rn87mFwfIe5ioRDXh5HB/wHKoblZ6MggJnk+Om
         i7cLp0EvtmRYznp3onqZ//nOjNen+C35/gl6iLPVBxIXnnSUnEeb3lGtyfoi40VKeD
         T0IMZx+Udu7pfBoVcrP6MYQzWULcY9Ni3kbjH+2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Borislav Petkov <bp@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 701/783] x86/kprobes: Convert to insn_decode()
Date:   Thu, 12 Jan 2023 14:56:57 +0100
Message-Id: <20230112135556.836129118@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 77e768ec1391dc0d6cd89822aa60b9a1c1bd8128 ]

Simplify code, improve decoding error checking.

Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lkml.kernel.org/r/20210304174237.31945-12-bp@alien8.de
Stable-dep-of: 63dc6325ff41 ("x86/kprobes: Fix optprobe optimization check with CONFIG_RETHUNK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 17 +++++++++++------
 arch/x86/kernel/kprobes/opt.c  |  9 +++++++--
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 97e1d2a9898f..5de757099186 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -293,6 +293,8 @@ static int can_probe(unsigned long paddr)
 	/* Decode instructions */
 	addr = paddr - offset;
 	while (addr < paddr) {
+		int ret;
+
 		/*
 		 * Check if the instruction has been modified by another
 		 * kprobe, in which case we replace the breakpoint by the
@@ -304,8 +306,10 @@ static int can_probe(unsigned long paddr)
 		__addr = recover_probed_instruction(buf, addr);
 		if (!__addr)
 			return 0;
-		kernel_insn_init(&insn, (void *)__addr, MAX_INSN_SIZE);
-		insn_get_length(&insn);
+
+		ret = insn_decode(&insn, (void *)__addr, MAX_INSN_SIZE, INSN_MODE_KERN);
+		if (ret < 0)
+			return 0;
 
 #ifdef CONFIG_KGDB
 		/*
@@ -351,8 +355,8 @@ static int is_IF_modifier(kprobe_opcode_t *insn)
 int __copy_instruction(u8 *dest, u8 *src, u8 *real, struct insn *insn)
 {
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
-	unsigned long recovered_insn =
-		recover_probed_instruction(buf, (unsigned long)src);
+	unsigned long recovered_insn = recover_probed_instruction(buf, (unsigned long)src);
+	int ret;
 
 	if (!recovered_insn || !insn)
 		return 0;
@@ -362,8 +366,9 @@ int __copy_instruction(u8 *dest, u8 *src, u8 *real, struct insn *insn)
 			MAX_INSN_SIZE))
 		return 0;
 
-	kernel_insn_init(insn, dest, MAX_INSN_SIZE);
-	insn_get_length(insn);
+	ret = insn_decode(insn, dest, MAX_INSN_SIZE, INSN_MODE_KERN);
+	if (ret < 0)
+		return 0;
 
 	/* We can not probe force emulate prefixed instruction */
 	if (insn_has_emulate_prefix(insn))
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 08eb23074f92..4299fc865732 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -312,6 +312,8 @@ static int can_optimize(unsigned long paddr)
 	addr = paddr - offset;
 	while (addr < paddr - offset + size) { /* Decode until function end */
 		unsigned long recovered_insn;
+		int ret;
+
 		if (search_exception_tables(addr))
 			/*
 			 * Since some fixup code will jumps into this function,
@@ -321,8 +323,11 @@ static int can_optimize(unsigned long paddr)
 		recovered_insn = recover_probed_instruction(buf, addr);
 		if (!recovered_insn)
 			return 0;
-		kernel_insn_init(&insn, (void *)recovered_insn, MAX_INSN_SIZE);
-		insn_get_length(&insn);
+
+		ret = insn_decode(&insn, (void *)recovered_insn, MAX_INSN_SIZE, INSN_MODE_KERN);
+		if (ret < 0)
+			return 0;
+
 		/*
 		 * In the case of detecting unknown breakpoint, this could be
 		 * a padding INT3 between functions. Let's check that all the
-- 
2.35.1



