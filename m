Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFB93F6504
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbhHXRJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239424AbhHXRHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:07:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4545D61A03;
        Tue, 24 Aug 2021 16:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824393;
        bh=F2FT0g7L52h8sL+T7edZCGy0lh3Ffzr5XO4mXu3JFg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdYYN94f35r8gpSOXy1Ngs56jBUBMOUNP8oZVv54tBv52xm34o71Y0u/PTe+Qs1Z2
         KSZZt47tjqhw6JQGduk5J3bV7w+rE4b28BnEDzpEzBn+KRLLMHOjxhnAHWzJI9LXUv
         qfJHH8u1U4kapMbWHDhixech1cAxihQGZI6SYp1mfufhKLxEJLrkiuRIROAyMqnq5k
         3C5u5ZM1qhA/gtFWou6vo9e5b5A1oc2DApLFxDGXuKDjZJWxiiDtOOSk6z0mVuCTW7
         inliokg6rVDxAOfcWyiLQIGcisyuy6jvtTut9gUa61D6Bl28uAP5kSR4dYu08GrLaI
         6Bo6WN0IY5BJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/98] vhost: Fix the calculation in vhost_overflow()
Date:   Tue, 24 Aug 2021 12:58:13 -0400
Message-Id: <20210824165908.709932-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit f7ad318ea0ad58ebe0e595e59aed270bb643b29b ]

This fixes the incorrect calculation for integer overflow
when the last address of iova range is 0xffffffff.

Fixes: ec33d031a14b ("vhost: detect 32 bit integer wrap around")
Reported-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20210728130756.97-2-xieyongji@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5ccb0705beae..f41463ab4031 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -735,10 +735,16 @@ static bool log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
 			 (sz + VHOST_PAGE_SIZE * 8 - 1) / VHOST_PAGE_SIZE / 8);
 }
 
+/* Make sure 64 bit math will not overflow. */
 static bool vhost_overflow(u64 uaddr, u64 size)
 {
-	/* Make sure 64 bit math will not overflow. */
-	return uaddr > ULONG_MAX || size > ULONG_MAX || uaddr > ULONG_MAX - size;
+	if (uaddr > ULONG_MAX || size > ULONG_MAX)
+		return true;
+
+	if (!size)
+		return false;
+
+	return uaddr > ULONG_MAX - size + 1;
 }
 
 /* Caller should have vq mutex and device mutex. */
-- 
2.30.2

