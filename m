Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33ED53BD11C
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbhGFLiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235064AbhGFLd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59F9761E2C;
        Tue,  6 Jul 2021 11:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570585;
        bh=oiT+BAiA3TGhR/aJnvoJoBMTK3loyU8sH31J4fwOSCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWNTxH6Ew7oNCSL0itosNJ+/s+okNFDATUF5AM0BwhioxIgGeVR5s0rEGS8m8o0/T
         OOjI6c+CPm/SzaIjSBdMgF6vaw2g7Zk8BY39CxQKaYANswufRL7mumfWGb/fHdtFZR
         mNvRfKHpLHXu95Ld6/6KNIxucmP6UUzlGfVIULVEQJ8k3uI/RHmGMp4aw2JDmfIlou
         RmU4ZZpD17Lw/kqr7r+J81utRxST27M24LfopiTB3b/sYWtfZO6xEsrMfByRjJMglz
         3viWUoxzh5fka5qR9JcAZa3EhBdHZuhJQQyOB4mi3KwrTJJaQjATZ+1lPgwm/aRvUj
         L13Jyre3S7o1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 048/137] MIPS: cpu-probe: Fix FPU detection on Ingenic JZ4760(B)
Date:   Tue,  6 Jul 2021 07:20:34 -0400
Message-Id: <20210706112203.2062605-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit fc52f92a653215fbd6bc522ac5311857b335e589 ]

Ingenic JZ4760 and JZ4760B do have a FPU, but the config registers don't
report it. Force the FPU detection in case the processor ID match the
JZ4760(B) one.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/cpu-probe.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index e6ae2bcdbeda..067cb3eb1614 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1827,6 +1827,11 @@ static inline void cpu_probe_ingenic(struct cpuinfo_mips *c, unsigned int cpu)
 		 */
 		case PRID_COMP_INGENIC_D0:
 			c->isa_level &= ~MIPS_CPU_ISA_M32R2;
+
+			/* FPU is not properly detected on JZ4760(B). */
+			if (c->processor_id == 0x2ed0024f)
+				c->options |= MIPS_CPU_FPU;
+
 			fallthrough;
 
 		/*
-- 
2.30.2

