Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A292124DF46
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 20:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgHUSRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 14:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgHUSRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 14:17:37 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08ACC061573;
        Fri, 21 Aug 2020 11:17:36 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so2690035wme.4;
        Fri, 21 Aug 2020 11:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e9mgWK2XGSNejzbIShlVyw9cGX/rfpxZBl6ecAIWVy4=;
        b=U1RMeYpO/R3D0KkHNbNBvdec2Ilv4X2DVT6cg7YWvJBJyr7LQEvHzb3ckqKq68DVFm
         RsRUGzqv/WxLZK3Ra8Ltsx0VpS9Nm2U4v36uz5Gdko+Ri25kYHv6U+um7ZdElR8K7Dw/
         HqzkCnPlQFRcCC7em/+xF+0lYKLncg4wtSXcbZGaf0FE8WPeaOt8vibrr629BbJmM61p
         qp7WtPK/yZNGKGnX1L1ZQioE7kTt0gsJkEepvSHdZdvSk0mvV1xNIoPESorbzRozFGbJ
         zX+7EPIlzni4Zo4T2cqRKpKyhby7lUTu0H6BRCyDJNUG4yxYqwlHdyDfKKFEQu+JnDUw
         Esjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e9mgWK2XGSNejzbIShlVyw9cGX/rfpxZBl6ecAIWVy4=;
        b=FDHa/djZHZggBv5Sabbt5yPS/n+y3PNHq3CQVnV2RQEXRsf2aJ8onFMCUtB15iF804
         Fsocqc4TvvMJefKDwyX+TDjsCKnyo294OhgI2nLE42foPvcF6CC88cTNesPbC1Czl4pI
         ZsdV75siEMKZ/gMmZcwaUY4XRAeHbNT1sn3AuKLu1dEdw3LJJkplTzH8auQpLNB86d/C
         ZGxzPDVlKIoowexfpjGflrUPwd6lMTzLU0idshYpA0VhZ3xkG7U6CfzuzzNmTIgkSgTS
         6d0G1Rih/vKgYdjSvQ6E7JDf9Eeo/vqPWFfC3uoSfXPxG7AfrkddxvlSFj5zrEzqqIrc
         Rqrg==
X-Gm-Message-State: AOAM5312hcp404QyiozW6oZJev94jmGboPCArK8aAfM8ZO+SH5tYltH0
        3ePFOjgtQtOKYQsMaAd5raiAp/l9zz3u2w==
X-Google-Smtp-Source: ABdhPJx02d4XOG7VYqgRyJ3CXMYtjC4XDFgkKLRpCBjewDqHRTpYWKRwPvdZEbGLgWlAXvNJ0sGNnQ==
X-Received: by 2002:a1c:a9ce:: with SMTP id s197mr4753684wme.45.1598033855273;
        Fri, 21 Aug 2020 11:17:35 -0700 (PDT)
Received: from localhost.localdomain ([62.178.82.229])
        by smtp.gmail.com with ESMTPSA id 69sm7859719wmb.8.2020.08.21.11.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 11:17:34 -0700 (PDT)
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     josua.mayer@jm0.eu,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/etnaviv: fix external abort seen on GC600 rev 0x19
Date:   Fri, 21 Aug 2020 20:17:27 +0200
Message-Id: <20200821181731.94852-1-christian.gmeiner@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It looks like that this GPU core triggers an abort when
reading VIVS_HI_CHIP_PRODUCT_ID and/or VIVS_HI_CHIP_CUSTOMER_ID.

I looked at different versions of Vivante's kernel driver and did
not found anything about this issue or what feature flag can be
used. So go the simplest route and do not read these two registers
on the affected GPU core.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Reported-by: Josua Mayer <josua.mayer@jm0.eu>
Fixes: 815e45bbd4d3 ("drm/etnaviv: determine product, customer and eco id")
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index d5a4cd85a0f6..d3906688c2b3 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -337,10 +337,17 @@ static void etnaviv_hw_identify(struct etnaviv_gpu *gpu)
 
 		gpu->identity.model = gpu_read(gpu, VIVS_HI_CHIP_MODEL);
 		gpu->identity.revision = gpu_read(gpu, VIVS_HI_CHIP_REV);
-		gpu->identity.product_id = gpu_read(gpu, VIVS_HI_CHIP_PRODUCT_ID);
-		gpu->identity.customer_id = gpu_read(gpu, VIVS_HI_CHIP_CUSTOMER_ID);
 		gpu->identity.eco_id = gpu_read(gpu, VIVS_HI_CHIP_ECO_ID);
 
+		/*
+		 * Reading these two registers on GC600 rev 0x19 result in a
+		 * unhandled fault: external abort on non-linefetch
+		 */
+		if (!etnaviv_is_model_rev(gpu, GC600, 0x19)) {
+			gpu->identity.product_id = gpu_read(gpu, VIVS_HI_CHIP_PRODUCT_ID);
+			gpu->identity.customer_id = gpu_read(gpu, VIVS_HI_CHIP_CUSTOMER_ID);
+		}
+
 		/*
 		 * !!!! HACK ALERT !!!!
 		 * Because people change device IDs without letting software
-- 
2.26.2

