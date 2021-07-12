Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8523C52AF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244760AbhGLHsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346751AbhGLHql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8673361185;
        Mon, 12 Jul 2021 07:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075729;
        bh=b47Ymz7+wtiB7mG7435MjsQbsvspRxQd1UZI8u6CO10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbFv3j2mG3B/dbKClpGKf56FHUdj5nevKhaX9vvhj8kYAkOp9gzoIkJ8ne4zon2wZ
         GLfcIUPoCNRYuIprZA/x0lKwju0W2YQFzNxp/EP+4bXeEf3bPT6fmaxy1gdhvjF249
         TdOruRyiKcDT0JLp+qmMDCP1vSwgcjs8deD7O994=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 297/800] media: venus: hfi_cmds: Fix conceal color property
Date:   Mon, 12 Jul 2021 08:05:20 +0200
Message-Id: <20210712060956.759076957@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

[ Upstream commit 6e2202ca1ee034920b029124151754aec67b61ba ]

The conceal color property used for Venus v4 and v6 has the same
payload structure. But currently v4 follow down to payload
structure for v1. Correct this by moving set_property to v4.

Fixes: 4ef6039fad8f ("media: venus: vdec: Add support for conceal control")
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/hfi_cmds.c | 22 ++++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c b/drivers/media/platform/qcom/venus/hfi_cmds.c
index 11a8347e5f5c..4b9dea7f6940 100644
--- a/drivers/media/platform/qcom/venus/hfi_cmds.c
+++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
@@ -1226,6 +1226,17 @@ pkt_session_set_property_4xx(struct hfi_session_set_property_pkt *pkt,
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*hdr10);
 		break;
 	}
+	case HFI_PROPERTY_PARAM_VDEC_CONCEAL_COLOR: {
+		struct hfi_conceal_color_v4 *color = prop_data;
+		u32 *in = pdata;
+
+		color->conceal_color_8bit = *in & 0xff;
+		color->conceal_color_8bit |= ((*in >> 10) & 0xff) << 8;
+		color->conceal_color_8bit |= ((*in >> 20) & 0xff) << 16;
+		color->conceal_color_10bit = *in;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*color);
+		break;
+	}
 
 	case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE:
 	case HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER:
@@ -1279,17 +1290,6 @@ pkt_session_set_property_6xx(struct hfi_session_set_property_pkt *pkt,
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*cq);
 		break;
 	}
-	case HFI_PROPERTY_PARAM_VDEC_CONCEAL_COLOR: {
-		struct hfi_conceal_color_v4 *color = prop_data;
-		u32 *in = pdata;
-
-		color->conceal_color_8bit = *in & 0xff;
-		color->conceal_color_8bit |= ((*in >> 10) & 0xff) << 8;
-		color->conceal_color_8bit |= ((*in >> 20) & 0xff) << 16;
-		color->conceal_color_10bit = *in;
-		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*color);
-		break;
-	}
 	default:
 		return pkt_session_set_property_4xx(pkt, cookie, ptype, pdata);
 	}
-- 
2.30.2



