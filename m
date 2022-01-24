Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBFF498F86
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352648AbiAXTxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:53:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37800 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354097AbiAXTsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:48:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29C77B8119D;
        Mon, 24 Jan 2022 19:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D17BC340E5;
        Mon, 24 Jan 2022 19:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053676;
        bh=/vz12Y+4kCw+FJnjP4uwJIwY0vpUaKSJwMXMfs4kA/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vltYa7x/HUPJXlOU193E8ZIP4kZCHA22a0S1cEFz7lGZMtMC+VR1kNG4p8bywlD6n
         sS0u6UBd+9+UkHRbM+7qBHPD6PW80aWQwz5A0lu146lq0iPX8gaNZFnVbj20i7W25H
         XTDroPvtWpOfKbktzcIeaviddlzmfQPYM9jQEOok=
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
Subject: [PATCH 5.10 108/563] media: rcar-csi2: Correct the selection of hsfreqrange
Date:   Mon, 24 Jan 2022 19:37:53 +0100
Message-Id: <20220124184028.138439005@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index d2d87a204e918..6fb8efcb40444 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -436,16 +436,23 @@ static int rcsi2_wait_phy_start(struct rcar_csi2 *priv,
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



