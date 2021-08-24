Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2F23F66A7
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbhHXR0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240789AbhHXRYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB13761B2C;
        Tue, 24 Aug 2021 17:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824631;
        bh=mJepXQhLwDqv4pWllIIXeMlJFtNrcNyRqkUPQzvF6aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyjms0P4y11c5wyxAnXAeH2XE+Pb2zFPzJY4FGpLY3Bz6B0lTtovWcRzMes4JmVip
         p8R+FqO5Ln1CAgyiU5p4AQkn0pPFMfcCp3WRi1j8k2kg8fREwM61GA3zDTZDDg3TaF
         dcHzip3wd6ojLnBqfh9uYJzNjP4VCW7sNO9j0p8DyC13mWLBUPJoLv2E8R2+BiqLLw
         VlMZZPJGR0rHlMkJAQGyaxOAf96MVWTiSIYrMw7RITXxx9SsMkrHRdVQ+iM/T+JIAW
         AF+mmUl8HAyXvQl2IuSDRk2/DMJxUg/lQQwJQO667H5YpbEBEEc3SbCDMeoAtDl+OY
         FVTrA+JBGiPMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 62/84] vhost: Fix the calculation in vhost_overflow()
Date:   Tue, 24 Aug 2021 13:02:28 -0400
Message-Id: <20210824170250.710392-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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
index 732327756ee1..7a58f629155d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -678,10 +678,16 @@ static bool log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
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

