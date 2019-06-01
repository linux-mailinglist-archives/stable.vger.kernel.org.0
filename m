Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61E531F4E
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfFANSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727721AbfFANST (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32ABC229EB;
        Sat,  1 Jun 2019 13:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395099;
        bh=38Aw2HzJTAyTMaMqAs3+iZXGKMqousHIfWwFM71u/MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1M1IuOkWY08mAZoddsaCbYg0lLgeOKMT7zLw3OFj5b5Af7FFk86n5XPyTOPrW42d3
         aw9TscHVNHnmS9gLLKXLLvYHqVEUvp9f6WpFTmh82CWg02hD/+9p90EmpGi4apnd+X
         plgH3zg0xSnQtLM8b4F+xsfPuWkgHi/0UGQOa64I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peteris Rudzusiks <peteris.rudzusiks@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 032/186] drm/nouveau: fix duplication of nv50_head_atom struct
Date:   Sat,  1 Jun 2019 09:14:08 -0400
Message-Id: <20190601131653.24205-32-sashal@kernel.org>
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

From: Peteris Rudzusiks <peteris.rudzusiks@gmail.com>

[ Upstream commit c4a52d669690423ee3c99d8eda1e69cd0821fcad ]

nv50_head_atomic_duplicate_state() makes a copy of nv50_head_atom
struct. This patch adds copying of struct member named "or", which
previously was left uninitialized in the duplicated structure.

Due to this bug, incorrect nhsync and nvsync values were sometimes used.
In my particular case, that lead to a mismatch between the output
resolution of the graphics device (GeForce GT 630 OEM) and the reported
input signal resolution on the display. xrandr reported 1680x1050, but
the display reported 1280x1024. As a result of this mismatch, the output
on the display looked like it was cropped (only part of the output was
actually visible on the display).

git bisect pointed to commit 2ca7fb5c1cc6 ("drm/nouveau/kms/nv50: handle
SetControlOutputResource from head"), which added the member "or" to
nv50_head_atom structure, but forgot to copy it in
nv50_head_atomic_duplicate_state().

Fixes: 2ca7fb5c1cc6 ("drm/nouveau/kms/nv50: handle SetControlOutputResource from head")
Signed-off-by: Peteris Rudzusiks <peteris.rudzusiks@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/head.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.c b/drivers/gpu/drm/nouveau/dispnv50/head.c
index 8efb778a3b207..06ee23823a689 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
@@ -413,6 +413,7 @@ nv50_head_atomic_duplicate_state(struct drm_crtc *crtc)
 	asyh->ovly = armh->ovly;
 	asyh->dither = armh->dither;
 	asyh->procamp = armh->procamp;
+	asyh->or = armh->or;
 	asyh->dp = armh->dp;
 	asyh->clr.mask = 0;
 	asyh->set.mask = 0;
-- 
2.20.1

