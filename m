Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D829F2FC78E
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbhATCM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:12:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730890AbhATB3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72B9023619;
        Wed, 20 Jan 2021 01:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106101;
        bh=Xz+i1Z3mOF9fKx3oJXp8w7X6GXSJakG1pmdkXz0IVGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7Rsss4MFgbPZfN2Zsm7U32CYCql9934lhpZxjbORrKymUY81/Efix2WkTM+ghkXO
         3Dsd6vfEV+oPlDfiK9MFXR23n9R3wghBDi/LKIlRMys+0ze3HNnspyNMPji381/NeL
         J6JKY2XUCU8wt92iBWTZRk086EfG+jiGa+SyhdTMEGjFSI/UcmdNlvoZD6Vr3x4tzp
         +OemhK0R3y8SSpHujvlj0a7HSVXosWmdbgEv9c3NBtBbEulEZrr7ykLfjMZAWtFD5r
         gHVnqcBZPuCYBDevm8PFUwSY7gd7AYXsXdgtRhhKvNsu3aKvwifMjMQqx9EB7EYKaU
         QSqZp+gFqw5Vw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 3/4] drm/nouveau/bios: fix issue shadowing expansion ROMs
Date:   Tue, 19 Jan 2021 20:28:15 -0500
Message-Id: <20210120012816.770648-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012816.770648-1-sashal@kernel.org>
References: <20210120012816.770648-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 402a89660e9dc880710b12773076a336c9dab3d7 ]

This issue has generally been covered up by the presence of additional
expansion ROMs after the ones we're interested in, with header fetches
of subsequent images loading enough of the ROM to hide the issue.

Noticed on GA102, which lacks a type 0x70 image compared to TU102,.

[  906.364197] nouveau 0000:09:00.0: bios: 00000000: type 00, 65024 bytes
[  906.381205] nouveau 0000:09:00.0: bios: 0000fe00: type 03, 91648 bytes
[  906.405213] nouveau 0000:09:00.0: bios: 00026400: type e0, 22016 bytes
[  906.410984] nouveau 0000:09:00.0: bios: 0002ba00: type e0, 366080 bytes

vs

[   22.961901] nouveau 0000:09:00.0: bios: 00000000: type 00, 60416 bytes
[   22.984174] nouveau 0000:09:00.0: bios: 0000ec00: type 03, 71168 bytes
[   23.010446] nouveau 0000:09:00.0: bios: 00020200: type e0, 48128 bytes
[   23.028220] nouveau 0000:09:00.0: bios: 0002be00: type e0, 140800 bytes
[   23.080196] nouveau 0000:09:00.0: bios: 0004e400: type 70, 7168 bytes

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c
index 7deb81b6dbac6..4b571cc6bc70f 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c
@@ -75,7 +75,7 @@ shadow_image(struct nvkm_bios *bios, int idx, u32 offset, struct shadow *mthd)
 	nvkm_debug(subdev, "%08x: type %02x, %d bytes\n",
 		   image.base, image.type, image.size);
 
-	if (!shadow_fetch(bios, mthd, image.size)) {
+	if (!shadow_fetch(bios, mthd, image.base + image.size)) {
 		nvkm_debug(subdev, "%08x: fetch failed\n", image.base);
 		return 0;
 	}
-- 
2.27.0

