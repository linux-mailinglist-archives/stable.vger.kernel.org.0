Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6282B4996F2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446410AbiAXVII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:08:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50862 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445095AbiAXVCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:02:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8146611DA;
        Mon, 24 Jan 2022 21:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB269C340E5;
        Mon, 24 Jan 2022 21:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058130;
        bh=IhACb9bxfxsVvsSEtnGRQo29vIfTysy249Res4IG6L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDlZgF8Z+G/ucHLdsJ58kTvecV5Ja775GozrP2TI+xgBXcejbd0QqL+S+bOo78A2r
         peiMDBtt71Gv10ujEiXdgWBdJorfoderRbt95AkzLolQzKgeuxzU/t+JsWdCNU764p
         gZPERttGdkX8d32X4mx30yqV1xr2O2O9o2zXmQEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suresh Udipi <sudipi@jp.adit-jv.com>,
        Kazuyoshi Akiyama <akiyama@nds-osk.co.jp>,
        Michael Rodin <mrodin@de.adit-jv.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0188/1039] media: rcar-csi2: Correct the selection of hsfreqrange
Date:   Mon, 24 Jan 2022 19:32:57 +0100
Message-Id: <20220124184131.625904622@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suresh Udipi <sudipi@jp.adit-jv.com>

[ Upstream commit cee44d4fbacbbdfe62697ec94e76c6e4f726c5df ]

hsfreqrange should be chosen based on the calculated mbps which
is closer to the default bit rate  and within the range as per
table[1]. But current calculation always selects first value which
is greater than or equal to the calculated mbps which may lead
to chosing a wrong range in some cases.

For example for 360 mbps for H3/M3N
Existing logic selects
Calculated value 360Mbps : Default 400Mbps Range [368.125 -433.125 mbps]

This hsfreqrange is out of range.

The logic is changed to get the default value which is closest to the
calculated value [1]

Calculated value 360Mbps : Default 350Mbps  Range [320.625 -380.625 mpbs]

[1] specs r19uh0105ej0200-r-car-3rd-generation.pdf [Table 25.9]

Please note that According to Renesas in Table 25.9 the range for
220 default value is corrected as below

 |Range (Mbps)     |  Default  Bit rate (Mbps) |
 -----------------------------------------------
 | 197.125-244.125 |     220                   |
 -----------------------------------------------

Fixes: 769afd212b16 ("media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver")
Signed-off-by: Suresh Udipi <sudipi@jp.adit-jv.com>
Signed-off-by: Kazuyoshi Akiyama <akiyama@nds-osk.co.jp>
Signed-off-by: Michael Rodin <mrodin@de.adit-jv.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 11848d0c4a55c..436b7be969202 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -542,16 +542,23 @@ static int rcsi2_wait_phy_start(struct rcar_csi2 *priv,
 static int rcsi2_set_phypll(struct rcar_csi2 *priv, unsigned int mbps)
 {
 	const struct rcsi2_mbps_reg *hsfreq;
+	const struct rcsi2_mbps_reg *hsfreq_prev = NULL;
 
-	for (hsfreq = priv->info->hsfreqrange; hsfreq->mbps != 0; hsfreq++)
+	for (hsfreq = priv->info->hsfreqrange; hsfreq->mbps != 0; hsfreq++) {
 		if (hsfreq->mbps >= mbps)
 			break;
+		hsfreq_prev = hsfreq;
+	}
 
 	if (!hsfreq->mbps) {
 		dev_err(priv->dev, "Unsupported PHY speed (%u Mbps)", mbps);
 		return -ERANGE;
 	}
 
+	if (hsfreq_prev &&
+	    ((mbps - hsfreq_prev->mbps) <= (hsfreq->mbps - mbps)))
+		hsfreq = hsfreq_prev;
+
 	rcsi2_write(priv, PHYPLL_REG, PHYPLL_HSFREQRANGE(hsfreq->reg));
 
 	return 0;
-- 
2.34.1



