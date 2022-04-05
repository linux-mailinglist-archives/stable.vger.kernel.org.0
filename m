Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CC34F37DB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359589AbiDELUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349106AbiDEJtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E16AA024;
        Tue,  5 Apr 2022 02:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E62A8615E5;
        Tue,  5 Apr 2022 09:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F6FC385A4;
        Tue,  5 Apr 2022 09:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151659;
        bh=S0tN8CdSkaCy2ANkjHijuGJLhnaB2fvJt27wInlegNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIDUQE4lkKFMDmDG4Oeja+DPRhBU1w6S3OKgcBOJqtPgy9wzFmkMMXqIYIR8t2E3/
         ExAXhRZrDVKJJvpWU3l68RTLsBYSY/0wPQIakVEuc3c7p/c0mvVqLR/SPzMLYIWG8M
         aagVzCroYmzuQXxXIxMCW3trDQphfI5BbiYkpEs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hersen Wu <hersenwu@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 457/913] drm/amd/display: Add affected crtcs to atomic state for dsc mst unplug
Date:   Tue,  5 Apr 2022 09:25:19 +0200
Message-Id: <20220405070353.547555261@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 7983c01c007d..b9859e52ad92 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10226,10 +10226,13 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
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



