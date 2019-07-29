Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFD0797DE
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389557AbfG2UDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390005AbfG2Trl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:47:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FC87205F4;
        Mon, 29 Jul 2019 19:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429660;
        bh=nlbEM+C31Ewvk88+a7TVEKpVhmC0Uit7jhVjrRoaNi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQweiBoPTWuHGl+MoohzqADkTd3ROxnVGcDFUnfP823fZ2g/1yDfaDyRO4yyT+bAM
         RC5ir4Uw0L3VjqGt3Gztqm1y11xxYu5dQftJXhhSJ5bB5LTwk5unFtIsPxZv0jKKDa
         9i5/fj1+D1dcfrDMTMBC91pVsCPIZIgnwfxBDZFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 054/215] drm/amd/display: Always allocate initial connector state state
Date:   Mon, 29 Jul 2019 21:20:50 +0200
Message-Id: <20190729190749.888823339@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f04bee34d6e35df26cbb2d65e801adfd0d8fe20d ]

[Why]
Unlike our regular connectors, MST connectors don't start off with
an initial connector state. This causes a NULL pointer dereference to
occur when attaching the bpc property since it tries to modify the
connector state.

We need an initial connector state on the connector to avoid the crash.

[How]
Use our reset helper to allocate an initial state and reset the values
to their defaults. We were already doing this before, just not for
MST connectors.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0e482349a5cb..dc3ac66a4450 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4627,6 +4627,13 @@ void amdgpu_dm_connector_init_helper(struct amdgpu_display_manager *dm,
 {
 	struct amdgpu_device *adev = dm->ddev->dev_private;
 
+	/*
+	 * Some of the properties below require access to state, like bpc.
+	 * Allocate some default initial connector state with our reset helper.
+	 */
+	if (aconnector->base.funcs->reset)
+		aconnector->base.funcs->reset(&aconnector->base);
+
 	aconnector->connector_id = link_index;
 	aconnector->dc_link = link;
 	aconnector->base.interlace_allowed = false;
@@ -4809,9 +4816,6 @@ static int amdgpu_dm_connector_init(struct amdgpu_display_manager *dm,
 			&aconnector->base,
 			&amdgpu_dm_connector_helper_funcs);
 
-	if (aconnector->base.funcs->reset)
-		aconnector->base.funcs->reset(&aconnector->base);
-
 	amdgpu_dm_connector_init_helper(
 		dm,
 		aconnector,
-- 
2.20.1



