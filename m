Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4885D499361
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385485AbiAXUd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:33:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60264 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381828AbiAXUYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:24:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AB47B81229;
        Mon, 24 Jan 2022 20:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4ACAC340E5;
        Mon, 24 Jan 2022 20:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055883;
        bh=O3rKWbRYROdrjBDmKSVUoul83ssFRlJvdg9Jkqbc8ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjNOAg/TzQf7+TDkOvTZKQ2HnriKNGQzfSlgg7JDlcZ1JKcr0tjauq/AZQuEpvOvW
         aKnmIF/slZt/dJTfTUDpZTFSbPKCNpLVv1YlmuvvnPDwvm474g3eLRDjtsK+6/Tvb2
         xx8yScm8Dp3+gS3MCnmR1/KBrwFZ/pDuLS3opfYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 290/846] backlight: qcom-wled: Use cpu_to_le16 macro to perform conversion
Date:   Mon, 24 Jan 2022 19:36:47 +0100
Message-Id: <20220124184110.936266340@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 0a139358548968b2ff308257b4fbeec7badcc3e1 ]

The kernel already provides appropriate primitives to perform endianness
conversion which should be used in favour of manual bit-wrangling.

Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211115203459.1634079-4-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index c057368e5056e..5306b06044b4f 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -231,14 +231,14 @@ struct wled {
 static int wled3_set_brightness(struct wled *wled, u16 brightness)
 {
 	int rc, i;
-	u8 v[2];
+	__le16 v;
 
-	v[0] = brightness & 0xff;
-	v[1] = (brightness >> 8) & 0xf;
+	v = cpu_to_le16(brightness & WLED3_SINK_REG_BRIGHT_MAX);
 
 	for (i = 0;  i < wled->cfg.num_strings; ++i) {
 		rc = regmap_bulk_write(wled->regmap, wled->ctrl_addr +
-				       WLED3_SINK_REG_BRIGHT(i), v, 2);
+				       WLED3_SINK_REG_BRIGHT(i),
+				       &v, sizeof(v));
 		if (rc < 0)
 			return rc;
 	}
@@ -250,18 +250,18 @@ static int wled4_set_brightness(struct wled *wled, u16 brightness)
 {
 	int rc, i;
 	u16 low_limit = wled->max_brightness * 4 / 1000;
-	u8 v[2];
+	__le16 v;
 
 	/* WLED4's lower limit of operation is 0.4% */
 	if (brightness > 0 && brightness < low_limit)
 		brightness = low_limit;
 
-	v[0] = brightness & 0xff;
-	v[1] = (brightness >> 8) & 0xf;
+	v = cpu_to_le16(brightness & WLED3_SINK_REG_BRIGHT_MAX);
 
 	for (i = 0;  i < wled->cfg.num_strings; ++i) {
 		rc = regmap_bulk_write(wled->regmap, wled->sink_addr +
-				       WLED4_SINK_REG_BRIGHT(i), v, 2);
+				       WLED4_SINK_REG_BRIGHT(i),
+				       &v, sizeof(v));
 		if (rc < 0)
 			return rc;
 	}
@@ -273,21 +273,20 @@ static int wled5_set_brightness(struct wled *wled, u16 brightness)
 {
 	int rc, offset;
 	u16 low_limit = wled->max_brightness * 1 / 1000;
-	u8 v[2];
+	__le16 v;
 
 	/* WLED5's lower limit is 0.1% */
 	if (brightness < low_limit)
 		brightness = low_limit;
 
-	v[0] = brightness & 0xff;
-	v[1] = (brightness >> 8) & 0x7f;
+	v = cpu_to_le16(brightness & WLED5_SINK_REG_BRIGHT_MAX_15B);
 
 	offset = (wled->cfg.mod_sel == MOD_A) ?
 		  WLED5_SINK_REG_MOD_A_BRIGHTNESS_LSB :
 		  WLED5_SINK_REG_MOD_B_BRIGHTNESS_LSB;
 
 	rc = regmap_bulk_write(wled->regmap, wled->sink_addr + offset,
-			       v, 2);
+			       &v, sizeof(v));
 	return rc;
 }
 
-- 
2.34.1



