Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 167D015E1BA
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392837AbgBNQT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392831AbgBNQT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:19:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DEB224721;
        Fri, 14 Feb 2020 16:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697197;
        bh=A5JhqAJW0/T19P0pXEctJKdutmGn5EGnPtPBSXQsXo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZSjkvaxBCmfn0Qk3bO+iYmUR5RYvvl06EqOiP7nIKsIdxynf9oNRj4ZGslib8+Mq
         kXrvV8QjMk82lBhoFZUpxzp8sSPRTiah4BqRIfLSf5Pdf4JncoiXvVhv8w9aQYepR5
         aSTpzDFwq6dxnWji7YhG7pwANxzPojTExDnRAnb4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 126/186] drm/nouveau/gr/gk20a,gm200-: add terminators to method lists read from fw
Date:   Fri, 14 Feb 2020 11:16:15 -0500
Message-Id: <20200214161715.18113-126-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 7adc77aa0e11f25b0e762859219c70852cd8d56f ]

Method init is typically ordered by class in the FW image as ThreeD,
TwoD, Compute.

Due to a bug in parsing the FW into our internal format, we've been
accidentally sending Twod + Compute methods to the ThreeD class, as
well as Compute methods to the TwoD class - oops.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/nouveau/nvkm/engine/gr/gk20a.c    | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c
index de8b806b88fd9..7618b2eb4fdfd 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c
@@ -143,23 +143,24 @@ gk20a_gr_av_to_method(struct gf100_gr *gr, const char *fw_name,
 
 	nent = (fuc.size / sizeof(struct gk20a_fw_av));
 
-	pack = vzalloc((sizeof(*pack) * max_classes) +
-		       (sizeof(*init) * (nent + 1)));
+	pack = vzalloc((sizeof(*pack) * (max_classes + 1)) +
+		       (sizeof(*init) * (nent + max_classes + 1)));
 	if (!pack) {
 		ret = -ENOMEM;
 		goto end;
 	}
 
-	init = (void *)(pack + max_classes);
+	init = (void *)(pack + max_classes + 1);
 
-	for (i = 0; i < nent; i++) {
-		struct gf100_gr_init *ent = &init[i];
+	for (i = 0; i < nent; i++, init++) {
 		struct gk20a_fw_av *av = &((struct gk20a_fw_av *)fuc.data)[i];
 		u32 class = av->addr & 0xffff;
 		u32 addr = (av->addr & 0xffff0000) >> 14;
 
 		if (prevclass != class) {
-			pack[classidx].init = ent;
+			if (prevclass) /* Add terminator to the method list. */
+				init++;
+			pack[classidx].init = init;
 			pack[classidx].type = class;
 			prevclass = class;
 			if (++classidx >= max_classes) {
@@ -169,10 +170,10 @@ gk20a_gr_av_to_method(struct gf100_gr *gr, const char *fw_name,
 			}
 		}
 
-		ent->addr = addr;
-		ent->data = av->data;
-		ent->count = 1;
-		ent->pitch = 1;
+		init->addr = addr;
+		init->data = av->data;
+		init->count = 1;
+		init->pitch = 1;
 	}
 
 	*ppack = pack;
-- 
2.20.1

