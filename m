Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A1F3FDB6E
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344990AbhIAMll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344678AbhIAMjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:39:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AD67610A4;
        Wed,  1 Sep 2021 12:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499743;
        bh=SeOgXlnqHRSabu3WEknI16YpzR/RvSvtxZtiiLLS0OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCTyTCjFFwvnQKTVVvqOJALQqp/vLezHADlhFNi+8lMMusJyeL6CVxtnhUNCGTT8s
         ejJpncZcCN8g4jIa4MwX41H8/dfLVKUQRwkycDHx+EyuwUn/SSuYF/MpzawQF4+Kqt
         Q2U5YV1pqi9HBvYRJsyxOY4s26yjqjrcbYbwUFdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/103] drm/nouveau/kms/nv50: workaround EFI GOP window channel format differences
Date:   Wed,  1 Sep 2021 14:28:19 +0200
Message-Id: <20210901122302.892707751@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



