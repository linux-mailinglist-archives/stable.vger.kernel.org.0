Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3158C16F9
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730359AbfI2Re2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730338AbfI2Re1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:34:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5722821D56;
        Sun, 29 Sep 2019 17:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778466;
        bh=SQiPdMoGXan/kBILxp/c6ImMkLBLa+XfJ5YOUTLLxaQ=;
        h=From:To:Cc:Subject:Date:From;
        b=F5ZPztJebixoukyNnTfWn8ahzIwHuvSaV1GgKhIsOOAxNlUOz2KPF4mUyZ88Xo6Lq
         /CQxN/qpyjpSbYQbM0Pz+C+0bRGhUx6Y+//dOJMdZcO5DTkxt4cWwV4B3A7BoGtP+M
         XRN4w0zIgYerTm03121fw3KoIP1CUULsiWaQATnQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhou Yanjie <zhouyanjie@zoho.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        ralf@linux-mips.org, paul@crapouillou.net, jhogan@kernel.org,
        malat@debian.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
        allison@lohutok.net, syq@debian.org, chenhc@lemote.com,
        jiaxun.yang@flygoat.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 01/33] MIPS: Ingenic: Disable broken BTB lookup optimization.
Date:   Sun, 29 Sep 2019 13:33:49 -0400
Message-Id: <20190929173424.9361-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Yanjie <zhouyanjie@zoho.com>

[ Upstream commit 053951dda71ecb4b554a2cdbe26f5f6f9bee9dd2 ]

In order to further reduce power consumption, the XBurst core
by default attempts to avoid branch target buffer lookups by
detecting & special casing loops. This feature will cause
BogoMIPS and lpj calculate in error. Set cp0 config7 bit 4 to
disable this feature.

Signed-off-by: Zhou Yanjie <zhouyanjie@zoho.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org
Cc: paul@crapouillou.net
Cc: jhogan@kernel.org
Cc: malat@debian.org
Cc: gregkh@linuxfoundation.org
Cc: tglx@linutronix.de
Cc: allison@lohutok.net
Cc: syq@debian.org
Cc: chenhc@lemote.com
Cc: jiaxun.yang@flygoat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mipsregs.h | 4 ++++
 arch/mips/kernel/cpu-probe.c     | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index 01df9ad62fb83..1bb9448777c5c 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -688,6 +688,9 @@
 #define MIPS_CONF7_IAR		(_ULCAST_(1) << 10)
 #define MIPS_CONF7_AR		(_ULCAST_(1) << 16)
 
+/* Ingenic Config7 bits */
+#define MIPS_CONF7_BTB_LOOP_EN	(_ULCAST_(1) << 4)
+
 /* Config7 Bits specific to MIPS Technologies. */
 
 /* Performance counters implemented Per TC */
@@ -2774,6 +2777,7 @@ __BUILD_SET_C0(status)
 __BUILD_SET_C0(cause)
 __BUILD_SET_C0(config)
 __BUILD_SET_C0(config5)
+__BUILD_SET_C0(config7)
 __BUILD_SET_C0(intcontrol)
 __BUILD_SET_C0(intctl)
 __BUILD_SET_C0(srsmap)
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index d535fc706a8b3..25cd8737e7fe0 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1879,6 +1879,13 @@ static inline void cpu_probe_ingenic(struct cpuinfo_mips *c, unsigned int cpu)
 		c->cputype = CPU_JZRISC;
 		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
 		__cpu_name[cpu] = "Ingenic JZRISC";
+		/*
+		 * The XBurst core by default attempts to avoid branch target
+		 * buffer lookups by detecting & special casing loops. This
+		 * feature will cause BogoMIPS and lpj calculate in error.
+		 * Set cp0 config7 bit 4 to disable this feature.
+		 */
+		set_c0_config7(MIPS_CONF7_BTB_LOOP_EN);
 		break;
 	default:
 		panic("Unknown Ingenic Processor ID!");
-- 
2.20.1

