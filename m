Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602415354D2
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 22:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349034AbiEZUn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 16:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349055AbiEZUnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 16:43:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04A14E64E3
        for <stable@vger.kernel.org>; Thu, 26 May 2022 13:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653597803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=q4+bE63txPRwk8UBc1PGCAMG41oWjfd5z6Jt+rIqLHc=;
        b=CnyFWVtNjVUlHn7vZJ6Djm66Z5ipst89nXNRsyB64mX/tQk23Ionk8dtip4HizEHTI9m9a
        o2cj0zFjMMXx/hBlECaFcpLZRcNvsXJihbX2ubvpJesz4Egl0sMFUL2qHK/49N70q2G7dE
        7PyXq/ldLLjaCO3gRHa4kftnZ4HTt5M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-4-DpyXLeOzud8B87TaADQQ-1; Thu, 26 May 2022 16:43:19 -0400
X-MC-Unique: 4-DpyXLeOzud8B87TaADQQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C564101A54E;
        Thu, 26 May 2022 20:43:19 +0000 (UTC)
Received: from emerald.redhat.com (unknown [10.22.34.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E43D2C27E9D;
        Thu, 26 May 2022 20:43:18 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     kherbst@redhat.com, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVER FOR NVIDIA
        GEFORCE/QUADRO GPUS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm/nouveau/kms: Fix failure path for creating DP connectors
Date:   Thu, 26 May 2022 16:43:13 -0400
Message-Id: <20220526204313.656473-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It looks like that when we moved nouveau over to using drm_dp_aux_init()
and registering it's aux bus during late connector registration, we totally
forgot to fix the failure codepath in nouveau_connector_create() - as it
still seems to assume that drm_dp_aux_init() can fail (it can't).

So, let's fix that and also add a missing check to ensure that we've
properly allocated nv_connector->aux.name while we're at it.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: fd43ad9d47e7 ("drm/nouveau/kms/nv50-: Move AUX adapter reg to connector late register/early unregister")
Cc: <stable@vger.kernel.org> # v5.14+
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 22b83a6577eb..df83c4654e26 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1361,13 +1361,11 @@ nouveau_connector_create(struct drm_device *dev,
 		snprintf(aux_name, sizeof(aux_name), "sor-%04x-%04x",
 			 dcbe->hasht, dcbe->hashm);
 		nv_connector->aux.name = kstrdup(aux_name, GFP_KERNEL);
-		drm_dp_aux_init(&nv_connector->aux);
-		if (ret) {
-			NV_ERROR(drm, "Failed to init AUX adapter for sor-%04x-%04x: %d\n",
-				 dcbe->hasht, dcbe->hashm, ret);
+		if (!nv_connector->aux.name) {
 			kfree(nv_connector);
-			return ERR_PTR(ret);
+			return ERR_PTR(-ENOMEM);
 		}
+		drm_dp_aux_init(&nv_connector->aux);
 		fallthrough;
 	default:
 		funcs = &nouveau_connector_funcs;
-- 
2.35.3

