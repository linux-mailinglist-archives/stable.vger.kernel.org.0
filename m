Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEA517ACFB
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgCERNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:13:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbgCERNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:13:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 467BE20870;
        Thu,  5 Mar 2020 17:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428415;
        bh=Eqxcwe6hqlaj8Q4EMkWE8eXCmsUaeSppDr69o8tGO8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hu5Cpqt9MrLQlTT4RCmJzQUq5IHIRtjrFunEQtIK+4Al5RUHwWLFCIWNwH81l1qLK
         kWyjW8CpdRttXrTQ1ZrDol6EL4RBpTrTFtElENJ7hZQHHIb+ase0RIKfjUWy5YlxQW
         dZwK+i3rWcWw6AOUVWAlv50f4zOqOl4+9WDe1lLk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greentime Hu <greentime.hu@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 18/67] riscv: set pmp configuration if kernel is running in M-mode
Date:   Thu,  5 Mar 2020 12:12:19 -0500
Message-Id: <20200305171309.29118-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

[ Upstream commit c68a9032299e837b56d356de9250c93094f7e0e3 ]

When the kernel is running in S-mode, the expectation is that the
bootloader or SBI layer will configure the PMP to allow the kernel to
access physical memory.  But, when the kernel is running in M-mode and is
started with the ELF "loader", there's probably no bootloader or SBI layer
involved to configure the PMP.  Thus, we need to configure the PMP
ourselves to enable the kernel to access all regions.

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/csr.h | 12 ++++++++++++
 arch/riscv/kernel/head.S     |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 435b65532e294..8e18d2c64399d 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -72,6 +72,16 @@
 #define EXC_LOAD_PAGE_FAULT	13
 #define EXC_STORE_PAGE_FAULT	15
 
+/* PMP configuration */
+#define PMP_R			0x01
+#define PMP_W			0x02
+#define PMP_X			0x04
+#define PMP_A			0x18
+#define PMP_A_TOR		0x08
+#define PMP_A_NA4		0x10
+#define PMP_A_NAPOT		0x18
+#define PMP_L			0x80
+
 /* symbolic CSR names: */
 #define CSR_CYCLE		0xc00
 #define CSR_TIME		0xc01
@@ -100,6 +110,8 @@
 #define CSR_MCAUSE		0x342
 #define CSR_MTVAL		0x343
 #define CSR_MIP			0x344
+#define CSR_PMPCFG0		0x3a0
+#define CSR_PMPADDR0		0x3b0
 #define CSR_MHARTID		0xf14
 
 #ifdef CONFIG_RISCV_M_MODE
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index a4242be66966b..e4d9baf973232 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -58,6 +58,12 @@ _start_kernel:
 	/* Reset all registers except ra, a0, a1 */
 	call reset_regs
 
+	/* Setup a PMP to permit access to all of memory. */
+	li a0, -1
+	csrw CSR_PMPADDR0, a0
+	li a0, (PMP_A_NAPOT | PMP_R | PMP_W | PMP_X)
+	csrw CSR_PMPCFG0, a0
+
 	/*
 	 * The hartid in a0 is expected later on, and we have no firmware
 	 * to hand it to us.
-- 
2.20.1

