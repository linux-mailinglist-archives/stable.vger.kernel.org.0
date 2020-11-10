Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A3F2ACC7D
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733219AbgKJDzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:55:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733208AbgKJDze (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB0E6208FE;
        Tue, 10 Nov 2020 03:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980533;
        bh=6Zp+YV6Z2BWDD9deiTge0AlKV+A0u0z1bSS6kiV9ATg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bulcRriKLPTx4JXDrNiwQkvc2olFTsok4NHbYvM+wrdOn7mCRgJc5rDzBTfE0quHN
         dQKZ5NgMYNE+qcyOHRAjlrGJkge92oLyiFA8VdPv4tcnnNgBr2uXx+yrB1xT1V77NC
         JNJvW2wIxpYG+WpWzaeGDdp/wTS5tniVUGP+Gg0g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Anderson <seanga2@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 38/42] riscv: Set text_offset correctly for M-Mode
Date:   Mon,  9 Nov 2020 22:54:36 -0500
Message-Id: <20201110035440.424258-38-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Anderson <seanga2@gmail.com>

[ Upstream commit 79605f1394261995c2b955c906a5a20fb27cdc84 ]

M-Mode Linux is loaded at the start of RAM, not 2MB later. Perhaps this
should be calculated based on PAGE_OFFSET somehow? Even better would be to
deprecate text_offset and instead introduce something absolute.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/head.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 72f89b7590dd6..344793159b97d 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -26,12 +26,17 @@ ENTRY(_start)
 	/* reserved */
 	.word 0
 	.balign 8
+#ifdef CONFIG_RISCV_M_MODE
+	/* Image load offset (0MB) from start of RAM for M-mode */
+	.dword 0
+#else
 #if __riscv_xlen == 64
 	/* Image load offset(2MB) from start of RAM */
 	.dword 0x200000
 #else
 	/* Image load offset(4MB) from start of RAM */
 	.dword 0x400000
+#endif
 #endif
 	/* Effective size of kernel image */
 	.dword _end - _start
-- 
2.27.0

