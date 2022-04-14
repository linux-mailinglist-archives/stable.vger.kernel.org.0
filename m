Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55685011A4
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345428AbiDNNuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344456AbiDNNle (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:41:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA2C120;
        Thu, 14 Apr 2022 06:39:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3A30CE2997;
        Thu, 14 Apr 2022 13:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE23C385A1;
        Thu, 14 Apr 2022 13:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943546;
        bh=sCBusolubFHnM0j74VpBf6a9iULaG4IbkxyhN+25IB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUNJ+ZRuIyc4WRUQT+AOpJNuXAZDiuNs+FCDlTM4KH1qD4qI7v16i07qnDJKNvFsf
         XgBffum0fEIEV1alDI367EJa1GSkqu6JJ1zDgynt+ZPo3RzUNU7uzD1reKLW1C0Sz6
         YATqWoG6rsmA9twAYU77LcMrmBkGb1tnveLJH1HQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hersen Wu <hersenwu@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 177/475] drm/amd/display: Add affected crtcs to atomic state for dsc mst unplug
Date:   Thu, 14 Apr 2022 15:09:22 +0200
Message-Id: <20220414110900.087931158@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 128f8ed5902a287a6bb4afe0ffdae8a80b2a64ec ]

[Why]
When display topology changed on DSC hub we add all crtcs with dsc support to
atomic state.
Refer to patch:"drm/amd/display: Trigger modesets on MST DSC connectors"
However the original implementation may skip crtc if the topology change
caused by unplug.
That potentially could lead to no-lightup or corruption on DSC hub after
unplug event on one of the connectors.

[How]
Update add_affected_mst_dsc_crtcs() to use old connector state
if new connector state has no crtc (undergoes modeset due to unplug)

Fixes: 44be939ff7ac58 ("drm/amd/display: Trigger modesets on MST DSC connectors")

Reviewed-by: Hersen Wu <hersenwu@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 29f8b4bd5a76..c5231c50c412 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7268,10 +7268,13 @@ dm_determine_update_type_for_commit(struct amdgpu_display_manager *dm,
 static int add_affected_mst_dsc_crtcs(struct drm_atomic_state *state, struct drm_crtc *crtc)
 {
 	struct drm_connector *connector;
-	struct drm_connector_state *conn_state;
+	struct drm_connector_state *conn_state, *old_conn_state;
 	struct amdgpu_dm_connector *aconnector = NULL;
 	int i;
-	for_each_new_connector_in_state(state, connector, conn_state, i) {
+	for_each_oldnew_connector_in_state(state, connector, old_conn_state, conn_state, i) {
+		if (!conn_state->crtc)
+			conn_state = old_conn_state;
+
 		if (conn_state->crtc != crtc)
 			continue;
 
-- 
2.34.1



