Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F7B2A389C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgKCBUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgKCBUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:20:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E7322242A;
        Tue,  3 Nov 2020 01:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366405;
        bh=z3wYUGwaURyhH08VRvPERKJPQl/ha/XMsq5Ddssd09w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gz7cDxoN2InxDj5tDbxnZIcD1/jMAOyF04f1C3yD5w+TJmKgWqq9i/uLxT5Oxuz6J
         raNGIszG1lsisWq7NoSBKAS9b9To39ZrhK/zhGrWd+YW/TJs7HiQQk6eibBrpT/kd9
         xOcAAR+wV1oqi44yQcBOauFCg0qbDrUG/jLGd3H4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karol Herbst <kherbst@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 28/29] drm/nouveau/gem: fix "refcount_t: underflow; use-after-free"
Date:   Mon,  2 Nov 2020 20:19:27 -0500
Message-Id: <20201103011928.183145-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011928.183145-1-sashal@kernel.org>
References: <20201103011928.183145-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Herbst <kherbst@redhat.com>

[ Upstream commit 925681454d7b557d404b5d28ef4469fac1b2e105 ]

we can't use nouveau_bo_ref here as no ttm object was allocated and
nouveau_bo_ref mainly deals with that. Simply deallocate the object.

Signed-off-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index c5ee5b7364a09..ee5fec1ad9a46 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -197,7 +197,8 @@ nouveau_gem_new(struct nouveau_cli *cli, u64 size, int align, uint32_t domain,
 	 * to the caller, instead of a normal nouveau_bo ttm reference. */
 	ret = drm_gem_object_init(drm->dev, &nvbo->bo.base, size);
 	if (ret) {
-		nouveau_bo_ref(NULL, &nvbo);
+		drm_gem_object_release(&nvbo->bo.base);
+		kfree(nvbo);
 		return ret;
 	}
 
-- 
2.27.0

