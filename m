Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F7A3BD1A6
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238707AbhGFLkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237291AbhGFLgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D76A561EDB;
        Tue,  6 Jul 2021 11:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570800;
        bh=N6iIoM3+L3GraS650jrnROI8KA5wyy97eMgeCufJoQo=;
        h=From:To:Cc:Subject:Date:From;
        b=qX/t91QJUr9eFvofWQLfCkesD2G8ltugHk9pZN7paTqsIRuUs72O0k8vBE6s47jS0
         iBjV0CXoOUVyPLmPC597S/mXde2g/ZQKdOIZU4vURjPCq6HwLohsKvwmviHVBJoQFr
         hwkjMyKjnbYpYa8mDDVVtp8tHV/UsoByl7s4qieWhzPHvS614GBcCENyDUjoz2mfsG
         QyZ9ec6Uzl1Z/9wHxdif/asXzOLmKXRQKZn5Ewl3mNgfUony/7hR8ZK1qebe6ABdxo
         Dqs5UG4ZL0N+ryTNLKk5od12mwvWYBNSjV6qEMibaevTTzhhP+M1G3HAvoaidmcLtm
         LpZy2wIKz04+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 01/55] drm/etnaviv: fix NULL check before some freeing functions is not needed
Date:   Tue,  6 Jul 2021 07:25:44 -0400
Message-Id: <20210706112638.2065023-1-sashal@kernel.org>
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
index f21529e635e3..dd814d42a0f9 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
@@ -75,8 +75,7 @@ static void etnaviv_gem_prime_release(struct etnaviv_gem_object *etnaviv_obj)
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

