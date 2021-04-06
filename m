Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A31355457
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243437AbhDFM56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 08:57:58 -0400
Received: from www.linuxtv.org ([130.149.80.248]:54902 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239330AbhDFM55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 08:57:57 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lTlHA-00EYie-TS; Tue, 06 Apr 2021 12:57:48 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 06 Apr 2021 12:53:07 +0000
Subject: [git:media_tree/master] media: venus: hfi_cmds: Support plane-actual-info property from v1
To:     linuxtv-commits@linuxtv.org
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lTlHA-00EYie-TS@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: hfi_cmds: Support plane-actual-info property from v1
Author:  Stanimir Varbanov <stanimir.varbanov@linaro.org>
Date:    Sat Mar 6 13:16:41 2021 +0100

The property is supported from v1 and upwards. So move it to
set_property_1x.

Fixes: 01e869e78756 ("media: venus: venc: fix handlig of S_SELECTION and G_SELECTION")
Cc: stable@vger.kernel.org # v5.12
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/qcom/venus/hfi_cmds.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

---

diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c b/drivers/media/platform/qcom/venus/hfi_cmds.c
index 4f7565834469..558510a8dfc8 100644
--- a/drivers/media/platform/qcom/venus/hfi_cmds.c
+++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
@@ -1039,6 +1039,18 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*hierp);
 		break;
 	}
+	case HFI_PROPERTY_PARAM_UNCOMPRESSED_PLANE_ACTUAL_INFO: {
+		struct hfi_uncompressed_plane_actual_info *in = pdata;
+		struct hfi_uncompressed_plane_actual_info *info = prop_data;
+
+		info->buffer_type = in->buffer_type;
+		info->num_planes = in->num_planes;
+		info->plane_format[0] = in->plane_format[0];
+		if (in->num_planes > 1)
+			info->plane_format[1] = in->plane_format[1];
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*info);
+		break;
+	}
 
 	/* FOLLOWING PROPERTIES ARE NOT IMPLEMENTED IN CORE YET */
 	case HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS:
@@ -1205,18 +1217,6 @@ pkt_session_set_property_4xx(struct hfi_session_set_property_pkt *pkt,
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*cu);
 		break;
 	}
-	case HFI_PROPERTY_PARAM_UNCOMPRESSED_PLANE_ACTUAL_INFO: {
-		struct hfi_uncompressed_plane_actual_info *in = pdata;
-		struct hfi_uncompressed_plane_actual_info *info = prop_data;
-
-		info->buffer_type = in->buffer_type;
-		info->num_planes = in->num_planes;
-		info->plane_format[0] = in->plane_format[0];
-		if (in->num_planes > 1)
-			info->plane_format[1] = in->plane_format[1];
-		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*info);
-		break;
-	}
 	case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE:
 	case HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER:
 	case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE:
