Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5761A628BFF
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbiKNWUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237045AbiKNWTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:19:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09881DF05
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 14:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668464329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O/M4W3uv7gwCZ1OdzG4UeM3eO9Q4aCQx77adsACSB0c=;
        b=ZDFg/djIS2tejN5R3TXOazD2BPfaxj3hvkzFI2Q9Iqvwfb1KD9A2FvWRamEmq1lXJ2KP5D
        Wo29YCOugj+dLi5jwh2amToL+efwnuiVpmJg8twLZ3EWgpMk6O9vCs/3CP6npV1OSbEgOB
        ejGqe3IAwPbSg+qA7h0qPsKhwwBBcF0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-xk6AjHqqOZyE6qJvTWmfFg-1; Mon, 14 Nov 2022 17:18:44 -0500
X-MC-Unique: xk6AjHqqOZyE6qJvTWmfFg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07A692A59559;
        Mon, 14 Nov 2022 22:18:43 +0000 (UTC)
Received: from emerald.lyude.net (unknown [10.22.18.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4761E4022C3;
        Mon, 14 Nov 2022 22:18:42 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        hersen wu <hersenxs.wu@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        David Francis <David.Francis@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 4/4] drm/amdgpu/dm/dp_mst: Don't grab mst_mgr->lock when computing DSC state
Date:   Mon, 14 Nov 2022 17:17:55 -0500
Message-Id: <20221114221754.385090-5-lyude@redhat.com>
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

Now that we've fixed the issue with using the incorrect topology manager,
we're actually grabbing the topology manager's lock - and consequently
deadlocking. Luckily for us though, there's actually nothing in AMD's DSC
state computation code that really should need this lock. The one exception
is the mutex_lock() in dm_dp_mst_is_port_support_mode(), however we grab no
locks beneath &mgr->lock there so that should be fine to leave be.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Gitlab issue: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Fixes: 8c20a1ed9b4f ("drm/amd/display: MST DSC compute fair share")
Cc: <stable@vger.kernel.org> # v5.6+
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 5196c9a0e432d..59648f5ffb59d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1148,10 +1148,8 @@ int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 			continue;
 
 		mst_mgr = aconnector->port->mgr;
-		mutex_lock(&mst_mgr->lock);
 		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars, mst_mgr,
 						       &link_vars_start_index);
-		mutex_unlock(&mst_mgr->lock);
 		if (ret != 0)
 			return ret;
 
@@ -1208,10 +1206,8 @@ static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 			continue;
 
 		mst_mgr = aconnector->port->mgr;
-		mutex_lock(&mst_mgr->lock);
 		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars, mst_mgr,
 						       &link_vars_start_index);
-		mutex_unlock(&mst_mgr->lock);
 		if (ret != 0)
 			return ret;
 
-- 
2.37.3

