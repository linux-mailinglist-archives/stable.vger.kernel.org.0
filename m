Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE49D24DE30
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgHUR1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgHUQOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:14:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CCA622B43;
        Fri, 21 Aug 2020 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026491;
        bh=SZsiREGE4KJceeQbEtHOnO+GBKVXcEKF/BC7sEucQvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bknph+4rERMgskheMWGV8NHhtO8xWLucaY2dnLi62MLI2FEU28tmybp1WTuKs/MV+
         d9UflDwv8WOgfIHUYBBFU5TtfVfqNyw9cMA020Oov3kNahHr7Vl8ETHA11oQwUcEfj
         0imZl27YoUEGtQ22NADh8wTO1KzkEuvmLPY61TeA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 22/62] drm/radeon: fix multiple reference count leak
Date:   Fri, 21 Aug 2020 12:13:43 -0400
Message-Id: <20200821161423.347071-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 6f2e8acdb48ed166b65d47837c31b177460491ec ]

On calling pm_runtime_get_sync() the reference count of the device
is incremented. In case of failure, decrement the
reference count before returning the error.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index fe12d9d91d7a5..e308344344425 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -879,8 +879,10 @@ radeon_lvds_detect(struct drm_connector *connector, bool force)
 
 	if (!drm_kms_helper_is_poll_worker()) {
 		r = pm_runtime_get_sync(connector->dev->dev);
-		if (r < 0)
+		if (r < 0) {
+			pm_runtime_put_autosuspend(connector->dev->dev);
 			return connector_status_disconnected;
+		}
 	}
 
 	if (encoder) {
@@ -1025,8 +1027,10 @@ radeon_vga_detect(struct drm_connector *connector, bool force)
 
 	if (!drm_kms_helper_is_poll_worker()) {
 		r = pm_runtime_get_sync(connector->dev->dev);
-		if (r < 0)
+		if (r < 0) {
+			pm_runtime_put_autosuspend(connector->dev->dev);
 			return connector_status_disconnected;
+		}
 	}
 
 	encoder = radeon_best_single_encoder(connector);
@@ -1163,8 +1167,10 @@ radeon_tv_detect(struct drm_connector *connector, bool force)
 
 	if (!drm_kms_helper_is_poll_worker()) {
 		r = pm_runtime_get_sync(connector->dev->dev);
-		if (r < 0)
+		if (r < 0) {
+			pm_runtime_put_autosuspend(connector->dev->dev);
 			return connector_status_disconnected;
+		}
 	}
 
 	encoder = radeon_best_single_encoder(connector);
@@ -1247,8 +1253,10 @@ radeon_dvi_detect(struct drm_connector *connector, bool force)
 
 	if (!drm_kms_helper_is_poll_worker()) {
 		r = pm_runtime_get_sync(connector->dev->dev);
-		if (r < 0)
+		if (r < 0) {
+			pm_runtime_put_autosuspend(connector->dev->dev);
 			return connector_status_disconnected;
+		}
 	}
 
 	if (radeon_connector->detected_hpd_without_ddc) {
@@ -1657,8 +1665,10 @@ radeon_dp_detect(struct drm_connector *connector, bool force)
 
 	if (!drm_kms_helper_is_poll_worker()) {
 		r = pm_runtime_get_sync(connector->dev->dev);
-		if (r < 0)
+		if (r < 0) {
+			pm_runtime_put_autosuspend(connector->dev->dev);
 			return connector_status_disconnected;
+		}
 	}
 
 	if (!force && radeon_check_hpd_status_unchanged(connector)) {
-- 
2.25.1

