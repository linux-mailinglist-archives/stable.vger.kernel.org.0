Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F9315E913
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404559AbgBNREn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404121AbgBNQPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20CB5246EC;
        Fri, 14 Feb 2020 16:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696922;
        bh=a19AocT5OwzaL6SK3b8YY7n+RaCFIPhwOtHuy0P9eXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tY/jyqsHV70Fhhd1JXKUU3mA6ZihgaVRSx1oeA/aoki/ptr0ZY5H3wzYodc/hax8a
         SV584q0q5mTjEdXRMUjWWVoattrxSC+eEOyU2kdbjYh3cFBfKAg2tnVubkqF63yNEM
         kJqDIfkFnVzmMCrgE1rOAGY+p7xOdxpL5v1b9oGc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 170/252] drm/nouveau: Fix copy-paste error in nouveau_fence_wait_uevent_handler
Date:   Fri, 14 Feb 2020 11:10:25 -0500
Message-Id: <20200214161147.15842-170-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 1eb013473bff5f95b6fe1ca4dd7deda47257b9c2 ]

Like other cases, it should use rcu protected 'chan' rather
than 'fence->channel' in nouveau_fence_wait_uevent_handler.

Fixes: 0ec5f02f0e2c ("drm/nouveau: prevent stale fence->channel pointers, and protect with rcu")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index 412d49bc6e560..ba3883aed4567 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -157,7 +157,7 @@ nouveau_fence_wait_uevent_handler(struct nvif_notify *notify)
 
 		fence = list_entry(fctx->pending.next, typeof(*fence), head);
 		chan = rcu_dereference_protected(fence->channel, lockdep_is_held(&fctx->lock));
-		if (nouveau_fence_update(fence->channel, fctx))
+		if (nouveau_fence_update(chan, fctx))
 			ret = NVIF_NOTIFY_DROP;
 	}
 	spin_unlock_irqrestore(&fctx->lock, flags);
-- 
2.20.1

