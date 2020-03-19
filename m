Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B80C518B6C5
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgCSNZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730602AbgCSNZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:25:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC213208D6;
        Thu, 19 Mar 2020 13:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624313;
        bh=Eqxcwe6hqlaj8Q4EMkWE8eXCmsUaeSppDr69o8tGO8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzHwauFAMXCa2L4q/+ZL9uj1+6S+FxH8MhLjL62vja0lrYoJvkzFznQg5r1FPDdgO
         /rKp7JtSEvhlRYDFMKexRzlg7FqwCCnGZXadP1U96EqRW9tuQCJpVv0YuSj2fM6lSy
         5Y7acwlku87n7Em9cDXLy3WK6nuaRtOqf4Kg7iqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greentime Hu <greentime.hu@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 19/65] riscv: set pmp configuration if kernel is running in M-mode
Date:   Thu, 19 Mar 2020 14:04:01 +0100
Message-Id: <20200319123932.471624630@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



