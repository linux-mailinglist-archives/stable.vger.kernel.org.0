Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E1515F113
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388612AbgBNR75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:59:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387890AbgBNP4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D6E0222C4;
        Fri, 14 Feb 2020 15:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695796;
        bh=jJmGbjrMcrnfyaWkDHs+k6NYLdiYkzr+UWsEzaleZVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rO9EABfGsZReNiZvx7lZsW9s8T3fv+4ED850qpClu1nMDEN03tqykRPQMY1KX+HMq
         HITUcuymKiacAcxRZJUl4KateDuf58kUylbD8u5Eq6gU5Wzyj7pCdxYjQkDJO+vznY
         QyXefGCeeKEepYGka6f7SF7ux++DPfAtSfc05MuE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 357/542] drm/nouveau: Fix copy-paste error in nouveau_fence_wait_uevent_handler
Date:   Fri, 14 Feb 2020 10:45:49 -0500
Message-Id: <20200214154854.6746-357-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
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
index 9118df035b28d..70bb6bb97af87 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -156,7 +156,7 @@ nouveau_fence_wait_uevent_handler(struct nvif_notify *notify)
 
 		fence = list_entry(fctx->pending.next, typeof(*fence), head);
 		chan = rcu_dereference_protected(fence->channel, lockdep_is_held(&fctx->lock));
-		if (nouveau_fence_update(fence->channel, fctx))
+		if (nouveau_fence_update(chan, fctx))
 			ret = NVIF_NOTIFY_DROP;
 	}
 	spin_unlock_irqrestore(&fctx->lock, flags);
-- 
2.20.1

