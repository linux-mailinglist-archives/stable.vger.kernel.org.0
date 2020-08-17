Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3C124746F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387701AbgHQTJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387497AbgHQPmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:42:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1275420825;
        Mon, 17 Aug 2020 15:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678927;
        bh=Qu/3foyaXERMqY1vv8CRgOXlPV4nyRt88WLVppSA5wU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgJqVUs2ssWPu6VIgXUTMPfGJ8n1/QZwtYOowzX/E7+aTB4z5I+iC4JjxjdIG09M3
         xAbqrqhKCnnFc7LMKs0XoSQRC+lvbc4H+mYwqO4iENF7g0E2u/GnOnN7py7DsywwAT
         BiZ9n4Lu4TrszG6HcPbSG+k2iOhJdx1c6gdFecxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 038/393] reset: intel: fix a compile warning about REG_OFFSET redefined
Date:   Mon, 17 Aug 2020 17:11:28 +0200
Message-Id: <20200817143821.454930538@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



