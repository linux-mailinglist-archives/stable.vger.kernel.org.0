Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F12EE6701
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbfJ0VRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731006AbfJ0VRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:17:13 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCA5E205C9;
        Sun, 27 Oct 2019 21:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211032;
        bh=zhckgUep76OpebvAf3fwYTU9iJOmCzEJqsA0iackRgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unUB8uX4v2LFKoICK2hUi4156wl7KIs2YKjggtVcWKl5Vg70+OToA0mCYbHjiNj/y
         6ZIBshJBDZXEXga3g0jrecZyYKE7SEDp26IUQVoa3yHtNM7osnN3lq1YrMldFphihF
         iRYBAsWI0YHIWZtiaoALNwTyscslqrzTOOpT+rVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Lowry Li (Arm Technology China)" <lowry.li@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        "James Qian Wang (Arm Technology China)" <james.qian.wang@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 001/197] drm: Free the writeback_job when it with an empty fb
Date:   Sun, 27 Oct 2019 21:58:39 +0100
Message-Id: <20191027203351.770938071@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lowry Li (Arm Technology China) <Lowry.Li@arm.com>

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



