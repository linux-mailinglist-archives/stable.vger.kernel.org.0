Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E115A3BD50F
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhGFMSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237006AbhGFLfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B6F161C9F;
        Tue,  6 Jul 2021 11:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570704;
        bh=5ar99qYRot/F6RJRtWm12nnAB8f1Fj+0g19hBi2cuPE=;
        h=From:To:Cc:Subject:Date:From;
        b=XX46NvaleKVfY7w4O2kIbCjA+OMRfqGxA63rE0jXmg73bUkG7zRBk2KT9G6Z0VQbT
         665Lti7oO/PGkjNanbcFGeYkE76aD9k30DQ4uIxqs/MHqfSkitUKeJkYnGcXm7NlxO
         8Q0B8yI/u8bao4+xsdNyX6TgmkGGYvKTaTj/cALrty7vDwcHpMEl4wp7F/NT4StVcr
         3a2QfZd8Da2GxfMy9LdYgnkwSaRpyBdwraI8wtDUYs+b8Q/4DR3pOUfe8NnejJC8a/
         k98Meppv/ZA7BRWlguYy9hfuI01atJJhuhS7tXszgC2j2nRUDIrLjEDSAafEcy0J03
         cGsXxng2ZsW7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 01/74] drm/etnaviv: fix NULL check before some freeing functions is not needed
Date:   Tue,  6 Jul 2021 07:23:49 -0400
Message-Id: <20210706112502.2064236-1-sashal@kernel.org>
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
index f24dd21c2363..9e657a096f45 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
@@ -77,8 +77,7 @@ static void etnaviv_gem_prime_release(struct etnaviv_gem_object *etnaviv_obj)
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

