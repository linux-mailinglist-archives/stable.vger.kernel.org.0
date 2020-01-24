Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E3914849E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392071AbgAXLmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:42:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389695AbgAXLNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:13:52 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DF6D2077C;
        Fri, 24 Jan 2020 11:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864431;
        bh=k7VpQ2HWw1DFJqwi44KrSWhS4YrO2NNiRLH07SXh4u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrmTadloXVV+ipAZkcmylaF7zjG95e5SIFPsXEo1mTaW0xq4m0YM7HfiYxs20AdNy
         DjNjt4Mkhm87neoNN9nn0TGfDcSege7LZ33fFKeLR2AuMwx1cAneoRuvT7gCL4fjfy
         lxftEU1zUiCmUURRDbeoUOj3j7Fx6eToeo31EnMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akihiro Tsukada <tskd08@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 250/639] media: dvb/earth-pt1: fix wrong initialization for demod blocks
Date:   Fri, 24 Jan 2020 10:27:00 +0100
Message-Id: <20200124093118.061033210@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7f878fc41b7e6..93fecffb36ee7 100644
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



