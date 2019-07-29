Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6EF79857
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388640AbfG2TkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389108AbfG2TkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:40:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FD5B2054F;
        Mon, 29 Jul 2019 19:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429211;
        bh=O4O1xRg2vEkdKzP4OLXiW/qSrm4vIx0hSA+/A3RXq08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+7+v7EzC/BKwi9hZq9TCGJWL5YlIwqD6kLrBSpIRwanTQMGPO5fxMyopjCNqTUS8
         k5iOOFoTS1zpWxXU6OOvLKnbDpD9Qu4wE0DMjibn9nU+6h8XHkIkJhE2Y3MIICOGu9
         IU0/6YHm5q0QM2tKCJzeyCdfgpVl2Dz4bWRvJbrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/113] drm/amd/display: Always allocate initial connector state state
Date:   Mon, 29 Jul 2019 21:21:53 +0200
Message-Id: <20190729190702.105547486@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
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
index dac7978f5ee1..221de241535a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3644,6 +3644,13 @@ void amdgpu_dm_connector_init_helper(struct amdgpu_display_manager *dm,
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
@@ -3811,9 +3818,6 @@ static int amdgpu_dm_connector_init(struct amdgpu_display_manager *dm,
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



