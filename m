Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCFD10704B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfKVKpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbfKVKpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:45:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2FDA20717;
        Fri, 22 Nov 2019 10:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419508;
        bh=LKMhtjxEW4lnTFxYqZTK/rlDQFdEDmQqHjo7U3iI96Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udicQBa4zdlF0qgtAncchN6YonRAvjevxkiuEWzJnnvfqEphfLMHav0fBP5W9A0tj
         dDFhlYdWudd3Hk42vXmK3OfwyNI1UCPRanP3mz21D5rnx37fB5OwajozgVHU2dlIuz
         /mnlehyb2A3vYaKjPpu0IZyOsoWD/6rS93fkWxlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tomasz Nowicki <tnowicki@caviumnetworks.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 118/222] coresight: etm4x: Configure EL2 exception level when kernel is running in HYP
Date:   Fri, 22 Nov 2019 11:27:38 +0100
Message-Id: <20191122100911.664304131@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomasz Nowicki <tnowicki@caviumnetworks.com>

[ Upstream commit b860801e3237ec4c74cf8de0be4816996757ae5c ]

For non-VHE systems host kernel runs at EL1 and jumps to EL2 whenever
hypervisor code should be executed. In this case ETM4x driver must
restrict configuration to EL1 when it setups kernel tracing.
However, there is no separate hypervisor privilege level when VHE
is enabled, the host kernel runs at EL2.

This patch fixes configuration of TRCACATRn register for VHE systems
so that ETM_EXLEVEL_NS_HYP bit is used instead of ETM_EXLEVEL_NS_OS
to on/off kernel tracing. At the same time, it moves common code
to new helper.

Signed-off-by: Tomasz Nowicki <tnowicki@caviumnetworks.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.c | 40 +++++++++----------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 44d6c29e26448..22079f886f452 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -35,6 +35,7 @@
 #include <linux/pm_runtime.h>
 #include <asm/sections.h>
 #include <asm/local.h>
+#include <asm/virt.h>
 
 #include "coresight-etm4x.h"
 #include "coresight-etm-perf.h"
@@ -615,7 +616,7 @@ static void etm4_set_default_config(struct etmv4_config *config)
 	config->vinst_ctrl |= BIT(0);
 }
 
-static u64 etm4_get_access_type(struct etmv4_config *config)
+static u64 etm4_get_ns_access_type(struct etmv4_config *config)
 {
 	u64 access_type = 0;
 
@@ -626,17 +627,26 @@ static u64 etm4_get_access_type(struct etmv4_config *config)
 	 *   Bit[13] Exception level 1 - OS
 	 *   Bit[14] Exception level 2 - Hypervisor
 	 *   Bit[15] Never implemented
-	 *
-	 * Always stay away from hypervisor mode.
 	 */
-	access_type = ETM_EXLEVEL_NS_HYP;
-
-	if (config->mode & ETM_MODE_EXCL_KERN)
-		access_type |= ETM_EXLEVEL_NS_OS;
+	if (!is_kernel_in_hyp_mode()) {
+		/* Stay away from hypervisor mode for non-VHE */
+		access_type =  ETM_EXLEVEL_NS_HYP;
+		if (config->mode & ETM_MODE_EXCL_KERN)
+			access_type |= ETM_EXLEVEL_NS_OS;
+	} else if (config->mode & ETM_MODE_EXCL_KERN) {
+		access_type = ETM_EXLEVEL_NS_HYP;
+	}
 
 	if (config->mode & ETM_MODE_EXCL_USER)
 		access_type |= ETM_EXLEVEL_NS_APP;
 
+	return access_type;
+}
+
+static u64 etm4_get_access_type(struct etmv4_config *config)
+{
+	u64 access_type = etm4_get_ns_access_type(config);
+
 	/*
 	 * EXLEVEL_S, bits[11:8], don't trace anything happening
 	 * in secure state.
@@ -890,20 +900,10 @@ void etm4_config_trace_mode(struct etmv4_config *config)
 
 	addr_acc = config->addr_acc[ETM_DEFAULT_ADDR_COMP];
 	/* clear default config */
-	addr_acc &= ~(ETM_EXLEVEL_NS_APP | ETM_EXLEVEL_NS_OS);
+	addr_acc &= ~(ETM_EXLEVEL_NS_APP | ETM_EXLEVEL_NS_OS |
+		      ETM_EXLEVEL_NS_HYP);
 
-	/*
-	 * EXLEVEL_NS, bits[15:12]
-	 * The Exception levels are:
-	 *   Bit[12] Exception level 0 - Application
-	 *   Bit[13] Exception level 1 - OS
-	 *   Bit[14] Exception level 2 - Hypervisor
-	 *   Bit[15] Never implemented
-	 */
-	if (mode & ETM_MODE_EXCL_KERN)
-		addr_acc |= ETM_EXLEVEL_NS_OS;
-	else
-		addr_acc |= ETM_EXLEVEL_NS_APP;
+	addr_acc |= etm4_get_ns_access_type(config);
 
 	config->addr_acc[ETM_DEFAULT_ADDR_COMP] = addr_acc;
 	config->addr_acc[ETM_DEFAULT_ADDR_COMP + 1] = addr_acc;
-- 
2.20.1



