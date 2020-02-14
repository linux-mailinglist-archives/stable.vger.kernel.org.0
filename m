Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198CC15E5B5
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405235AbgBNQWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:22:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405202AbgBNQWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:22:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6820246CE;
        Fri, 14 Feb 2020 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697324;
        bh=0kT5xc+IVb1pEroXTrduFksV6+JEEfPcC8u/t3uHsk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJ3uKaXVQP4peat/sz4xTW5SpzlaltWQRp1ox3VzgGHxkrKrVSziRK3e8ufCjqPvC
         PIGIUTAi9r90O/pMdCZF6lItqOGMzm0hhtdsreI/2rqng3DrkT3kWuCbT6y89ByZ9J
         7mfwzor6PvQiJqhdQ/i/kXNcvWYWjI+wcIC6AFM4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 033/141] drm/amdgpu: remove set but not used variable 'dig_connector'
Date:   Fri, 14 Feb 2020 11:19:33 -0500
Message-Id: <20200214162122.19794-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit 5bea7fedb7fe4d5e6d3ba9f385dd3619fb004ce7 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/amdgpu/atombios_dp.c: In function
‘amdgpu_atombios_dp_get_panel_mode’:
drivers/gpu/drm/amd/amdgpu/atombios_dp.c:364:36: warning: variable
‘dig_connector’ set but not used [-Wunused-but-set-variable]

It is never used, so can be removed.

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/atombios_dp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/atombios_dp.c b/drivers/gpu/drm/amd/amdgpu/atombios_dp.c
index f81068ba4cc67..d712dee892545 100644
--- a/drivers/gpu/drm/amd/amdgpu/atombios_dp.c
+++ b/drivers/gpu/drm/amd/amdgpu/atombios_dp.c
@@ -361,7 +361,6 @@ int amdgpu_atombios_dp_get_panel_mode(struct drm_encoder *encoder,
 			       struct drm_connector *connector)
 {
 	struct amdgpu_connector *amdgpu_connector = to_amdgpu_connector(connector);
-	struct amdgpu_connector_atom_dig *dig_connector;
 	int panel_mode = DP_PANEL_MODE_EXTERNAL_DP_MODE;
 	u16 dp_bridge = amdgpu_connector_encoder_get_dp_bridge_encoder_id(connector);
 	u8 tmp;
@@ -369,8 +368,6 @@ int amdgpu_atombios_dp_get_panel_mode(struct drm_encoder *encoder,
 	if (!amdgpu_connector->con_priv)
 		return panel_mode;
 
-	dig_connector = amdgpu_connector->con_priv;
-
 	if (dp_bridge != ENCODER_OBJECT_ID_NONE) {
 		/* DP bridge chips */
 		if (drm_dp_dpcd_readb(&amdgpu_connector->ddc_bus->aux,
-- 
2.20.1

