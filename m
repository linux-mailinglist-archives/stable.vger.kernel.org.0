Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4636E44094
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733233AbfFMQHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731306AbfFMIpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:45:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65C0A21743;
        Thu, 13 Jun 2019 08:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415538;
        bh=MwDJ6yHKjBfG64uMwyxXIftvLVqGvedoBER/Rnl76Rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xpsuPSHTXKlLEpxxUIODav9r/1Kow4+NS6cFMGEuWZLj3wmR3Iqz+KF226Ecbr359
         g/mLIKvQzEJtQYQztpdm/+jZV5+Q8tdMArwGD2X7IDxkp9vpEZ5aAaKiBxVLOzayM4
         RSPO0LsJo+sT9ISMtxzWiiBvyzkJd04mzVCLsklY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 036/155] drm/nouveau/kms/gv100-: fix spurious window immediate interlocks
Date:   Thu, 13 Jun 2019 10:32:28 +0200
Message-Id: <20190613075655.095326181@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
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
index 2216c58620c2..7c41b0599d1a 100644
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
index b95181027b31..471a39a077e5 100644
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



