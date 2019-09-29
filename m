Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2071C1546
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbfI2OCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730220AbfI2OCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:02:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A06682082F;
        Sun, 29 Sep 2019 14:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765751;
        bh=M3/SmVArOA7JBk5QAHOoRMcoDkCTQfWxfBebZbq2kkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n643buitx5JwcLqG1egBPsXuca7rvCDU4dzb7TcgvgdfK/LM1J4uB4HDToWrOVuYC
         VNONK/wtfFBfCxuflEGZSVe5XKHGmHnoFZ5/87ogMyaNB2pJmMIkA2Cghmzz3UyK3i
         6lw+jk0i1HH28COAmvPqqtVhnr6bzyA1to6plLPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilia Mirkin <imirkin@alum.mit.edu>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 39/45] drm/nouveau/disp/nv50-: fix center/aspect-corrected scaling
Date:   Sun, 29 Sep 2019 15:56:07 +0200
Message-Id: <20190929135033.149716277@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilia Mirkin <imirkin@alum.mit.edu>

[ Upstream commit 533f4752407543f488a9118d817b8c504352b6fb ]

Previously center scaling would get scaling applied to it (when it was
only supposed to center the image), and aspect-corrected scaling did not
always correctly pick whether to reduce width or height for a particular
combination of inputs/outputs.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110660
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/head.c | 28 +++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.c b/drivers/gpu/drm/nouveau/dispnv50/head.c
index 06ee23823a689..acfafc4bda0e1 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
@@ -169,14 +169,34 @@ nv50_head_atomic_check_view(struct nv50_head_atom *armh,
 	 */
 	switch (mode) {
 	case DRM_MODE_SCALE_CENTER:
-		asyh->view.oW = min((u16)umode->hdisplay, asyh->view.oW);
-		asyh->view.oH = min((u16)umode_vdisplay, asyh->view.oH);
-		/* fall-through */
+		/* NOTE: This will cause scaling when the input is
+		 * larger than the output.
+		 */
+		asyh->view.oW = min(asyh->view.iW, asyh->view.oW);
+		asyh->view.oH = min(asyh->view.iH, asyh->view.oH);
+		break;
 	case DRM_MODE_SCALE_ASPECT:
-		if (asyh->view.oH < asyh->view.oW) {
+		/* Determine whether the scaling should be on width or on
+		 * height. This is done by comparing the aspect ratios of the
+		 * sizes. If the output AR is larger than input AR, that means
+		 * we want to change the width (letterboxed on the
+		 * left/right), otherwise on the height (letterboxed on the
+		 * top/bottom).
+		 *
+		 * E.g. 4:3 (1.333) AR image displayed on a 16:10 (1.6) AR
+		 * screen will have letterboxes on the left/right. However a
+		 * 16:9 (1.777) AR image on that same screen will have
+		 * letterboxes on the top/bottom.
+		 *
+		 * inputAR = iW / iH; outputAR = oW / oH
+		 * outputAR > inputAR is equivalent to oW * iH > iW * oH
+		 */
+		if (asyh->view.oW * asyh->view.iH > asyh->view.iW * asyh->view.oH) {
+			/* Recompute output width, i.e. left/right letterbox */
 			u32 r = (asyh->view.iW << 19) / asyh->view.iH;
 			asyh->view.oW = ((asyh->view.oH * r) + (r / 2)) >> 19;
 		} else {
+			/* Recompute output height, i.e. top/bottom letterbox */
 			u32 r = (asyh->view.iH << 19) / asyh->view.iW;
 			asyh->view.oH = ((asyh->view.oW * r) + (r / 2)) >> 19;
 		}
-- 
2.20.1



