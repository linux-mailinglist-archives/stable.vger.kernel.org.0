Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367914FCB08
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344866AbiDLBCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347483AbiDLA7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:59:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C613369D8;
        Mon, 11 Apr 2022 17:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24389B819C5;
        Tue, 12 Apr 2022 00:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB858C385A3;
        Tue, 12 Apr 2022 00:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724731;
        bh=N4oe4JkYZBbeeXFs6huyORVN6GlF6ckNaIQ+O7KQhT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OA7VeqKKY+X9A6aWbzEloSJJwqbUhrQBE0dbmTAJGomE79yq0rs6T4pWEDw++P3mV
         Gaj0QLXOSY0rGjmgsPgz5gMcAOb6aQ8N92p9NSF5gBKWFFEb7HLgwFTdsNfY4HDnS5
         8dYDOwOl94gxErXe8cVQzymeMBLyVXriJ7wP2U12+OnPt8VfzafFyK/vKr7u0rxh5j
         vWJw9rEtJsbnEWI8jc5vqbqP54xQnZLmmlyC8AoalR3MxGIQprLkPbf2yepR6NGsny
         CFlMhCkL3047Lt3HY3eKvl6K8H7yMM1RT7ZanoHxMdhcf5svyUFNur4X4DXUgM4/UL
         WdGF6Odb2LhNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Li <Roman.Li@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nicholas.kazlauskas@amd.com,
        qingqing.zhuo@amd.com, contact@emersion.fr, shenshih@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 10/12] drm/amd/display: Fix allocate_mst_payload assert on resume
Date:   Mon, 11 Apr 2022 20:51:43 -0400
Message-Id: <20220412005148.351391-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005148.351391-1-sashal@kernel.org>
References: <20220412005148.351391-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit f4346fb3edf7720db3f7f5e1cab1f667cd024280 ]

[Why]
On resume we do link detection for all non-MST connectors.
MST is handled separately. However the condition for telling
if connector is on mst branch is not enough for mst hub case.
Link detection for mst branch link leads to mst topology reset.
That causes assert in dc_link_allocate_mst_payload()

[How]
Use link type as indicator for mst link.

Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ed02bb6b2cd0..1d1183c47beb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -777,7 +777,8 @@ static int dm_resume(void *handle)
 		 * this is the case when traversing through already created
 		 * MST connectors, should be skipped
 		 */
-		if (aconnector->mst_port)
+		if (aconnector->dc_link &&
+		    aconnector->dc_link->type == dc_connection_mst_branch)
 			continue;
 
 		mutex_lock(&aconnector->hpd_lock);
-- 
2.35.1

