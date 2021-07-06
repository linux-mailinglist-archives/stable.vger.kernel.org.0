Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A7A3BD1F5
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhGFLlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237454AbhGFLgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ECDD61D92;
        Tue,  6 Jul 2021 11:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570871;
        bh=LRf7YL2qu7tu9ILqcSKb69Cs3pWEIp926myaJkaQwg0=;
        h=From:To:Cc:Subject:Date:From;
        b=NlYpezUIX+ZHldN1KxC+kvtPL2g5ZjfptsF8ZGkoYYlHxHKAjb+ElV5bCFkYs9QNh
         bE4POXBGt2/E+AGaZMTIYvAXYQ1Wxf6aKpYVtwffxIZEQTdYinPnHonYk1uPyAQU69
         V2KpH009A7SstXxUishf66yqqlnpclrl7ADzrRB3OGdzA8jfBBscT0ttQ5UC4oEXHc
         2vyydjgdKpUPW8U0gM22WM+PfPKJWJwSCom7ngGc4xr6ZifLq6zPgIdsw1Lf712ag/
         qrzDJ+qnOARcLT4ckhTQjRfJvUySmH1cXJ6z3P4Aas+e0pGehFU/eZNKjEDPiiaGhU
         X6wGFag6D4jdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 01/45] drm/etnaviv: fix NULL check before some freeing functions is not needed
Date:   Tue,  6 Jul 2021 07:27:05 -0400
Message-Id: <20210706112749.2065541-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tian Tao <tiantao6@hisilicon.com>

[ Upstream commit 7d614ab2f20503ed8766363d41f8607337571adf ]

fixed the below warning:
drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c:84:2-8: WARNING: NULL check
before some freeing functions is not needed.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
index 880b95511b98..1faa3da8c517 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
@@ -86,8 +86,7 @@ static void etnaviv_gem_prime_release(struct etnaviv_gem_object *etnaviv_obj)
 	/* Don't drop the pages for imported dmabuf, as they are not
 	 * ours, just free the array we allocated:
 	 */
-	if (etnaviv_obj->pages)
-		kvfree(etnaviv_obj->pages);
+	kvfree(etnaviv_obj->pages);
 
 	drm_prime_gem_destroy(&etnaviv_obj->base, etnaviv_obj->sgt);
 }
-- 
2.30.2

