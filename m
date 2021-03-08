Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7080330BC3
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 11:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhCHKwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 05:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbhCHKw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 05:52:29 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827C4C06175F
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 02:52:28 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id l12so14012986edt.3
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 02:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ed2ZmyjgMuArkep/x+pkAPo7evPjB1BAFOc6v5tfSJ4=;
        b=i5DDN26Aj7bY9aXwfNceG+NhoTZBh+NU6hUF/EKYDC6mCxMGzFyBmTzQESYeydRhCA
         uSppQ2DS3VpD/t8ejN/f5KIMxoOycbCeLS7IaBOgNqXDUgugs+voyYawCtnzH67M/ljq
         gTXTmn3PPxpyM59Z2m+JcIR1DnUMZHx18wo2nCpUbnSkTytm9ZiSTbUb911czkyVzO67
         DANktJwG/D6nddWMppt8f8xEVQUNV/sUlvpDceE5Mp8koEzSsUU5hbke/Ic3bJWOGSl2
         TjanvsUTbskjUfVkwh7k/Si2eOOI7kZWsy7e16I/bOwNHsb5mKhdiKVsUi2FYTpI2v4i
         mLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ed2ZmyjgMuArkep/x+pkAPo7evPjB1BAFOc6v5tfSJ4=;
        b=MjWdCrQJeSKvE/teVHTVit4eQR6LUs8hOG1/Z6HW/b/RB22Ki3RB/qUYSilwqkyPIj
         WcaHMTbjnRB9vo33STUqzNs4BmVjL1OM0IAdt1ibrpHclgty/i6nBiUAomhjK5EZqmY2
         LbHKCEDv/PAPgaUPF0j1V7GYwLmlGpMk0PQe8ko7lWq55Ddf09Iwa4RJC76ZILRara33
         /M4bVdFbMowcd6Me/mFeD0CESbDstuxcKUvNBlN9fOR5OyYKngbSttLaSY+vx3NBKNQi
         7u4bIUj1AyxFUEPrBwHvESKLzyj/FkvZBZeM/XFFaCE55ZTmBrQllqe2BroVIu1ElN7o
         oOwg==
X-Gm-Message-State: AOAM532Th/ZmbvCyuUl7PY9jAdVA0YT9wa5lxleSBfDGvit8n/mrzCdy
        nUu2e7NA26H9h3CVn1KhCPzODg==
X-Google-Smtp-Source: ABdhPJyA2a7BfNZBhViBq6dW6JSDMhqhNtugGFPTO4MeabFG/qITeFF3eCs6Tg/FY40GGWPkVRMnow==
X-Received: by 2002:a05:6402:254f:: with SMTP id l15mr2366106edb.189.1615200747272;
        Mon, 08 Mar 2021 02:52:27 -0800 (PST)
Received: from localhost.localdomain (95-43-196-84.ip.btc-net.bg. [95.43.196.84])
        by smtp.gmail.com with ESMTPSA id y9sm6386297ejd.110.2021.03.08.02.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 02:52:27 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     bryan.odonoghue@linaro.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 5/5] venus: hfi_cmds: Support plane-actual-info property from v1
Date:   Mon,  8 Mar 2021 12:52:05 +0200
Message-Id: <20210308105205.445148-6-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210308105205.445148-1-stanimir.varbanov@linaro.org>
References: <20210308105205.445148-1-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The property is supported from v1 and upwards. So move it to
set_property_1x.

Fixes: 01e869e78756 ("media: venus: venc: fix handlig of S_SELECTION and G_SELECTION")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_cmds.c | 24 ++++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

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
-- 
2.25.1

