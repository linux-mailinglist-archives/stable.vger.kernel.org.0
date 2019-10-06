Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF75BCD826
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbfJFR76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbfJFR34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:29:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 479AD2080F;
        Sun,  6 Oct 2019 17:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382994;
        bh=SQiPdMoGXan/kBILxp/c6ImMkLBLa+XfJ5YOUTLLxaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXI/eHrWv4tsVJwc0olaDEpwI390hr7X58HJP3MCtxlzkHSwBEXMO/50bhaiI5Say
         U4Kk48CoTnJW3eEhoXzJt0HtRIB3i039OAMtBGbTdfM2/nMivlwR3DuWC93wmhGV3w
         U0Q2Ds0g2Sij/CwPurae+vL+Gic20k04UCE1APFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Yanjie <zhouyanjie@zoho.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        ralf@linux-mips.org, paul@crapouillou.net, jhogan@kernel.org,
        malat@debian.org, tglx@linutronix.de, allison@lohutok.net,
        syq@debian.org, chenhc@lemote.com, jiaxun.yang@flygoat.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/106] MIPS: Ingenic: Disable broken BTB lookup optimization.
Date:   Sun,  6 Oct 2019 19:20:54 +0200
Message-Id: <20191006171144.248358221@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



