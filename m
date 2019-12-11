Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F9111B6A0
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbfLKPNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730702AbfLKPNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFBAC20663;
        Wed, 11 Dec 2019 15:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077197;
        bh=lQByssjgqWaVZWGX1nyIVM5aR1JZ2it8lsG75l/CR1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRkva60YWAM8rlvbEsJpl3rjVa12nPHZ97qi+aeDDvw5fbZ+pSttTPc+2c0NrYimq
         tnPi8mQf9sOyMZCRuShQzq1j2S05gkZm2R1XEq43bRbZSMDcCg13GC0F2uJx0seOlr
         9LXGrM/8/FmOwb5BiAn6PvnMVJFZCh2VL/wD9nng=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 080/134] ARM: 8937/1: spectre-v2: remove Brahma-B53 from hardening
Date:   Wed, 11 Dec 2019 10:10:56 -0500
Message-Id: <20191211151150.19073-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 4ae5061a19b550dfe25397843427ed2ebab16b16 ]

When the default processor handling was added to the function
cpu_v7_spectre_init() it only excluded other ARM implemented processor
cores. The Broadcom Brahma B53 core is not implemented by ARM so it
ended up falling through into the set of processors that attempt to use
the ARM_SMCCC_ARCH_WORKAROUND_1 service to harden the branch predictor.

Since this workaround is not necessary for the Brahma-B53 this commit
explicitly checks for it and prevents it from applying a branch
predictor hardening workaround.

Fixes: 10115105cb3a ("ARM: spectre-v2: add firmware based hardening")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/proc-v7-bugs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 9a07916af8dd2..a6554fdb56c54 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -65,6 +65,9 @@ static void cpu_v7_spectre_init(void)
 		break;
 
 #ifdef CONFIG_ARM_PSCI
+	case ARM_CPU_PART_BRAHMA_B53:
+		/* Requires no workaround */
+		break;
 	default:
 		/* Other ARM CPUs require no workaround */
 		if (read_cpuid_implementor() == ARM_CPU_IMP_ARM)
-- 
2.20.1

