Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670BAF63FA
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfKJC4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:56:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729567AbfKJCtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:49:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77F4622593;
        Sun, 10 Nov 2019 02:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354191;
        bh=LKMhtjxEW4lnTFxYqZTK/rlDQFdEDmQqHjo7U3iI96Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhvuQrfRpVR9UON1Jjsn/015h9LgqTBWwu+LLYp3G5XEpZoyhazj595M2rax/pcbR
         YqlTJqyyw1BMZX5vvA6soPo63Ynxee3mEFfZP9kumuPXNmml70n8Naw4yJZ8yi3+wj
         5c2c6mx38THXgLTtPTgM95Exmux0i78BaUeTrOqk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomasz Nowicki <tnowicki@caviumnetworks.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 39/66] coresight: etm4x: Configure EL2 exception level when kernel is running in HYP
Date:   Sat,  9 Nov 2019 21:48:18 -0500
Message-Id: <20191110024846.32598-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

