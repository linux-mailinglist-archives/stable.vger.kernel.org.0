Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E5E2AB9FB
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732025AbgKINOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733182AbgKINOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:14:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 630A4208FE;
        Mon,  9 Nov 2020 13:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927674;
        bh=X4DI0Zq2RbtlaIeDX1Ulp8lHis9rUanRpJQiAoSMBx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRvUpoqL96EKgXxB+nhLg+8d4+F7Hf0tr/f3kt/IsPXXw7rCtbOujSgBQc40ENbno
         4vPJr2K4yOnriEJ5M+m+ym/4fmEpsIFqHpJqXvV9o0lo6/zuj3HIt4SRLpWD6+eu0y
         3yh0DFs7hmCYApIVJLw1T36e9LFJhApb5yZiL1O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 61/85] drm/nouveau/gem: fix "refcount_t: underflow; use-after-free"
Date:   Mon,  9 Nov 2020 13:55:58 +0100
Message-Id: <20201109125025.496001592@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



