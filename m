Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CF013F65C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388403AbgAPRCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730518AbgAPRCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4392321582;
        Thu, 16 Jan 2020 17:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194150;
        bh=6azb/Fy2UuEvrdC3qRPeiBm9IqHqfM9HwCsIylrmiDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubjj413BVog6aJwzSwQpp+1ngXkGGb5ty0jjIlVdLblD+e/LxXTP3mmVAaCPlNxb/
         vBr48Scl3pGbbHu/3k3gUDb6vWFWvSokozmN0tUGEOrUAARPh9iiTGtjAXiF9Qi2N6
         n1sGaW1dEB2bSxpFkW7mYiBMWA/VwWOgyDetufmI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akihiro Tsukada <tskd08@gmail.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 234/671] media: dvb/earth-pt1: fix wrong initialization for demod blocks
Date:   Thu, 16 Jan 2020 11:52:23 -0500
Message-Id: <20200116165940.10720-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akihiro Tsukada <tskd08@gmail.com>

[ Upstream commit 15d90a6ae98e6d2c68497b44a491cb9efbb98ab1 ]

earth-pt1 driver was decomposed/restructured by the commit b732539efdba
("media: dvb: earth-pt1: decompose pt1 driver into sub drivers"),
but it introduced a problem regarding concurrent streaming:
Opening a new terrestial stream stops the reception of an existing,
already-opened satellite stream.

The demod IC in earth-pt1 boards contains 2 pairs of terr. and sat. blocks,
supporting 4 concurrent demodulations, and the above problem was because
the config of a terr. block contained whole reset/init of the pair blocks,
thus each open() of a terrestrial frontend wrongly cleared the config of
its peer satellite block of the demod.
This whole/pair reset should be executed earlier and not on each open().

Fixes: b732539efdba ("media: dvb: earth-pt1: decompose pt1 driver into sub drivers")

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/pt1/pt1.c | 54 ++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 7f878fc41b7e..93fecffb36ee 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -200,16 +200,10 @@ static const u8 va1j5jf8007t_25mhz_configs[][2] = {
 static int config_demod(struct i2c_client *cl, enum pt1_fe_clk clk)
 {
 	int ret;
-	u8 buf[2] = {0x01, 0x80};
 	bool is_sat;
 	const u8 (*cfg_data)[2];
 	int i, len;
 
-	ret = i2c_master_send(cl, buf, 2);
-	if (ret < 0)
-		return ret;
-	usleep_range(30000, 50000);
-
 	is_sat = !strncmp(cl->name, TC90522_I2C_DEV_SAT,
 			  strlen(TC90522_I2C_DEV_SAT));
 	if (is_sat) {
@@ -260,6 +254,46 @@ static int config_demod(struct i2c_client *cl, enum pt1_fe_clk clk)
 	return 0;
 }
 
+/*
+ * Init registers for (each pair of) terrestrial/satellite block in demod.
+ * Note that resetting terr. block also resets its peer sat. block as well.
+ * This function must be called before configuring any demod block
+ * (before pt1_wakeup(), fe->ops.init()).
+ */
+static int pt1_demod_block_init(struct pt1 *pt1)
+{
+	struct i2c_client *cl;
+	u8 buf[2] = {0x01, 0x80};
+	int ret;
+	int i;
+
+	/* reset all terr. & sat. pairs first */
+	for (i = 0; i < PT1_NR_ADAPS; i++) {
+		cl = pt1->adaps[i]->demod_i2c_client;
+		if (strncmp(cl->name, TC90522_I2C_DEV_TER,
+			    strlen(TC90522_I2C_DEV_TER)))
+			continue;
+
+		ret = i2c_master_send(cl, buf, 2);
+		if (ret < 0)
+			return ret;
+		usleep_range(30000, 50000);
+	}
+
+	for (i = 0; i < PT1_NR_ADAPS; i++) {
+		cl = pt1->adaps[i]->demod_i2c_client;
+		if (strncmp(cl->name, TC90522_I2C_DEV_SAT,
+			    strlen(TC90522_I2C_DEV_SAT)))
+			continue;
+
+		ret = i2c_master_send(cl, buf, 2);
+		if (ret < 0)
+			return ret;
+		usleep_range(30000, 50000);
+	}
+	return 0;
+}
+
 static void pt1_write_reg(struct pt1 *pt1, int reg, u32 data)
 {
 	writel(data, pt1->regs + reg * 4);
@@ -987,6 +1021,10 @@ static int pt1_init_frontends(struct pt1 *pt1)
 			goto tuner_release;
 	}
 
+	ret = pt1_demod_block_init(pt1);
+	if (ret < 0)
+		goto fe_unregister;
+
 	return 0;
 
 tuner_release:
@@ -1245,6 +1283,10 @@ static int pt1_resume(struct device *dev)
 	pt1_update_power(pt1);
 	usleep_range(1000, 2000);
 
+	ret = pt1_demod_block_init(pt1);
+	if (ret < 0)
+		goto resume_err;
+
 	for (i = 0; i < PT1_NR_ADAPS; i++)
 		dvb_frontend_reinitialise(pt1->adaps[i]->fe);
 
-- 
2.20.1

