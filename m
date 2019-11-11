Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36CCBF7E4F
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfKKSqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:46:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729977AbfKKSqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:46:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D129720659;
        Mon, 11 Nov 2019 18:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497974;
        bh=4e9pxfGDU6RapcaX+QCh8nJXlA3vULm4getxnp/+7Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mT1NK2d6mQqvqmJte7Pmwichh1Cyf4FgsXZIewnXHvi7nUsyrHMb9MOrh7sfCG1jp
         cuGsbu6mpvAlq1GZw1T4++gyjT9kPOS3Huf8QHq1oEbwgAn5YaCwpZNI8/x+X/tiDe
         N9hSe+KG/Crk1MCx1p1fT/0MHCpd0iGhR+VMg/F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Strauss <michael.strauss@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/125] drm/amd/display: Passive DP->HDMI dongle detection fix
Date:   Mon, 11 Nov 2019 19:29:10 +0100
Message-Id: <20191111181454.612373790@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit bc2fde42e2418808dbfc04de1a6da91d7d31cf1a ]

[WHY]
i2c_read is called to differentiate passive DP->HDMI and DP->DVI-D dongles
The call is expected to fail in DVI-D case but pass in HDMI case
Some HDMI dongles have a chance to fail as well, causing misdetection as DVI-D

[HOW]
Retry i2c_read to ensure failed result is valid

Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/core/dc_link_ddc.c | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c
index 8def0d9fa0ff0..46c9cb47a96e5 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c
@@ -433,6 +433,7 @@ void dal_ddc_service_i2c_query_dp_dual_mode_adaptor(
 	enum display_dongle_type *dongle = &sink_cap->dongle_type;
 	uint8_t type2_dongle_buf[DP_ADAPTOR_TYPE2_SIZE];
 	bool is_type2_dongle = false;
+	int retry_count = 2;
 	struct dp_hdmi_dongle_signature_data *dongle_signature;
 
 	/* Assume we have no valid DP passive dongle connected */
@@ -445,13 +446,24 @@ void dal_ddc_service_i2c_query_dp_dual_mode_adaptor(
 		DP_HDMI_DONGLE_ADDRESS,
 		type2_dongle_buf,
 		sizeof(type2_dongle_buf))) {
-		*dongle = DISPLAY_DONGLE_DP_DVI_DONGLE;
-		sink_cap->max_hdmi_pixel_clock = DP_ADAPTOR_DVI_MAX_TMDS_CLK;
+		/* Passive HDMI dongles can sometimes fail here without retrying*/
+		while (retry_count > 0) {
+			if (i2c_read(ddc,
+				DP_HDMI_DONGLE_ADDRESS,
+				type2_dongle_buf,
+				sizeof(type2_dongle_buf)))
+				break;
+			retry_count--;
+		}
+		if (retry_count == 0) {
+			*dongle = DISPLAY_DONGLE_DP_DVI_DONGLE;
+			sink_cap->max_hdmi_pixel_clock = DP_ADAPTOR_DVI_MAX_TMDS_CLK;
 
-		CONN_DATA_DETECT(ddc->link, type2_dongle_buf, sizeof(type2_dongle_buf),
-				"DP-DVI passive dongle %dMhz: ",
-				DP_ADAPTOR_DVI_MAX_TMDS_CLK / 1000);
-		return;
+			CONN_DATA_DETECT(ddc->link, type2_dongle_buf, sizeof(type2_dongle_buf),
+					"DP-DVI passive dongle %dMhz: ",
+					DP_ADAPTOR_DVI_MAX_TMDS_CLK / 1000);
+			return;
+		}
 	}
 
 	/* Check if Type 2 dongle.*/
-- 
2.20.1



