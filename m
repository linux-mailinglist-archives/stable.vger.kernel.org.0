Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A138D167799
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgBUHyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:54:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730261AbgBUHyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:54:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9939C24656;
        Fri, 21 Feb 2020 07:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271676;
        bh=XF+uKzWVjCkasEVsHuILsvLeJGCAQ0To9bSluYuOIk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op9O5d0ehflcdwWPA8WwjoAC5O2PbTCkCZL087Nh0FsSKXWw4UMtHxYiAXu9SIJYq
         gyrcXkWCLLH1Ah65loPF5Mqze6AXVyvsrg5JvI0iC44WI/3kTenEOaHfOapOXDza5y
         6z0/EDUKSAl9+ba8ojM5mlSzR3k8/7tGJWZMmj18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 256/399] drm/nouveau/secboot/gm20b: initialize pointer in gm20b_secboot_new()
Date:   Fri, 21 Feb 2020 08:39:41 +0100
Message-Id: <20200221072427.298985153@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 3613a9bea95a1470dd42e4ed1cc7d86ebe0a2dc0 ]

We accidentally set "psb" which is a no-op instead of "*psb" so it
generates a static checker warning.  We should probably set it before
the first error return so that it's always initialized.

Fixes: 923f1bd27bf1 ("drm/nouveau/secboot/gm20b: add secure boot support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/secboot/gm20b.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/secboot/gm20b.c b/drivers/gpu/drm/nouveau/nvkm/subdev/secboot/gm20b.c
index df8b919dcf09b..ace6fefba4280 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/secboot/gm20b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/secboot/gm20b.c
@@ -108,6 +108,7 @@ gm20b_secboot_new(struct nvkm_device *device, int index,
 	struct gm200_secboot *gsb;
 	struct nvkm_acr *acr;
 
+	*psb = NULL;
 	acr = acr_r352_new(BIT(NVKM_SECBOOT_FALCON_FECS) |
 			   BIT(NVKM_SECBOOT_FALCON_PMU));
 	if (IS_ERR(acr))
@@ -116,10 +117,8 @@ gm20b_secboot_new(struct nvkm_device *device, int index,
 	acr->optional_falcons = BIT(NVKM_SECBOOT_FALCON_PMU);
 
 	gsb = kzalloc(sizeof(*gsb), GFP_KERNEL);
-	if (!gsb) {
-		psb = NULL;
+	if (!gsb)
 		return -ENOMEM;
-	}
 	*psb = &gsb->base;
 
 	ret = nvkm_secboot_ctor(&gm20b_secboot, acr, device, index, &gsb->base);
-- 
2.20.1



