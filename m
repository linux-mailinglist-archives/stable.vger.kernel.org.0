Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE2C54422F
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392094AbfFMQT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731085AbfFMIj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:39:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E273421473;
        Thu, 13 Jun 2019 08:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415168;
        bh=LvyG5bBAfS352aiJgA4c+p3Ggc8y4HYfaYNzoQxw4lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNZHrK3fMaPQ2cikJBzWuR4GeOIj2v11vc3Vb/oxpJ6CsW2QQU5TxlrImq8thUsIY
         RDPw3nFvwgoJcvhepprC/Q1XK6Bz0oMsj9vUmpMqWKv+VYQP20jsmluze0eBjdYXJa
         LYZvSOU6mj7+J6Lz8xa9bXUmndamRpskWMqxdvlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/118] drm/nouveau/kms/gv100-: fix spurious window immediate interlocks
Date:   Thu, 13 Jun 2019 10:32:45 +0200
Message-Id: <20190613075645.116443551@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index e48c5eb35b49..66c125a6b0b3 100644
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
index 9103b8494279..f7dbd965e4e7 100644
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
index 2187922e8dc2..b3db4553098d 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -151,7 +151,7 @@ nv50_wndw_flush_set(struct nv50_wndw *wndw, u32 *interlock,
 	if (asyw->set.point) {
 		if (asyw->set.point = false, asyw->set.mask)
 			interlock[wndw->interlock.type] |= wndw->interlock.data;
-		interlock[NV50_DISP_INTERLOCK_WIMM] |= wndw->interlock.data;
+		interlock[NV50_DISP_INTERLOCK_WIMM] |= wndw->interlock.wimm;
 
 		wndw->immd->point(wndw, asyw);
 		wndw->immd->update(wndw, interlock);
-- 
2.20.1



