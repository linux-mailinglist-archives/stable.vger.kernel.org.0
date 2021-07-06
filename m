Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BBD3BCC0B
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhGFLSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232432AbhGFLSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85E7661C3B;
        Tue,  6 Jul 2021 11:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570139;
        bh=jkuEZkfL7lr8mk1AeV04Qf6U6eKhfHJ7PJkPe7AUo14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxoldD6QBNnZ16zHAsqdK26/z9GV7CR83Alo/ExUCvPwr1CdDAnp39N/Lqs/40s1g
         yoedNTLhsk3+42k5i1VUXPXPCpZpv7RJcnL5cG5BA73QtKgFelaAlDku+5SGQ+iUeN
         RxP9sZaxdXdL2OAzxO2wanvi2IezgCNG2VCysTxdngXCR38I4rME3TZ56OMw/k4C0k
         vq7WmPebXv8Fu9tKtDy0O+yIxlPtiJrTJ8EI7JEk+10sIO+6Zd+5JEI+tTyHe78DHx
         MdK6RLoTZGOcywJq86synyzoOH1yiyE+73eTcoFE2xyUUjYsFvf+lt7lvx0FNaVlrH
         Obb6acZECKicw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 064/189] MIPS: cpu-probe: Fix FPU detection on Ingenic JZ4760(B)
Date:   Tue,  6 Jul 2021 07:12:04 -0400
Message-Id: <20210706111409.2058071-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index 0ef240adefb5..630fcb4cb30e 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1840,6 +1840,11 @@ static inline void cpu_probe_ingenic(struct cpuinfo_mips *c, unsigned int cpu)
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

