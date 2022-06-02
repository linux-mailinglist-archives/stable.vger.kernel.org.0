Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A7A53BF88
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 22:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbiFBUS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 16:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235748AbiFBUSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 16:18:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00564F15
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 13:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654201101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l4iW0euo2hpUkJUtHiLJMCOQOvdkFw2OylvP6PRtFgU=;
        b=KgXH2nYtV1drzbONfbLKYQmjvd4aHI5lEYjCOaCnrGGzrq/gay0Hw2tw7en9xn9cKUeava
        1/T3NZiwcVTvNWvCIp9w0Cz0srW4buZ4nogwTmpw3ke1c6hTOR0KOhfb688Ns8dPckW55t
        SsE30m2H7nWj4L1L8ssKdspZbSnfz10=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-nJSe9AyMNWyvtZ7uq8_tKA-1; Thu, 02 Jun 2022 16:18:19 -0400
X-MC-Unique: nJSe9AyMNWyvtZ7uq8_tKA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DE02955B00;
        Thu,  2 Jun 2022 20:18:18 +0000 (UTC)
Received: from emerald.redhat.com (unknown [10.22.34.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2E59414A7E7;
        Thu,  2 Jun 2022 20:18:17 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Imran Khan <imran.f.khan@oracle.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/3] drm/display/dp_mst: Fix drm_atomic_get_mst_topology_state()
Date:   Thu,  2 Jun 2022 16:17:56 -0400
Message-Id: <20220602201757.30431-3-lyude@redhat.com>
In-Reply-To: <20220602201757.30431-1-lyude@redhat.com>
References: <20220602201757.30431-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I noticed a rather surprising issue here while working on removing all of
the non-atomic MST code: drm_atomic_get_mst_topology_state() doesn't check
the return value of drm_atomic_get_private_obj_state() and instead just
passes it directly to to_dp_mst_topology_state(). This means that if we
hit a deadlock or something else which would return an error code pointer,
we'll likely segfault the kernel.

This is definitely another one of those fixes where I'm astonished we
somehow managed never to discover this issue until now…

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: a4370c777406 ("drm/atomic: Make private objs proper objects")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v4.14+
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 2 +-
 include/drm/display/drm_dp_mst_helper.h       | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index d84673b3294b..d6e595b95f07 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -5468,7 +5468,7 @@ EXPORT_SYMBOL(drm_dp_mst_topology_state_funcs);
 struct drm_dp_mst_topology_state *drm_atomic_get_mst_topology_state(struct drm_atomic_state *state,
 								    struct drm_dp_mst_topology_mgr *mgr)
 {
-	return to_dp_mst_topology_state(drm_atomic_get_private_obj_state(state, &mgr->base));
+	return to_dp_mst_topology_state_safe(drm_atomic_get_private_obj_state(state, &mgr->base));
 }
 EXPORT_SYMBOL(drm_atomic_get_mst_topology_state);
 
diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/display/drm_dp_mst_helper.h
index 10adec068b7f..fe7577e7f305 100644
--- a/include/drm/display/drm_dp_mst_helper.h
+++ b/include/drm/display/drm_dp_mst_helper.h
@@ -541,6 +541,8 @@ struct drm_dp_payload {
 };
 
 #define to_dp_mst_topology_state(x) container_of(x, struct drm_dp_mst_topology_state, base)
+#define to_dp_mst_topology_state_safe(x) \
+	container_of_safe(x, struct drm_dp_mst_topology_state, base)
 
 struct drm_dp_vcpi_allocation {
 	struct drm_dp_mst_port *port;
-- 
2.35.3

