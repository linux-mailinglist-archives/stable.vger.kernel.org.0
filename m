Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1264240507D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352746AbhIIM15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:27:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346703AbhIIMYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:24:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9709561AE0;
        Thu,  9 Sep 2021 11:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188284;
        bh=gB9z9wL68N4zA6j+tsmo/QkfIMZQNo6VHD+mttTBms0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YE0xMIuM6UBdv36KXQilt0NxkcL/hmfFdxwfuPCAE5KapoO/EZygFnstMvMky0Ys1
         2MbLHJwiea2Toa3qCwyEQGzgKOJR2GZYuBy36h1JNUQHDF2zzsCyMK5oddJn9FMkZa
         0m1FOFtutk0yQ/tIPcnpy5n38Rj9cqmmamRfxNPZnCEYzaF8NHquAjC6FfRnkyPsvI
         UEw4T3+kyd5c+6um/8SXMo/LnNpVUn43RjpZtxPZ1nO3h3TUNgBi49ZP3iGsyuMHzO
         XNAEcM/Shmn4M6XLY9U7oWa9IyLDKeD6CKJYAv86KzYu8KNOMfOBMaoNGAyGV0tspk
         G8sdfNK3SPLJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 004/176] media: dib8000: rewrite the init prbs logic
Date:   Thu,  9 Sep 2021 07:48:26 -0400
Message-Id: <20210909115118.146181-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 8db11aebdb8f93f46a8513c22c9bd52fa23263aa ]

The logic at dib8000_get_init_prbs() has a few issues:

1. the tables used there has an extra unused value at the beginning;
2. the dprintk() message doesn't write the right value when
   transmission mode is not 8K;
3. the array overflow validation is done by the callers.

Rewrite the code to fix such issues.

This should also shut up those smatch warnings:

	drivers/media/dvb-frontends/dib8000.c:2125 dib8000_get_init_prbs() error: buffer overflow 'lut_prbs_8k' 14 <= 14
	drivers/media/dvb-frontends/dib8000.c:2129 dib8000_get_init_prbs() error: buffer overflow 'lut_prbs_2k' 14 <= 14
	drivers/media/dvb-frontends/dib8000.c:2131 dib8000_get_init_prbs() error: buffer overflow 'lut_prbs_4k' 14 <= 14
	drivers/media/dvb-frontends/dib8000.c:2134 dib8000_get_init_prbs() error: buffer overflow 'lut_prbs_8k' 14 <= 14

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/dib8000.c | 58 +++++++++++++++++++--------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 082796534b0a..bb02354a48b8 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2107,32 +2107,55 @@ static void dib8000_load_ana_fe_coefs(struct dib8000_state *state, const s16 *an
 			dib8000_write_word(state, 117 + mode, ana_fe[mode]);
 }
 
-static const u16 lut_prbs_2k[14] = {
-	0, 0x423, 0x009, 0x5C7, 0x7A6, 0x3D8, 0x527, 0x7FF, 0x79B, 0x3D6, 0x3A2, 0x53B, 0x2F4, 0x213
+static const u16 lut_prbs_2k[13] = {
+	0x423, 0x009, 0x5C7,
+	0x7A6, 0x3D8, 0x527,
+	0x7FF, 0x79B, 0x3D6,
+	0x3A2, 0x53B, 0x2F4,
+	0x213
 };
-static const u16 lut_prbs_4k[14] = {
-	0, 0x208, 0x0C3, 0x7B9, 0x423, 0x5C7, 0x3D8, 0x7FF, 0x3D6, 0x53B, 0x213, 0x029, 0x0D0, 0x48E
+
+static const u16 lut_prbs_4k[13] = {
+	0x208, 0x0C3, 0x7B9,
+	0x423, 0x5C7, 0x3D8,
+	0x7FF, 0x3D6, 0x53B,
+	0x213, 0x029, 0x0D0,
+	0x48E
 };
-static const u16 lut_prbs_8k[14] = {
-	0, 0x740, 0x069, 0x7DD, 0x208, 0x7B9, 0x5C7, 0x7FF, 0x53B, 0x029, 0x48E, 0x4C4, 0x367, 0x684
+
+static const u16 lut_prbs_8k[13] = {
+	0x740, 0x069, 0x7DD,
+	0x208, 0x7B9, 0x5C7,
+	0x7FF, 0x53B, 0x029,
+	0x48E, 0x4C4, 0x367,
+	0x684
 };
 
 static u16 dib8000_get_init_prbs(struct dib8000_state *state, u16 subchannel)
 {
 	int sub_channel_prbs_group = 0;
+	int prbs_group;
 
-	sub_channel_prbs_group = (subchannel / 3) + 1;
-	dprintk("sub_channel_prbs_group = %d , subchannel =%d prbs = 0x%04x\n", sub_channel_prbs_group, subchannel, lut_prbs_8k[sub_channel_prbs_group]);
+	sub_channel_prbs_group = subchannel / 3;
+	if (sub_channel_prbs_group >= ARRAY_SIZE(lut_prbs_2k))
+		return 0;
 
 	switch (state->fe[0]->dtv_property_cache.transmission_mode) {
 	case TRANSMISSION_MODE_2K:
-			return lut_prbs_2k[sub_channel_prbs_group];
+		prbs_group = lut_prbs_2k[sub_channel_prbs_group];
+		break;
 	case TRANSMISSION_MODE_4K:
-			return lut_prbs_4k[sub_channel_prbs_group];
+		prbs_group =  lut_prbs_4k[sub_channel_prbs_group];
+		break;
 	default:
 	case TRANSMISSION_MODE_8K:
-			return lut_prbs_8k[sub_channel_prbs_group];
+		prbs_group = lut_prbs_8k[sub_channel_prbs_group];
 	}
+
+	dprintk("sub_channel_prbs_group = %d , subchannel =%d prbs = 0x%04x\n",
+		sub_channel_prbs_group, subchannel, prbs_group);
+
+	return prbs_group;
 }
 
 static void dib8000_set_13seg_channel(struct dib8000_state *state)
@@ -2409,10 +2432,8 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 	/* TSB or ISDBT ? apply it now */
 	if (c->isdbt_sb_mode) {
 		dib8000_set_sb_channel(state);
-		if (c->isdbt_sb_subchannel < 14)
-			init_prbs = dib8000_get_init_prbs(state, c->isdbt_sb_subchannel);
-		else
-			init_prbs = 0;
+		init_prbs = dib8000_get_init_prbs(state,
+						  c->isdbt_sb_subchannel);
 	} else {
 		dib8000_set_13seg_channel(state);
 		init_prbs = 0xfff;
@@ -3004,6 +3025,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 
 	unsigned long *timeout = &state->timeout;
 	unsigned long now = jiffies;
+	u16 init_prbs;
 #ifdef DIB8000_AGC_FREEZE
 	u16 agc1, agc2;
 #endif
@@ -3302,8 +3324,10 @@ static int dib8000_tune(struct dvb_frontend *fe)
 		break;
 
 	case CT_DEMOD_STEP_11:  /* 41 : init prbs autosearch */
-		if (state->subchannel <= 41) {
-			dib8000_set_subchannel_prbs(state, dib8000_get_init_prbs(state, state->subchannel));
+		init_prbs = dib8000_get_init_prbs(state, state->subchannel);
+
+		if (init_prbs) {
+			dib8000_set_subchannel_prbs(state, init_prbs);
 			*tune_state = CT_DEMOD_STEP_9;
 		} else {
 			*tune_state = CT_DEMOD_STOP;
-- 
2.30.2

