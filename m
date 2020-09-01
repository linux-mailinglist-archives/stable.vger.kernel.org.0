Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADDF259C7A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgIARQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbgIAPOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:14:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 989B8206FA;
        Tue,  1 Sep 2020 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973274;
        bh=RPyEA/kI9KUS4oMh1ysf1Jx+oNDxSmtIr2+ySLYBTQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAA8/BBeJ7RNx40x5NPpGGD9JpqSkGNBirw7CJLg4EOlHCcpQFd2vGjrGi90OEO43
         VHfBJ8FDsPSIzejjrZYVH9kydFjdlF6RRbvx4+ctLqTPnIwkkFu8S5KMgscSKwjf1N
         oHvLgMfsIHBgFrgRl3yBxhaMFRuulC1dsVLqH12Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 14/78] drm/radeon: fix multiple reference count leak
Date:   Tue,  1 Sep 2020 17:09:50 +0200
Message-Id: <20200901150925.450882452@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150924.680106554@linuxfoundation.org>
References: <20200901150924.680106554@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index efa875120071a..9e6c2be0cc7d4 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -892,8 +892,10 @@ radeon_lvds_detect(struct drm_connector *connector, bool force)
 
 	if (!drm_kms_helper_is_poll_worker()) {
 		r = pm_runtime_get_sync(connector->dev->dev);
-		if (r < 0)
+		if (r < 0) {
+			pm_runtime_put_autosuspend(connector->dev->dev);
 			return connector_status_disconnected;
+		}
 	}
 
 	if (encoder) {
@@ -1038,8 +1040,10 @@ radeon_vga_detect(struct drm_connector *connector, bool force)
 
 	if (!drm_kms_helper_is_poll_worker()) {
 		r = pm_runtime_get_sync(connector->dev->dev);
-		if (r < 0)
+		if (r < 0) {
+			pm_runtime_put_autosuspend(connector->dev->dev);
 			return connector_status_disconnected;
+		}
 	}
 
 	encoder = radeon_best_single_encoder(connector);
@@ -1176,8 +1180,10 @@ radeon_tv_detect(struct drm_connector *connector, bool force)
 
 	if (!drm_kms_helper_is_poll_worker()) {
 		r = pm_runtime_get_sync(connector->dev->dev);
-		if (r < 0)
+		if (r < 0) {
+			pm_runtime_put_autosuspend(connector->dev->dev);
 			return connector_status_disconnected;
+		}
 	}
 
 	encoder = radeon_best_single_encoder(connector);
@@ -1260,8 +1266,10 @@ radeon_dvi_detect(struct drm_connector *connector, bool force)
 
 	if (!drm_kms_helper_is_poll_worker()) {
 		r = pm_runtime_get_sync(connector->dev->dev);
-		if (r < 0)
+		if (r < 0) {
+			pm_runtime_put_autosuspend(connector->dev->dev);
 			return connector_status_disconnected;
+		}
 	}
 
 	if (radeon_connector->detected_hpd_without_ddc) {
@@ -1701,8 +1709,10 @@ radeon_dp_detect(struct drm_connector *connector, bool force)
 
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



