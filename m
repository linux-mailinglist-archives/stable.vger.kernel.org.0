Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E393CAA26
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242253AbhGOTMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243490AbhGOTJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C99261158;
        Thu, 15 Jul 2021 19:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375942;
        bh=jkuEZkfL7lr8mk1AeV04Qf6U6eKhfHJ7PJkPe7AUo14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErFpI2YPXNa5yAEOs+7/u11TBgTkiHglM5GxIH2fpfhayZD9Kd24fus6hK3H+t38y
         p5v94GFegpVWJGGj5JKWPlCmgMe4a3MBkGM06vQYkDX7V2GM40xC+M8949ZYDpoylE
         /XjE/7GzwTjrwFYX+p27XSF/EYMCrBVIgkQ6nJXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 058/266] MIPS: cpu-probe: Fix FPU detection on Ingenic JZ4760(B)
Date:   Thu, 15 Jul 2021 20:36:53 +0200
Message-Id: <20210715182624.443104202@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



