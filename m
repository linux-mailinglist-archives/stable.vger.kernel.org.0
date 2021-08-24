Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF443F5498
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhHXAz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234107AbhHXAzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4912C6140F;
        Tue, 24 Aug 2021 00:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766466;
        bh=02fybzD0ASc1V3c4YuITiVUJwbYdjnQHFfVEy3TjGt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9B1Jlb02dP3gr8iOQaQ2ysbkFMwHAcFWHwidqtXBIVVJ1GFqJiuowmLFQv8vB6c9
         HPuwxgSzEu05eKar3O8mZ3yu6b5tEFe5K/Rm0QW5SS2b65j/vzkdhuOQlrYKFy7mkI
         edF8WmHJgXzi9mZhU8ngEQLE1UFEg2aBTlypeg6AGR8ouQJozjisEcGCXfS3TSyw2/
         DBw5huyV1nFx7FE08QMB27y+hDJoZOAsA+XUyKQWYAncxFgoZZ0VoSsEH3elvi91YS
         u16bCsjXWBJjcJt3lotuA/EPEePfpPkhspB2zjjsiwlW7lT7Pxy+7qQNmfZnHMUnp+
         c+c69o+iTGaRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 22/26] drm/nouveau/kms/nv50: workaround EFI GOP window channel format differences
Date:   Mon, 23 Aug 2021 20:53:52 -0400
Message-Id: <20210824005356.630888-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
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
index 1c9c0cdf85db..578aaac2e277 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2235,6 +2235,33 @@ nv50_disp_atomic_commit_tail(struct drm_atomic_state *state)
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
index ec361d17e900..d66f97280282 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
@@ -50,11 +50,8 @@ nv50_head_flush_clr(struct nv50_head *head,
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
@@ -62,6 +59,14 @@ nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh)
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

