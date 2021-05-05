Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A406D37419B
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbhEEQkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235154AbhEEQhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:37:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3230E61460;
        Wed,  5 May 2021 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232407;
        bh=AVW9KZQZQ/6kb1WJZhlXCTs6EReUWd4bDpcgMXxWuCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQdTS6Za3SIPsktbZ3WSbBr1tgaiLKYaaWIHd+ZgG0c1Y2FSXeKs8qRF+1dnXVxyM
         OAO5fI4R6P4BuPmmqWJa0zQEqCo9mWgg73jeroUcj3NHiMK1uelK6FQjvp74qtBHUe
         Mbrih3R195OL+COwDsY6zGtEYnZRQJIeSIF0GCGEpe/NFITrRNBzenUlheXKyYffnJ
         2WaXXp4K55DwEvz78iKZv98JMVfKM/4+vaNvMob6DoXJoOPi3xWxDtcMXIF8Gfj9Wx
         ibMUmf5T67yOzEMBxhogmjO8NnJeFSc3u25xLZr+m6zeGxD8y7cm13U7mtGzFZeFbV
         ySEpCB5D+UIlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.12 086/116] powerpc/xive: Use the "ibm, chip-id" property only under PowerNV
Date:   Wed,  5 May 2021 12:30:54 -0400
Message-Id: <20210505163125.3460440-86-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

[ Upstream commit e9e16917bc388846163b8566a298a291d71e44c9 ]

The 'chip_id' field of the XIVE CPU structure is used to choose a
target for a source located on the same chip. For that, the XIVE
driver queries the chip identifier from the "ibm,chip-id" property
and compares it to a 'src_chip' field identifying the chip of a
source. This information is only available on the PowerNV platform,
'src_chip' being assigned to XIVE_INVALID_CHIP_ID under pSeries.

The "ibm,chip-id" property is also not available on all platforms. It
was first introduced on PowerNV and later, under QEMU for pSeries/KVM.
However, the property is not part of PAPR and does not exist under
pSeries/PowerVM.

Assign 'chip_id' to XIVE_INVALID_CHIP_ID by default and let the
PowerNV platform override the value with the "ibm,chip-id" property.

Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210413130352.1183267-1-clg@kaod.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/common.c        | 9 +++------
 arch/powerpc/sysdev/xive/native.c        | 6 ++++++
 arch/powerpc/sysdev/xive/xive-internal.h | 1 +
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 595310e056f4..e897c3bab371 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1335,17 +1335,14 @@ static int xive_prepare_cpu(unsigned int cpu)
 
 	xc = per_cpu(xive_cpu, cpu);
 	if (!xc) {
-		struct device_node *np;
-
 		xc = kzalloc_node(sizeof(struct xive_cpu),
 				  GFP_KERNEL, cpu_to_node(cpu));
 		if (!xc)
 			return -ENOMEM;
-		np = of_get_cpu_node(cpu, NULL);
-		if (np)
-			xc->chip_id = of_get_ibm_chip_id(np);
-		of_node_put(np);
 		xc->hw_ipi = XIVE_BAD_IRQ;
+		xc->chip_id = XIVE_INVALID_CHIP_ID;
+		if (xive_ops->prepare_cpu)
+			xive_ops->prepare_cpu(cpu, xc);
 
 		per_cpu(xive_cpu, cpu) = xc;
 	}
diff --git a/arch/powerpc/sysdev/xive/native.c b/arch/powerpc/sysdev/xive/native.c
index 05a800a3104e..57e3f1540435 100644
--- a/arch/powerpc/sysdev/xive/native.c
+++ b/arch/powerpc/sysdev/xive/native.c
@@ -380,6 +380,11 @@ static void xive_native_update_pending(struct xive_cpu *xc)
 	}
 }
 
+static void xive_native_prepare_cpu(unsigned int cpu, struct xive_cpu *xc)
+{
+	xc->chip_id = cpu_to_chip_id(cpu);
+}
+
 static void xive_native_setup_cpu(unsigned int cpu, struct xive_cpu *xc)
 {
 	s64 rc;
@@ -462,6 +467,7 @@ static const struct xive_ops xive_native_ops = {
 	.match			= xive_native_match,
 	.shutdown		= xive_native_shutdown,
 	.update_pending		= xive_native_update_pending,
+	.prepare_cpu		= xive_native_prepare_cpu,
 	.setup_cpu		= xive_native_setup_cpu,
 	.teardown_cpu		= xive_native_teardown_cpu,
 	.sync_source		= xive_native_sync_source,
diff --git a/arch/powerpc/sysdev/xive/xive-internal.h b/arch/powerpc/sysdev/xive/xive-internal.h
index 9cf57c722faa..6478be19b4d3 100644
--- a/arch/powerpc/sysdev/xive/xive-internal.h
+++ b/arch/powerpc/sysdev/xive/xive-internal.h
@@ -46,6 +46,7 @@ struct xive_ops {
 				  u32 *sw_irq);
 	int	(*setup_queue)(unsigned int cpu, struct xive_cpu *xc, u8 prio);
 	void	(*cleanup_queue)(unsigned int cpu, struct xive_cpu *xc, u8 prio);
+	void	(*prepare_cpu)(unsigned int cpu, struct xive_cpu *xc);
 	void	(*setup_cpu)(unsigned int cpu, struct xive_cpu *xc);
 	void	(*teardown_cpu)(unsigned int cpu, struct xive_cpu *xc);
 	bool	(*match)(struct device_node *np);
-- 
2.30.2

