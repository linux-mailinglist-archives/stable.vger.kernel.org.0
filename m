Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE9CED16D4
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732450AbfJIRcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731145AbfJIRXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:23:55 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE394218DE;
        Wed,  9 Oct 2019 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641833;
        bh=K02rh1HsZkrO5DpDzfg0K9uNvLOc6lHlJ8tW9pFGt+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cd6Q9R6iyZSwnf2sUjMSrLHYgtSpWVD5esuQnyhbfK7iEoIDHW2b8CjpKiva6XWhK
         cAUskU5vGFLgMo/ivHt9vquVSexuBFOqeax8W8deZNeNzHCwZd6awcxXDGSRK/vT2/
         3ba3Ijblb/bYtAXtLWlSYG3+W52FaJhApWpy8K6c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Lowry Li (Arm Technology China)" <Lowry.Li@arm.com>,
        Lowry Li <lowry.li@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
        James Qian Wang <james.qian.wang@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-sh@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 02/68] drm: Free the writeback_job when it with an empty fb
Date:   Wed,  9 Oct 2019 13:04:41 -0400
Message-Id: <20191009170547.32204-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170547.32204-1-sashal@kernel.org>
References: <20191009170547.32204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Lowry Li (Arm Technology China)" <Lowry.Li@arm.com>

[ Upstream commit 8581d51055a08cc6eb061c8856062290e8582ce4 ]

Adds the check if the writeback_job with an empty fb, then it should
be freed in atomic_check phase.

With this change, the driver users will not check empty fb case any more.
So refined accordingly.

Signed-off-by: Lowry Li (Arm Technology China) <lowry.li@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: James Qian Wang (Arm Technology China) <james.qian.wang@arm.com>
Signed-off-by: james qian wang (Arm Technology China) <james.qian.wang@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1564571048-15029-2-git-send-email-lowry.li@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/arm/display/komeda/komeda_wb_connector.c    |  3 +--
 drivers/gpu/drm/arm/malidp_mw.c                     |  4 ++--
 drivers/gpu/drm/drm_atomic.c                        | 13 +++++++++----
 drivers/gpu/drm/rcar-du/rcar_du_writeback.c         |  4 ++--
 drivers/gpu/drm/vc4/vc4_txp.c                       |  5 ++---
 5 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c b/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
index 2851cac94d869..23fbee268119f 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
@@ -43,9 +43,8 @@ komeda_wb_encoder_atomic_check(struct drm_encoder *encoder,
 	struct komeda_data_flow_cfg dflow;
 	int err;
 
-	if (!writeback_job || !writeback_job->fb) {
+	if (!writeback_job)
 		return 0;
-	}
 
 	if (!crtc_st->active) {
 		DRM_DEBUG_ATOMIC("Cannot write the composition result out on a inactive CRTC.\n");
diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
index 2e812525025dd..a59227b2cdb55 100644
--- a/drivers/gpu/drm/arm/malidp_mw.c
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -130,7 +130,7 @@ malidp_mw_encoder_atomic_check(struct drm_encoder *encoder,
 	struct drm_framebuffer *fb;
 	int i, n_planes;
 
-	if (!conn_state->writeback_job || !conn_state->writeback_job->fb)
+	if (!conn_state->writeback_job)
 		return 0;
 
 	fb = conn_state->writeback_job->fb;
@@ -247,7 +247,7 @@ void malidp_mw_atomic_commit(struct drm_device *drm,
 
 	mw_state = to_mw_state(conn_state);
 
-	if (conn_state->writeback_job && conn_state->writeback_job->fb) {
+	if (conn_state->writeback_job) {
 		struct drm_framebuffer *fb = conn_state->writeback_job->fb;
 
 		DRM_DEV_DEBUG_DRIVER(drm->dev,
diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 419381abbdd16..14aeaf7363210 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -430,10 +430,15 @@ static int drm_atomic_connector_check(struct drm_connector *connector,
 		return -EINVAL;
 	}
 
-	if (writeback_job->out_fence && !writeback_job->fb) {
-		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] requesting out-fence without framebuffer\n",
-				 connector->base.id, connector->name);
-		return -EINVAL;
+	if (!writeback_job->fb) {
+		if (writeback_job->out_fence) {
+			DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] requesting out-fence without framebuffer\n",
+					 connector->base.id, connector->name);
+			return -EINVAL;
+		}
+
+		drm_writeback_cleanup_job(writeback_job);
+		state->writeback_job = NULL;
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_writeback.c b/drivers/gpu/drm/rcar-du/rcar_du_writeback.c
index ae07290bba6a4..04efa78d70b6e 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_writeback.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_writeback.c
@@ -147,7 +147,7 @@ static int rcar_du_wb_enc_atomic_check(struct drm_encoder *encoder,
 	struct drm_device *dev = encoder->dev;
 	struct drm_framebuffer *fb;
 
-	if (!conn_state->writeback_job || !conn_state->writeback_job->fb)
+	if (!conn_state->writeback_job)
 		return 0;
 
 	fb = conn_state->writeback_job->fb;
@@ -221,7 +221,7 @@ void rcar_du_writeback_setup(struct rcar_du_crtc *rcrtc,
 	unsigned int i;
 
 	state = rcrtc->writeback.base.state;
-	if (!state || !state->writeback_job || !state->writeback_job->fb)
+	if (!state || !state->writeback_job)
 		return;
 
 	fb = state->writeback_job->fb;
diff --git a/drivers/gpu/drm/vc4/vc4_txp.c b/drivers/gpu/drm/vc4/vc4_txp.c
index 96f91c1b4b6e6..e92fa12750343 100644
--- a/drivers/gpu/drm/vc4/vc4_txp.c
+++ b/drivers/gpu/drm/vc4/vc4_txp.c
@@ -229,7 +229,7 @@ static int vc4_txp_connector_atomic_check(struct drm_connector *conn,
 	int i;
 
 	conn_state = drm_atomic_get_new_connector_state(state, conn);
-	if (!conn_state->writeback_job || !conn_state->writeback_job->fb)
+	if (!conn_state->writeback_job)
 		return 0;
 
 	crtc_state = drm_atomic_get_new_crtc_state(state, conn_state->crtc);
@@ -269,8 +269,7 @@ static void vc4_txp_connector_atomic_commit(struct drm_connector *conn,
 	u32 ctrl;
 	int i;
 
-	if (WARN_ON(!conn_state->writeback_job ||
-		    !conn_state->writeback_job->fb))
+	if (WARN_ON(!conn_state->writeback_job))
 		return;
 
 	mode = &conn_state->crtc->state->adjusted_mode;
-- 
2.20.1

