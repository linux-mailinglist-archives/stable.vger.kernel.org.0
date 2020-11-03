Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3840B2A3914
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgKCBUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728116AbgKCBUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:20:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F198322450;
        Tue,  3 Nov 2020 01:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366437;
        bh=X4DI0Zq2RbtlaIeDX1Ulp8lHis9rUanRpJQiAoSMBx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smfP1z38dMcy0/cwtWQypgbqTrKlDRj+jlJTLkIAEfMSTZleizW8FvO/Rh87LZK6C
         ueqFmBRguYeuVl2OOo6z1g49smmS8z1rSEzF6ZCLLTeC1QBSgW6615ZHroVcvmpfVy
         rRzYnCat0EVmuF0HR0o1n40yN5lcQOdrW+ru/H0s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karol Herbst <kherbst@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 23/24] drm/nouveau/gem: fix "refcount_t: underflow; use-after-free"
Date:   Mon,  2 Nov 2020 20:20:06 -0500
Message-Id: <20201103012007.183429-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103012007.183429-1-sashal@kernel.org>
References: <20201103012007.183429-1-sashal@kernel.org>
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
index 7d39d4949ee77..2dd9fcab464b1 100644
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

