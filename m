Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A150B19D68E
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403880AbgDCMSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51790 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403845AbgDCMSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id z7so6912012wmk.1
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gmGOQvsAVrNac3r2fPvk9ny0MoHOFf1e/7ikoc940pY=;
        b=q5zzmQZmYNVxN3rMn0HTRHRn1v5Z9FaiPDzsTI/l6zh4eRvDU+6QpQbLVpUjLrICzU
         noJ6LMjiicEXjcmHxZDTkogCo+BIzZQcgsltUDfLRnPMy9blUNZyl7sHVA5soKnDxWsM
         05dKqYOHYPqnWRhjvSp4fC3ZYTE0PXt4DXq2H4Ml2Xo2Gdre7jpuMcmUypF1K5m0lJPg
         IYBW//JwhAGtzkh7XJH3mTE5p5r9KrZr/PctkQQjqMtcIKkL43nxu6zSN8ZL/eVwTvJl
         PoENFFaVddRB1drWhdfH3YPS1y1XGjYLcxlGkq1SGCaq3aUboCEHf6hKhpzTjW9RnLAr
         IQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gmGOQvsAVrNac3r2fPvk9ny0MoHOFf1e/7ikoc940pY=;
        b=e1EhoJoaBBr1X00qMZvyiEGRQ+QnOCB1RVoUAPDnDpuTEOMSMnge5zOPyidNVDuWPP
         eDfLhHXml2ajbUZKM0uQvQnrX0nxkxILvU91owwNzWGPEX8xiwnUTsBX0q43h5rDqmcs
         TpSEg1hGek/AIdgArpCOzs/SnYyX3iYSDww9ITyMHck3n+n6WsGAKlU0oxDUfRo55lA3
         q3S55pNOegy/CR9CgvANOvtz3yfWPBHWiTcMQdi+ZrdTQODUc5TwgNeJt3LlL02kZ18j
         RDyhp8KRYY0rw4+bDSTB0ksJudM5jqrG6NpycK6FVL6JpmOMnCgRw5e7dP3RchrdAwUc
         +o9Q==
X-Gm-Message-State: AGi0PuZtJIn9K1ePQb3Wmo1ZOemF7Q9fMAHGPxGDt9WfNBL7BQ/uIBq6
        ZAiqxlpR2NnigSgzI30xaNGk1ULwH5w=
X-Google-Smtp-Source: APiQypL+icp4aFpYpcsJKAjD59wo59K3ToWKassj4zTebVKlvybCoTHT7bwtpVPgW7lpb1eLEBIJAg==
X-Received: by 2002:a7b:c051:: with SMTP id u17mr8061971wmc.129.1585916309161;
        Fri, 03 Apr 2020 05:18:29 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:28 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Lyude Paul <lyude@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 04/13] drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_read()
Date:   Fri,  3 Apr 2020 13:18:50 +0100
Message-Id: <20200403121859.901838-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
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
index bf4eed5f6a7ee..a7c7f522fe1c4 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -439,6 +439,7 @@ static bool drm_dp_sideband_parse_remote_dpcd_read(struct drm_dp_sideband_msg_rx
 	if (idx > raw->curlen)
 		goto fail_len;
 	repmsg->u.remote_dpcd_read_ack.num_bytes = raw->msg[idx];
+	idx++;
 	if (idx > raw->curlen)
 		goto fail_len;
 
-- 
2.25.1

