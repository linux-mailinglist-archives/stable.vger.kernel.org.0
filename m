Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74273F65B4
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbhHXRPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240020AbhHXROE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:14:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16AF061A85;
        Tue, 24 Aug 2021 17:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824496;
        bh=/zQUevulHb0NrGk5H2gZ5uZnKv594z6cVqOWzxN7o5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzZrnhMGWCOagb0gZk1klhkW1OZn+EvPlHUCbOL+MRotwdkJtulS3XiFUXIwCHlqb
         R9EFgHURT265Ej5xhbc/hXIYqawpYKlBpQFbA945yH/T0PwXiMzHBnm51HaAR7gAZr
         gMRlTTEPeAj4S01+bDB9HMBBFaneJR4vt3H8tfSe/ZEXIPv8KQwCychyn0I2ra/C1P
         XdvpKmugy+g1E6iZDXOnknNyBbbPjXMT5Fc5YXEP0iiLCWHNq6omcLpf6LXk4KqCFb
         VPCW0t8MauDsCR9VEGJV3et4mNgYM/s2EKmeO2Kg53OtGTUywT6UwYAlf7D+JayA19
         R9Z6tC8I+3F1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/61] vhost: Fix the calculation in vhost_overflow()
Date:   Tue, 24 Aug 2021 13:00:34 -0400
Message-Id: <20210824170106.710221-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index a279ecacbf60..97be299f0a8d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -702,10 +702,16 @@ static bool log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
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

