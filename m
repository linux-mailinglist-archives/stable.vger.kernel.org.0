Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B40715DEB7
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390038AbgBNQE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:04:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390032AbgBNQE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D59962467D;
        Fri, 14 Feb 2020 16:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696295;
        bh=DW5GVlLjsJ4R3hleUz2MVkLaoQrzJoSFfMAF37+7wP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifeHYtpQAUaT7YGFKfrp6eJp9jZpZaAM1Sa31L4wNgitRr4cKz9rfXmTBXrW2pWop
         CfegwGlIoT90ssdpIbKhAFetYexgDe/D6aXmqnvYD/7QrGubAkeF5nJpMux6dmuwEH
         JMGvhYstFlgXWVs1YLrBNwMS+FY08p+le5MnLbf0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 141/459] drm/radeon: remove set but not used variable 'dig_connector'
Date:   Fri, 14 Feb 2020 10:56:31 -0500
Message-Id: <20200214160149.11681-141-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit 3f47f0301594c4f930a32bd7d8125cfdeb6b4b6e ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/radeon/atombios_dp.c: In function radeon_dp_get_panel_mode:
drivers/gpu/drm/radeon/atombios_dp.c:415:36: warning: variable dig_connector set but not used [-Wunused-but-set-variable]

It is not used since commit 379dfc25e257 ("drm/radeon/dp:
switch to the common i2c over aux code")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/atombios_dp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 6f38375c77c89..911735f8d5de3 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -412,7 +412,6 @@ int radeon_dp_get_panel_mode(struct drm_encoder *encoder,
 	struct drm_device *dev = encoder->dev;
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_connector *radeon_connector = to_radeon_connector(connector);
-	struct radeon_connector_atom_dig *dig_connector;
 	int panel_mode = DP_PANEL_MODE_EXTERNAL_DP_MODE;
 	u16 dp_bridge = radeon_connector_encoder_get_dp_bridge_encoder_id(connector);
 	u8 tmp;
@@ -423,8 +422,6 @@ int radeon_dp_get_panel_mode(struct drm_encoder *encoder,
 	if (!radeon_connector->con_priv)
 		return panel_mode;
 
-	dig_connector = radeon_connector->con_priv;
-
 	if (dp_bridge != ENCODER_OBJECT_ID_NONE) {
 		/* DP bridge chips */
 		if (drm_dp_dpcd_readb(&radeon_connector->ddc_bus->aux,
-- 
2.20.1

