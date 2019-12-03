Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065DB111F7E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfLCXJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:09:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbfLCWn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:43:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B12EA20803;
        Tue,  3 Dec 2019 22:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413007;
        bh=HoAFqpYfa74MQHwNePRBAUOnqHPBhxifuXH9ekCuqMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3KNQiatbK7zUNYFyu+w+1r6LFutrWKBYdZSZWZWFn/e0roBozFnYUXmPxscr+1dV
         OZVDVuKB0Ds/P//om9gETwSR8IroWZAxr1XM4lUZxqZtbTpQK3x9R2xB83zu4Q1IJ0
         8bZNfe0RRv2SjYKrkO7f11yi6FyxRRxwF67t3AjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, changzhu <Changfeng.Zhu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 083/135] drm/amdgpu: add warning for GRBM 1-cycle delay issue in gfx9
Date:   Tue,  3 Dec 2019 23:35:23 +0100
Message-Id: <20191203213032.716189710@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: changzhu <Changfeng.Zhu@amd.com>

[ Upstream commit 440a7a54e7ec012ec8b27c27e460dfd6f9a24ddb ]

It needs to add warning to update firmware in gfx9
in case that firmware is too old to have function to
realize dummy read in cp firmware.

Signed-off-by: changzhu <Changfeng.Zhu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 75faa56f243a4..b1388d3e72f74 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -538,6 +538,13 @@ static void gfx_v9_0_check_fw_write_wait(struct amdgpu_device *adev)
 	adev->gfx.me_fw_write_wait = false;
 	adev->gfx.mec_fw_write_wait = false;
 
+	if ((adev->gfx.mec_fw_version < 0x000001a5) ||
+	    (adev->gfx.mec_feature_version < 46) ||
+	    (adev->gfx.pfp_fw_version < 0x000000b7) ||
+	    (adev->gfx.pfp_feature_version < 46))
+		DRM_WARN_ONCE("Warning: check cp_fw_version and update it to realize \
+			      GRBM requires 1-cycle delay in cp firmware\n");
+
 	switch (adev->asic_type) {
 	case CHIP_VEGA10:
 		if ((adev->gfx.me_fw_version >= 0x0000009c) &&
-- 
2.20.1



