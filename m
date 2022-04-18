Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F609505416
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240934AbiDRNEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241460AbiDRNDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:03:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070AA338A4;
        Mon, 18 Apr 2022 05:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEA69B80E59;
        Mon, 18 Apr 2022 12:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2156AC385A1;
        Mon, 18 Apr 2022 12:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285807;
        bh=9bSQ4S1IDUAnhmQfnggx2NYyttspU22heoTUTR8pNyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fY0inlDLd1ogSB5n1xIl074T+KUNmLdYoxb7RwI76ap6YjwleZ86lya+WKJsYp4Yq
         L0xk7Da4j7oXUG9L/3mmw2TtPhwXBtE/Kwkygd1aSIZl5Q6IXZs4iz5qGM9LE9Cxhz
         GPDgahSwBzZb2JJR52fjK/JIhVh6qS5m/pWbyUww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wayne Lin <Wayne.Lin@amd.com>,
        Alex Hung <alex.hung@amd.com>, Roman Li <Roman.Li@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/63] drm/amd/display: Fix allocate_mst_payload assert on resume
Date:   Mon, 18 Apr 2022 14:13:28 +0200
Message-Id: <20220418121136.200190338@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index c5231c50c412..de33864af70b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1210,7 +1210,8 @@ static int dm_resume(void *handle)
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



