Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C5423FB12
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgHHXrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgHHXiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F239320748;
        Sat,  8 Aug 2020 23:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929893;
        bh=Qu/3foyaXERMqY1vv8CRgOXlPV4nyRt88WLVppSA5wU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7hUBCUnIYM2ab2rdZY1PGoDkCDPvJ/v6DqAAKN4Gz7o6FKXcUSCbbe3zyvPZaqwS
         pUL1hMcXQ7kpen1xss00W4/+dLkHEd+0Ex4X1iGLzXXOfVKGcIXJ+TnlPYQiA+uJeq
         513KRUGN1VaAA1tK4UpI7pLlMYaUzU0hrHvlXuBg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dejin Zheng <zhengdejin5@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 34/58] reset: intel: fix a compile warning about REG_OFFSET redefined
Date:   Sat,  8 Aug 2020 19:37:00 -0400
Message-Id: <20200808233724.3618168-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>

[ Upstream commit 308646785e51976dea7e20d29a1842d14bf0b9bd ]

kernel test robot reports a compile warning about REG_OFFSET redefined
in the reset-intel-gw.c after merging commit e44ab4e14d6f4 ("regmap:
Simplify implementation of the regmap_read_poll_timeout() macro"). the
warning is like that:

drivers/reset/reset-intel-gw.c:18:0: warning: "REG_OFFSET" redefined
 #define REG_OFFSET GENMASK(31, 16)

In file included from ./arch/arm/mach-ixp4xx/include/mach/hardware.h:30:0,
                 from ./arch/arm/mach-ixp4xx/include/mach/io.h:15,
                 from ./arch/arm/include/asm/io.h:198,
                 from ./include/linux/io.h:13,
                 from ./include/linux/iopoll.h:14,
                 from ./include/linux/regmap.h:20,
                 from drivers/reset/reset-intel-gw.c:12:
./arch/arm/mach-ixp4xx/include/mach/platform.h:25:0: note: this is the location of the previous definition
 #define REG_OFFSET 3

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c9aef213e38cde ("reset: intel: Add system reset controller driver")
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-intel-gw.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/reset/reset-intel-gw.c b/drivers/reset/reset-intel-gw.c
index 854238444616b..effc177db80af 100644
--- a/drivers/reset/reset-intel-gw.c
+++ b/drivers/reset/reset-intel-gw.c
@@ -15,9 +15,9 @@
 #define RCU_RST_STAT	0x0024
 #define RCU_RST_REQ	0x0048
 
-#define REG_OFFSET	GENMASK(31, 16)
-#define BIT_OFFSET	GENMASK(15, 8)
-#define STAT_BIT_OFFSET	GENMASK(7, 0)
+#define REG_OFFSET_MASK	GENMASK(31, 16)
+#define BIT_OFFSET_MASK	GENMASK(15, 8)
+#define STAT_BIT_OFFSET_MASK	GENMASK(7, 0)
 
 #define to_reset_data(x)	container_of(x, struct intel_reset_data, rcdev)
 
@@ -51,11 +51,11 @@ static u32 id_to_reg_and_bit_offsets(struct intel_reset_data *data,
 				     unsigned long id, u32 *rst_req,
 				     u32 *req_bit, u32 *stat_bit)
 {
-	*rst_req = FIELD_GET(REG_OFFSET, id);
-	*req_bit = FIELD_GET(BIT_OFFSET, id);
+	*rst_req = FIELD_GET(REG_OFFSET_MASK, id);
+	*req_bit = FIELD_GET(BIT_OFFSET_MASK, id);
 
 	if (data->soc_data->legacy)
-		*stat_bit = FIELD_GET(STAT_BIT_OFFSET, id);
+		*stat_bit = FIELD_GET(STAT_BIT_OFFSET_MASK, id);
 	else
 		*stat_bit = *req_bit;
 
@@ -141,14 +141,14 @@ static int intel_reset_xlate(struct reset_controller_dev *rcdev,
 	if (spec->args[1] > 31)
 		return -EINVAL;
 
-	id = FIELD_PREP(REG_OFFSET, spec->args[0]);
-	id |= FIELD_PREP(BIT_OFFSET, spec->args[1]);
+	id = FIELD_PREP(REG_OFFSET_MASK, spec->args[0]);
+	id |= FIELD_PREP(BIT_OFFSET_MASK, spec->args[1]);
 
 	if (data->soc_data->legacy) {
 		if (spec->args[2] > 31)
 			return -EINVAL;
 
-		id |= FIELD_PREP(STAT_BIT_OFFSET, spec->args[2]);
+		id |= FIELD_PREP(STAT_BIT_OFFSET_MASK, spec->args[2]);
 	}
 
 	return id;
@@ -210,11 +210,11 @@ static int intel_reset_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	data->reboot_id = FIELD_PREP(REG_OFFSET, rb_id[0]);
-	data->reboot_id |= FIELD_PREP(BIT_OFFSET, rb_id[1]);
+	data->reboot_id = FIELD_PREP(REG_OFFSET_MASK, rb_id[0]);
+	data->reboot_id |= FIELD_PREP(BIT_OFFSET_MASK, rb_id[1]);
 
 	if (data->soc_data->legacy)
-		data->reboot_id |= FIELD_PREP(STAT_BIT_OFFSET, rb_id[2]);
+		data->reboot_id |= FIELD_PREP(STAT_BIT_OFFSET_MASK, rb_id[2]);
 
 	data->restart_nb.notifier_call =	intel_reset_restart_handler;
 	data->restart_nb.priority =		128;
-- 
2.25.1

