Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D21424EF5A
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 21:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgHWTJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 15:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgHWTJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 15:09:30 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B14C061573;
        Sun, 23 Aug 2020 12:09:30 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y8so841024wma.0;
        Sun, 23 Aug 2020 12:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wQ+CnNuzNhRBq+zv3kVwnG0+uKFYAUvodng53ugnSig=;
        b=nPSPj5TthHlE1mdhBzN6g1SzM+oRRF26ni2J2rkJQMZ6QzTYEhvGMmGWUD1MxBRV6Y
         dlyNq6ZCRCLGJUUy8qulogWP7BzPRLleiAqk5VX536rSz7BXeiSrJclnAaQSiokBRJuX
         NMRU1CemThazOyZdpzyMR2VtktIyR6fQNtDLQkzG2c1+d1gPY508Rnc10Eok1HiLhd/e
         8ENkMYsldu89AvtyVCn3xGeHVQdYZOng5BvO/mDpyRSR1AQri8PT0jyILfWD0fJ4DNm+
         m4nyu5JdrLjFEGt6d7oL6qSE4uejuQ7hdRzO7lw74C0m4ySI+P98P0WfFwcRDZE1ZZMH
         uShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wQ+CnNuzNhRBq+zv3kVwnG0+uKFYAUvodng53ugnSig=;
        b=q9Ox5oKR4rZaXhCiUboMcLZeRorSvKD2Jg9pvyaWrFEqjnylttvyRLfk3UVCVmzZuD
         /QCCPyu4cdCEheqWL9b0l0o9x9Gc4YcCTZb4M3j8W9bgtQOezhTpJ3fs9y2hh+LqYH9d
         Yhv8+nh+4orGMH//m1/i02mwJWRNm48UMiwtSx6zREX/POI/SHUwGYMngsF+vk68AGVC
         gyEOBjolpMKF3Nu4sSFSj3Q32ZH3AntsPT2S671XdK6xELKdbdSngBY2X2HhTl2GITOD
         /JE4QZM+Zgrq/XdtZWjBtZJaOhuY/krOFRp8ByDslR1oCJY9vMk6O4TpzuYQAvpMCpng
         NJgA==
X-Gm-Message-State: AOAM532bFgbLva56uxE5F4aNF9mdKUGxBMFhXzWqEmO4i6w/bcEZOho8
        bxUdihHRPN0hfdSz8rOEIXtsSrFRhLCfdNch
X-Google-Smtp-Source: ABdhPJyMY0WTUtxfY5wI/V78Ldqxp3MbuqiBh5rA0eDmJ7njyqdnN7HZh47DPCP/z7RSpVjuRPEeMw==
X-Received: by 2002:a1c:544f:: with SMTP id p15mr2464254wmi.147.1598209768349;
        Sun, 23 Aug 2020 12:09:28 -0700 (PDT)
Received: from localhost.localdomain (62-178-82-229.cable.dynamic.surfer.at. [62.178.82.229])
        by smtp.gmail.com with ESMTPSA id z66sm19704128wme.16.2020.08.23.12.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 12:09:27 -0700 (PDT)
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     josua.mayer@jm0.eu,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH v2] drm/etnaviv: fix external abort seen on GC600 rev 0x19
Date:   Sun, 23 Aug 2020 21:09:22 +0200
Message-Id: <20200823190924.6437-1-christian.gmeiner@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It looks like that this GPU core triggers an abort when
reading VIVS_HI_CHIP_PRODUCT_ID and/or VIVS_HI_CHIP_ECO_ID.

I looked at different versions of Vivante's kernel driver and did
not found anything about this issue or what feature flag can be
used. So go the simplest route and do not read these two registers
on the affected GPU core.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Reported-by: Josua Mayer <josua.mayer@jm0.eu>
Fixes: 815e45bbd4d3 ("drm/etnaviv: determine product, customer and eco id")
Cc: stable@vger.kernel.org
---
Changelog:

V2:
 - use correct register for conditional reads.

---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index d5a4cd85a0f6..c6404b8d067f 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -337,9 +337,16 @@ static void etnaviv_hw_identify(struct etnaviv_gpu *gpu)
 
 		gpu->identity.model = gpu_read(gpu, VIVS_HI_CHIP_MODEL);
 		gpu->identity.revision = gpu_read(gpu, VIVS_HI_CHIP_REV);
-		gpu->identity.product_id = gpu_read(gpu, VIVS_HI_CHIP_PRODUCT_ID);
 		gpu->identity.customer_id = gpu_read(gpu, VIVS_HI_CHIP_CUSTOMER_ID);
-		gpu->identity.eco_id = gpu_read(gpu, VIVS_HI_CHIP_ECO_ID);
+
+		/*
+		 * Reading these two registers on GC600 rev 0x19 result in a
+		 * unhandled fault: external abort on non-linefetch
+		 */
+		if (!etnaviv_is_model_rev(gpu, GC600, 0x19)) {
+			gpu->identity.product_id = gpu_read(gpu, VIVS_HI_CHIP_PRODUCT_ID);
+			gpu->identity.eco_id = gpu_read(gpu, VIVS_HI_CHIP_ECO_ID);
+		}
 
 		/*
 		 * !!!! HACK ALERT !!!!
-- 
2.26.2

