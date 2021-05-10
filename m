Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7A6378980
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbhEJLZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237949AbhEJLQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A315561352;
        Mon, 10 May 2021 11:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645108;
        bh=aK8xdx49Lz2xeZhUZMs4SCAmyEOmZj+EX3+HZwbSzKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tadUuC4wlyGGLSiLeVRd3kzzxNyo6KLtU9uiAUGz3j7QSo6Mtd4STwADH1Fs/z8NC
         lVWYZI+tYK05daFINLwejEl5CMcmZn8+g8AuZO3brdnlUWiLGwcC52zPVvggr0lcPm
         i/ydK/zmUgGCpP0HWMDxCAlebrutIHIYWnwn+Oy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.12 356/384] media: venus: hfi_cmds: Support plane-actual-info property from v1
Date:   Mon, 10 May 2021 12:22:25 +0200
Message-Id: <20210510102026.495641862@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

commit 15447d18b1b877d9c6f979bd00088e470a4e0e9f upstream.

The property is supported from v1 and upwards. So move it to
set_property_1x.

Fixes: 01e869e78756 ("media: venus: venc: fix handlig of S_SELECTION and G_SELECTION")
Cc: stable@vger.kernel.org # v5.12
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_cmds.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/media/platform/qcom/venus/hfi_cmds.c
+++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
@@ -1039,6 +1039,18 @@ static int pkt_session_set_property_1x(s
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
@@ -1205,18 +1217,6 @@ pkt_session_set_property_4xx(struct hfi_
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


