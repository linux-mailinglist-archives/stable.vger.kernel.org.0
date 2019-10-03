Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8B7CA0CB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 16:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfJCO7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 10:59:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48748 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfJCO7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 10:59:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vdX9bsZUwU/FQfv93r67PyIlLem9UgwThvV7CbTnmm0=; b=bos1Nau+3EF1eL2JAHapN20Dr
        FbGKAjehRXptqOnogLAVXhYUV7FsCFAqZVflnOfmrZqjcYOcRva7hAe9Ks6DvqHz+PU6REscf5a1R
        C/jRFXbpPB69LjcdY9FGM/4m4H9Cqc3R4IinHlCGEFmcERpsRvb5gTZVuZn01h8gxUQLzECQsRxOA
        Fxbr+ykhUULGyDEp9Vr9dJVi2XlXy2SzrI3vxBa6es9gBKhzOaBKyD6dwpVTDR4an8Eh9FRoN7Jp1
        kTa6Zi4GJJZKrJDZ+UIP6qKCvYVJEHLSIzrP10E1W7APVGYVo/VVw3aZQzm1ZcmkABC8GsoU9pJgR
        73NSiXfTA==;
Received: from 177.133.68.49.dynamic.adsl.gvt.net.br ([177.133.68.49] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iG2Zh-000219-4G; Thu, 03 Oct 2019 14:59:25 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.2)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iG2Ze-0003v2-Pm; Thu, 03 Oct 2019 11:59:22 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        stable@vger.kernel.org
Subject: [PATCH] media: cxd2841er: avoid too many status inquires
Date:   Thu,  3 Oct 2019 11:59:22 -0300
Message-Id: <6251e730c1517d1bbc11c5eb803177f6a71b3d9c.1570114759.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
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
 drivers/media/dvb-frontends/cxd2841er.c | 59 +++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 1b30cf570803..71428b0d2620 100644
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
@@ -1941,12 +1948,20 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
 	u32 ret, bit_error = 0, bit_count = 0;
 
+	if (priv->ber_time &&
+	   (!time_after(jiffies, priv->ber_time)))
+		return;
+
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
 	case SYS_DVBC_ANNEX_A:
 	case SYS_DVBC_ANNEX_B:
 	case SYS_DVBC_ANNEX_C:
 		ret = cxd2841er_read_ber_c(priv, &bit_error, &bit_count);
+
+		if (!priv->ber_interval && p->symbol_rate)
+			priv->ber_interval = (10000000) / (p->symbol_rate / 1000);
+
 		break;
 	case SYS_ISDBT:
 		ret = cxd2841er_read_ber_i(priv, &bit_error, &bit_count);
@@ -1978,6 +1993,18 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
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
+	priv->ber_time = jiffies + msecs_to_jiffies(priv->ber_interval);
 }
 
 static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
@@ -2037,6 +2064,13 @@ static void cxd2841er_read_snr(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
 
+	if (priv->snr_time &&
+	   (!time_after(jiffies, priv->snr_time)))
+		return;
+
+	/* Preventing asking SNR more than once per second */
+	priv->snr_time = jiffies + msecs_to_jiffies(1000);
+
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
 	case SYS_DVBC_ANNEX_A:
@@ -2081,12 +2115,18 @@ static void cxd2841er_read_ucblocks(struct dvb_frontend *fe)
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
 	u32 ucblocks = 0;
 
+	if (priv->ucb_time &&
+	   (!time_after(jiffies, priv->ucb_time)))
+		return;
+
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
 	case SYS_DVBC_ANNEX_A:
 	case SYS_DVBC_ANNEX_B:
 	case SYS_DVBC_ANNEX_C:
 		cxd2841er_read_packet_errors_c(priv, &ucblocks);
+		if (!priv->ucb_interval && p->symbol_rate)
+		    priv->ucb_interval = (100 * 204 * 1000 * 8) / p->symbol_rate;
 		break;
 	case SYS_DVBT:
 		cxd2841er_read_packet_errors_t(priv, &ucblocks);
@@ -2105,6 +2145,18 @@ static void cxd2841er_read_ucblocks(struct dvb_frontend *fe)
 
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
+	priv->ucb_time = jiffies + msecs_to_jiffies(priv->ucb_interval);
 }
 
 static int cxd2841er_dvbt2_set_profile(
@@ -3360,6 +3412,13 @@ static int cxd2841er_set_frontend_s(struct dvb_frontend *fe)
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

