Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62198A277E
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfH2UAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 16:00:07 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44181 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfH2UAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 16:00:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so2141027pgl.11
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 13:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S9d3dFoh7F6gGH5LTQyJ8UyxGo/MvVuvj+hyEE/NkTM=;
        b=CH3Z10dMKFNa5EUmXWfmO9kVZYBLmTzxs99xBrQZa34CnaWlLZ/e/TJGcWMmfgsVB6
         fbGWYVF61zStU3OZ3c4J09h572gEWcekJS9a9s1STntCydJRS4S+bJjKr1GFFPevhKjB
         uZXZuULcjvP9TNWnWZ5gUtJuhXkCpGo5Q1FylX1MGpXn4QIk5JEjXSX1Q1MWBWAsfSZh
         Y3XGxXaszNMDvWfih8zVS5X6l5P1jhp0JnKuzXXsLsas1cnOI0l6wWvsEjPjBR0TMyLp
         ZP5J3Hy4nDNsUH7UsCts6P9CduZTxfhth9z6VwRWe6YZX49SH0wun0MhB+e7V7D2e2kT
         LlUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S9d3dFoh7F6gGH5LTQyJ8UyxGo/MvVuvj+hyEE/NkTM=;
        b=FXWGDzbgR94GYLew4/+P4AH3d3+f9FbG9RmLeGWtYme1OStlGOt5148yAPErroeDQm
         oX/WiTOqL647I2UyCcg7iG5RkPKvdccKCR9y1D60b4TuaE14AWCyWG64f7DO40PJj+f+
         ofLy352oG3X9nbtXArT9MYltLECDfsEP+oPlg5gpPLIu8y35hNDAdHLG1O8z6jhmPCml
         8UGs8rcjL2Jdx1T7p7f6JhTNku2Y9W6bAr6AkR1EWO0GaTmj/Ql94KfATpTBsJoA7MRv
         1LbvSDgDf3LNWkB6cNlFblEaeRH1U+ebiqya7f3cq5p4oQau00WHJLC32/PHhyI98ljh
         topg==
X-Gm-Message-State: APjAAAXvx5YK7VdmTVyZGCGLrn3uzmY34zbTV7NmRLXBX6oD/udLH0Zh
        9/IgTTITO12sOLayjGxwT8t0i5yFxuA=
X-Google-Smtp-Source: APXvYqwgfpvBc6rpBf/WbtITtoaWYyjizOJiXzMZpQhfc76Y+pvPxSdoJdzus+CAnHFnfaEjre9aBw==
X-Received: by 2002:a63:5951:: with SMTP id j17mr9734953pgm.143.1567108805398;
        Thu, 29 Aug 2019 13:00:05 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id u7sm3053766pgr.94.2019.08.29.13.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 13:00:04 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie, jsarha@ti.com,
        tomi.valkeinen@ti.com, vinholikatti@gmail.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [BACKPORT 4.19.y 1/3] drm/bridge: tfp410: fix memleak in get_modes()
Date:   Thu, 29 Aug 2019 13:59:59 -0600
Message-Id: <20190829200001.17092-2-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829200001.17092-1-mathieu.poirier@linaro.org>
References: <20190829200001.17092-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit c08f99c39083ab55a9c93b3e93cef48711294dad upstream

We don't free the edid blob allocated by the call to drm_get_edid(),
causing a memleak. Fix this by calling kfree(edid) at the end of the
get_modes().

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190610135739.6077-1-tomi.valkeinen@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/gpu/drm/bridge/ti-tfp410.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-tfp410.c b/drivers/gpu/drm/bridge/ti-tfp410.c
index c3e32138c6bb..9dc109df0808 100644
--- a/drivers/gpu/drm/bridge/ti-tfp410.c
+++ b/drivers/gpu/drm/bridge/ti-tfp410.c
@@ -64,7 +64,12 @@ static int tfp410_get_modes(struct drm_connector *connector)
 
 	drm_connector_update_edid_property(connector, edid);
 
-	return drm_add_edid_modes(connector, edid);
+	ret = drm_add_edid_modes(connector, edid);
+
+	kfree(edid);
+
+	return ret;
+
 fallback:
 	/* No EDID, fallback on the XGA standard modes */
 	ret = drm_add_modes_noedid(connector, 1920, 1200);
-- 
2.17.1

