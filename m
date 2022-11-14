Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F98628BFD
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiKNWUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236897AbiKNWTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:19:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C70DF1C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 14:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668464329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T5iG8aiTSRDbls3qGdvQepXmN8J8nzm4Ph5iY3bMF3o=;
        b=UeE3l16TLbwIpnHvFq/AUAKkhtLsCPqnsZHybDL+AihFC1DrqnP8fUmk9C8xglcH1DQS9B
        3YBgQwOT1B69SzhvobvLavi5mTc3g13Y4cDAZj+jlJplpVS2nCz6gL2tjxODgaaTDF92i6
        7iBKNYkGyrJcwq6mchOFQrawVN834Sg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-IwuVXJEEOtidz6g12tO4eA-1; Mon, 14 Nov 2022 17:18:41 -0500
X-MC-Unique: IwuVXJEEOtidz6g12tO4eA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6BFA8027EB;
        Mon, 14 Nov 2022 22:18:39 +0000 (UTC)
Received: from emerald.lyude.net (unknown [10.22.18.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 680E849BB60;
        Mon, 14 Nov 2022 22:18:39 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Wayne Lin <Wayne.Lin@amd.com>, stable@vger.kernel.org,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Imre Deak <imre.deak@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/4] drm/display/dp_mst: Fix drm_dp_mst_add_affected_dsc_crtcs() return code
Date:   Mon, 14 Nov 2022 17:17:53 -0500
Message-Id: <20221114221754.385090-3-lyude@redhat.com>
In-Reply-To: <20221114221754.385090-1-lyude@redhat.com>
References: <20221114221754.385090-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks like that we're accidentally dropping a pretty important return code
here. For some reason, we just return -EINVAL if we fail to get the MST
topology state. This is wrong: error codes are important and should never
be squashed without being handled, which here seems to have the potential
to cause a deadlock.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Fixes: 8ec046716ca8 ("drm/dp_mst: Add helper to trigger modeset on affected DSC MST CRTCs")
Cc: <stable@vger.kernel.org> # v5.6+
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index ecd22c038c8c0..51a46689cda70 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -5186,7 +5186,7 @@ int drm_dp_mst_add_affected_dsc_crtcs(struct drm_atomic_state *state, struct drm
 	mst_state = drm_atomic_get_mst_topology_state(state, mgr);
 
 	if (IS_ERR(mst_state))
-		return -EINVAL;
+		return PTR_ERR(mst_state);
 
 	list_for_each_entry(pos, &mst_state->payloads, next) {
 
-- 
2.37.3

