Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEDF119C9D4
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389469AbgDBTSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44794 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389416AbgDBTSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:10 -0400
Received: by mail-wr1-f65.google.com with SMTP id m17so5557068wrw.11
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LhjhO29qP4YDiHKKomduT/iM9G93of5peeh/dmZcMag=;
        b=w2/SBTPHp43mehiBQoSIc+6yhdCCluyoWJ6Ilenpfv90fnn/TEC0Z/jJwYxshRk7gK
         NsVHOE4vzBKHz1BpS8ZROlOdTZoJIDuK+0roUCjOPdBCvwcCDf62zW6wGzeEIyikci8B
         vAYPprdCHmwnPmr3nRfPcWZod8jlz0cD+Oxb8xvYojmhmisjh/yBqInRPEGMp5TxlGPm
         L2wQyEmsU8pxulkdzuT1IWNvrVvELPnPgmUsnOr/0UuQ0o4OSAUVCShfD3OMl+v2CrJ9
         1uU/UrtUcVnB5ivmuZWFnYUInz7leVQzQIumrIU+jYU2CwtDjfdRsANdsjmk1FNvKQt3
         X/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LhjhO29qP4YDiHKKomduT/iM9G93of5peeh/dmZcMag=;
        b=dxNegmziEFd/7imX9UiEPl2PGEY6YMic3D6i3U/0wu5OuQGpD2KsH+m9aL5JBm9Esc
         +BXmkhlb2JaLzqoNz+d16dE20rQrI57ufHK7/vx970EwHxy+a/6oA2LBiwpq1wNCWG/u
         FxYaOAmKf5Dpo99zks48S1BqyIAlVTyOwyzAQAGN86Go765CiAnureSJX7ng36iaJl+R
         7MFzDBToxA/SdBF4bJGAWxdNlZ+izwVOpEy2FDsR9DWg/2Eo5g22ygFqjHeYB/EfMkjr
         Jd+dXQyLg1YlyVrIdeOMfU+n6NZvwbQuCxmSQBYB448kggI9FpQ84bO8fipgsS8fBRQi
         Xewg==
X-Gm-Message-State: AGi0PuZ2RK94XIadw7OiZHZO5BRfYIzKHkpPuqSL1/2bka71wiaHj511
        xGTedVvZAfYstad6XoNzmwn760S1V857MA==
X-Google-Smtp-Source: APiQypLpWIv9GJ5WDhSvEAAK8I4NBSQl37AsgIIpkd4KJY9O1DgsODNihCu8bfhdawWJMl8mTff7FA==
X-Received: by 2002:adf:f5c8:: with SMTP id k8mr4593899wrp.33.1585855087067;
        Thu, 02 Apr 2020 12:18:07 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 05/20] drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_read()
Date:   Thu,  2 Apr 2020 20:18:41 +0100
Message-Id: <20200402191856.789622-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

[ Upstream commit a4c30a4861c54af78c4eb8b7855524c1a96d9f80 ]

When parsing the reply of a DP_REMOTE_DPCD_READ DPCD command the
result is wrong due to a missing idx increment.

This was never noticed since DP_REMOTE_DPCD_READ is currently not
used, but if you enable it, then it is all wrong.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/e72ddac2-1dc0-100a-d816-9ac98ac009dd@xs4all.nl
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 4d0f77f0edad1..6f6a6325b4691 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -431,6 +431,7 @@ static bool drm_dp_sideband_parse_remote_dpcd_read(struct drm_dp_sideband_msg_rx
 	if (idx > raw->curlen)
 		goto fail_len;
 	repmsg->u.remote_dpcd_read_ack.num_bytes = raw->msg[idx];
+	idx++;
 	if (idx > raw->curlen)
 		goto fail_len;
 
-- 
2.25.1

