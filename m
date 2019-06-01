Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FF931F36
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfFANSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:18:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727760AbfFANSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C9DA251C3;
        Sat,  1 Jun 2019 13:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395109;
        bh=gUSPFcg3u6gsSECUBzjova+NOiDsmG6nS4+aOwcZlQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaIC757KXiPNUpcXKK3yF0NNzENGJB3n9ZrjfOllAD1tpCyXx5NCbskrMgmwkn2CH
         cYhLnTYrENUpqyNdtoqR/iwZRfxUKnpnpg/iwJ1z5CLWp5wnF3Cj6peLtQD7h2i5kv
         B08vaqd+SjCZa0LCcKZZEgiVCUPUZ5f7YvOx7WuQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 035/186] drm/nouveau/kms/gv100-: fix spurious window immediate interlocks
Date:   Sat,  1 Jun 2019 09:14:11 -0400
Message-Id: <20190601131653.24205-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit d2434e4d942c32cadcbdbcd32c58f35098f3b604 ]

Cursor position updates were accidentally causing us to attempt to interlock
window with window immediate, and without a matching window immediate update,
NVDisplay could hang forever in some circumstances.

Fixes suspend/resume on (at least) Quadro RTX4000 (TU104).

Reported-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.h     | 1 +
 drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c | 1 +
 drivers/gpu/drm/nouveau/dispnv50/wndw.c     | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.h b/drivers/gpu/drm/nouveau/dispnv50/disp.h
index 2216c58620c2d..7c41b0599d1ac 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.h
@@ -41,6 +41,7 @@ struct nv50_disp_interlock {
 		NV50_DISP_INTERLOCK__SIZE
 	} type;
 	u32 data;
+	u32 wimm;
 };
 
 void corec37d_ntfy_init(struct nouveau_bo *, u32);
diff --git a/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c b/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c
index 9103b8494279c..f7dbd965e4e72 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c
@@ -75,6 +75,7 @@ wimmc37b_init_(const struct nv50_wimm_func *func, struct nouveau_drm *drm,
 		return ret;
 	}
 
+	wndw->interlock.wimm = wndw->interlock.data;
 	wndw->immd = func;
 	return 0;
 }
diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.c b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
index b95181027b317..471a39a077e55 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -149,7 +149,7 @@ nv50_wndw_flush_set(struct nv50_wndw *wndw, u32 *interlock,
 	if (asyw->set.point) {
 		if (asyw->set.point = false, asyw->set.mask)
 			interlock[wndw->interlock.type] |= wndw->interlock.data;
-		interlock[NV50_DISP_INTERLOCK_WIMM] |= wndw->interlock.data;
+		interlock[NV50_DISP_INTERLOCK_WIMM] |= wndw->interlock.wimm;
 
 		wndw->immd->point(wndw, asyw);
 		wndw->immd->update(wndw, interlock);
-- 
2.20.1

