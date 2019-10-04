Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75283CBC90
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 16:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388662AbfJDOCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 10:02:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388197AbfJDOCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 10:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=t7J29z5Sa4jOMUaC7PrNqwKEMHnoUWQEXcqpefkJ+hw=; b=Ge8M86L32XW7atVxms+XpPg+7a
        VA6bFia5EeSz0Jeo2dONVhxHOAgQte1paule/ax1ES+XyvzA5bQ/e/fLPN1T6fHAOs5Pk4wEnHVmu
        jJNr84VYikruWfra6/HP60ujdVy/Sc5FE16ChQWnh3m5VS/2X8u3vWRXTBr+Wb6d2Sn6HYzJscv/J
        tF6WRPL+f0gROkv0QLgC0oucv8VYxi+NLXDUViGeUHNYaOgUh/LzKh4RVxSCBQijARb8NpqDEiTgL
        xrSK7J+HJmxUgkm4tjgEhn4gvdLRCfoi/+YMeZ/tF1mnN/Bw2jK+o6c/2liQZNiLIRmc6yjUuFWGa
        xYmk8yVw==;
Received: from 177.133.68.49.dynamic.adsl.gvt.net.br ([177.133.68.49] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iGOAF-00025r-7F; Fri, 04 Oct 2019 14:02:35 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.2)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iGOAB-0003A7-Rc; Fri, 04 Oct 2019 11:02:31 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        stable@vger.kernel.org
Subject: [PATCH v3] media: cxd2841er: avoid too many status inquires
Date:   Fri,  4 Oct 2019 11:02:28 -0300
Message-Id: <483cecc9f65b03ad3cd54aea09ecd9819c3dc6db.1570197700.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <deda32250ad32078b98eb41eb09d6d20050a6f9c.1570113429.git.mchehab+samsung@kernel.org>
References: <deda32250ad32078b98eb41eb09d6d20050a6f9c.1570113429.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As reported at:
	https://tvheadend.org/issues/5625

Retrieving certain status can cause discontinuity issues.

Prevent that by adding a timeout to each status logic.

Currently, the timeout is estimated based at the channel
bandwidth. There are other parameters that may also affect
the timeout, but that would require a per-delivery system
calculus and probably more information about how cxd2481er
works, with we don't have.

So, do a poor man's best guess.

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/cxd2841er.c | 68 +++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 1b30cf570803..218da631df19 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -60,6 +60,13 @@ struct cxd2841er_priv {
 	enum cxd2841er_xtal		xtal;
 	enum fe_caps caps;
 	u32				flags;
+
+	unsigned long			ber_interval;
+	unsigned long			ucb_interval;
+
+	unsigned long			ber_time;
+	unsigned long			ucb_time;
+	unsigned long			snr_time;
 };
 
 static const struct cxd2841er_cnr_data s_cn_data[] = {
@@ -1941,6 +1948,10 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
 	u32 ret, bit_error = 0, bit_count = 0;
 
+	if (priv->ber_time &&
+	   (!time_after(jiffies, priv->ber_time)))
+		return;
+
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
 	case SYS_DVBC_ANNEX_A:
@@ -1953,9 +1964,15 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
 		break;
 	case SYS_DVBS:
 		ret = cxd2841er_mon_read_ber_s(priv, &bit_error, &bit_count);
+
+		if (!priv->ber_interval && p->symbol_rate)
+			priv->ber_interval = (10000000) / (p->symbol_rate / 1000);
 		break;
 	case SYS_DVBS2:
 		ret = cxd2841er_mon_read_ber_s2(priv, &bit_error, &bit_count);
+
+		if (!priv->ber_interval && p->symbol_rate)
+			priv->ber_interval = (10000000) / (p->symbol_rate / 1000);
 		break;
 	case SYS_DVBT:
 		ret = cxd2841er_read_ber_t(priv, &bit_error, &bit_count);
@@ -1978,6 +1995,21 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
 		p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
+
+	/*
+	 * If the per-delivery system doesn't specify, set a default timeout
+	 * that will wait for ~12.5 seconds for 8MHz channels
+	 */
+	if (!priv->ber_interval && p->bandwidth_hz)
+		priv->ber_interval = (100000000) / (p->bandwidth_hz / 1000);
+
+	if (priv->ber_interval < 1000)
+		priv->ber_interval = 1000;
+
+// HACK:
+dev_info(&priv->i2c->dev, "BER interval: %d ms", priv->ber_interval);
+
+	priv->ber_time = jiffies + msecs_to_jiffies(priv->ber_interval);
 }
 
 static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
@@ -2037,6 +2069,16 @@ static void cxd2841er_read_snr(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
 
+	if (priv->snr_time &&
+	   (!time_after(jiffies, priv->snr_time)))
+		return;
+
+	/* Preventing asking SNR more than once per second */
+	priv->snr_time = jiffies + msecs_to_jiffies(1000);
+
+// HACK
+dev_info(&priv->i2c->dev, "SNR interval: %d ms", 1000);
+
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
 	case SYS_DVBC_ANNEX_A:
@@ -2081,6 +2123,10 @@ static void cxd2841er_read_ucblocks(struct dvb_frontend *fe)
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
 	u32 ucblocks = 0;
 
+	if (priv->ucb_time &&
+	   (!time_after(jiffies, priv->ucb_time)))
+		return;
+
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
 	case SYS_DVBC_ANNEX_A:
@@ -2105,6 +2151,21 @@ static void cxd2841er_read_ucblocks(struct dvb_frontend *fe)
 
 	p->block_error.stat[0].scale = FE_SCALE_COUNTER;
 	p->block_error.stat[0].uvalue = ucblocks;
+
+	/*
+	 * If the per-delivery system doesn't specify, set a default timeout
+	 * that will wait 20-30 seconds
+	 */
+	if (!priv->ucb_interval && p->bandwidth_hz)
+		priv->ucb_interval = (100 * 204 * 1000 * 8) / p->bandwidth_hz;
+
+	if (priv->ucb_interval < 1000)
+		priv->ucb_interval = 1000;
+
+// HACK:
+dev_info(&priv->i2c->dev, "UCB interval: %d ms", priv->ucb_interval);
+
+	priv->ucb_time = jiffies + msecs_to_jiffies(priv->ucb_interval);
 }
 
 static int cxd2841er_dvbt2_set_profile(
@@ -3360,6 +3421,13 @@ static int cxd2841er_set_frontend_s(struct dvb_frontend *fe)
 	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
+	/* Reset the wait for jiffies logic */
+	priv->ber_interval = 0;
+	priv->ucb_interval = 0;
+	priv->ber_time = 0;
+	priv->ucb_time = 0;
+	priv->snr_time = 0;
+
 	return ret;
 }
 
-- 
2.21.0

