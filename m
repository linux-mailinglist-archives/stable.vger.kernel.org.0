Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DCB3F54CD
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhHXA4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234100AbhHXAzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A55961505;
        Tue, 24 Aug 2021 00:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766494;
        bh=SeOgXlnqHRSabu3WEknI16YpzR/RvSvtxZtiiLLS0OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOrdi/eb4TQdwLnoQRYYKZo+XE/eHAJwkhXLePN2nV/9nDp0SBdU+HHXyISgC+sIt
         +/+iMW5Mqn2Z7d1xvXme6arf4cNYw1dr/YNT9LV4qtWIIp056NvbqPCuTa41SqNPgs
         AQdEi82T/D/T4QSinZQaYIycqmdZvi0QY9LC3z1WbBqn7cZWpTU61IFE7Q0fvE1gyc
         j5HOn0E156ehqpyWuIXRmP5wwNbhAi3/RkLB/ZErS+7n/X4l6+RZQJKqBL7gEXTSRq
         S8MAuRCJkvKqZDKAm+qDCNDtaW+pW8IjNrqvnKD1rvXl5UeypK5f5dnIweEKnC1E5n
         VPmtLOB26w0xQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 16/18] drm/nouveau/kms/nv50: workaround EFI GOP window channel format differences
Date:   Mon, 23 Aug 2021 20:54:30 -0400
Message-Id: <20210824005432.631154-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005432.631154-1-sashal@kernel.org>
References: <20210824005432.631154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit e78b1b545c6cfe9f87fc577128e00026fff230ba ]

Should fix some initial modeset failures on (at least) Ampere boards.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 27 +++++++++++++++++++++++++
 drivers/gpu/drm/nouveau/dispnv50/head.c | 13 ++++++++----
 drivers/gpu/drm/nouveau/dispnv50/head.h |  1 +
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 5b8cabb099eb..c2d34c91e840 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2202,6 +2202,33 @@ nv50_disp_atomic_commit_tail(struct drm_atomic_state *state)
 		interlock[NV50_DISP_INTERLOCK_CORE] = 0;
 	}
 
+	/* Finish updating head(s)...
+	 *
+	 * NVD is rather picky about both where window assignments can change,
+	 * *and* about certain core and window channel states matching.
+	 *
+	 * The EFI GOP driver on newer GPUs configures window channels with a
+	 * different output format to what we do, and the core channel update
+	 * in the assign_windows case above would result in a state mismatch.
+	 *
+	 * Delay some of the head update until after that point to workaround
+	 * the issue.  This only affects the initial modeset.
+	 *
+	 * TODO: handle this better when adding flexible window mapping
+	 */
+	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
+		struct nv50_head_atom *asyh = nv50_head_atom(new_crtc_state);
+		struct nv50_head *head = nv50_head(crtc);
+
+		NV_ATOMIC(drm, "%s: set %04x (clr %04x)\n", crtc->name,
+			  asyh->set.mask, asyh->clr.mask);
+
+		if (asyh->set.mask) {
+			nv50_head_flush_set_wndw(head, asyh);
+			interlock[NV50_DISP_INTERLOCK_CORE] = 1;
+		}
+	}
+
 	/* Update plane(s). */
 	for_each_new_plane_in_state(state, plane, new_plane_state, i) {
 		struct nv50_wndw_atom *asyw = nv50_wndw_atom(new_plane_state);
diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.c b/drivers/gpu/drm/nouveau/dispnv50/head.c
index 841edfaf5b9d..61826cac3061 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
@@ -49,11 +49,8 @@ nv50_head_flush_clr(struct nv50_head *head,
 }
 
 void
-nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh)
+nv50_head_flush_set_wndw(struct nv50_head *head, struct nv50_head_atom *asyh)
 {
-	if (asyh->set.view   ) head->func->view    (head, asyh);
-	if (asyh->set.mode   ) head->func->mode    (head, asyh);
-	if (asyh->set.core   ) head->func->core_set(head, asyh);
 	if (asyh->set.olut   ) {
 		asyh->olut.offset = nv50_lut_load(&head->olut,
 						  asyh->olut.buffer,
@@ -61,6 +58,14 @@ nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh)
 						  asyh->olut.load);
 		head->func->olut_set(head, asyh);
 	}
+}
+
+void
+nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh)
+{
+	if (asyh->set.view   ) head->func->view    (head, asyh);
+	if (asyh->set.mode   ) head->func->mode    (head, asyh);
+	if (asyh->set.core   ) head->func->core_set(head, asyh);
 	if (asyh->set.curs   ) head->func->curs_set(head, asyh);
 	if (asyh->set.base   ) head->func->base    (head, asyh);
 	if (asyh->set.ovly   ) head->func->ovly    (head, asyh);
diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.h b/drivers/gpu/drm/nouveau/dispnv50/head.h
index dae841dc05fd..0bac6be9ba34 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.h
@@ -21,6 +21,7 @@ struct nv50_head {
 
 struct nv50_head *nv50_head_create(struct drm_device *, int index);
 void nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh);
+void nv50_head_flush_set_wndw(struct nv50_head *head, struct nv50_head_atom *asyh);
 void nv50_head_flush_clr(struct nv50_head *head,
 			 struct nv50_head_atom *asyh, bool flush);
 
-- 
2.30.2

