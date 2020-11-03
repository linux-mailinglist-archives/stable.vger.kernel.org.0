Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864812A3910
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgKCBXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:23:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgKCBUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:20:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3EFA223EA;
        Tue,  3 Nov 2020 01:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366447;
        bh=fNHrt/GdcOtMrdpxZLIszplS2BMx/sgK37xpgdSdbCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dyO4UuiIP74n6/k3/L0QiwGw29/e/nNsinYK6kRi/0BJ9qamfU9lXlBy5Xa0duj+g
         4NvpJMBK3fFsgjOCslhijWFKZ6sW5af+2gb3B2osH1d7ybh4L6jICABTmYs//acDCj
         arCJBSVpewuD4oxpQAdqEDLBI/KqxtCY/Fwm128E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/11] blk-cgroup: Pre-allocate tree node on blkg_conf_prep
Date:   Mon,  2 Nov 2020 20:20:34 -0500
Message-Id: <20201103012039.183672-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103012039.183672-1-sashal@kernel.org>
References: <20201103012039.183672-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit f255c19b3ab46d3cad3b1b2e1036f4c926cb1d0c ]

Similarly to commit 457e490f2b741 ("blkcg: allocate struct blkcg_gq
outside request queue spinlock"), blkg_create can also trigger
occasional -ENOMEM failures at the radix insertion because any
allocation inside blkg_create has to be non-blocking, making it more
likely to fail.  This causes trouble for userspace tools trying to
configure io weights who need to deal with this condition.

This patch reduces the occurrence of -ENOMEMs on this path by preloading
the radix tree element on a GFP_KERNEL context, such that we guarantee
the later non-blocking insertion won't fail.

A similar solution exists in blkcg_init_queue for the same situation.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 51fc803c999d7..85bd46e0a745f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -876,6 +876,12 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto fail;
 		}
 
+		if (radix_tree_preload(GFP_KERNEL)) {
+			blkg_free(new_blkg);
+			ret = -ENOMEM;
+			goto fail;
+		}
+
 		rcu_read_lock();
 		spin_lock_irq(q->queue_lock);
 
@@ -883,7 +889,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		if (IS_ERR(blkg)) {
 			ret = PTR_ERR(blkg);
 			blkg_free(new_blkg);
-			goto fail_unlock;
+			goto fail_preloaded;
 		}
 
 		if (blkg) {
@@ -892,10 +898,12 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			blkg = blkg_create(pos, q, new_blkg);
 			if (unlikely(IS_ERR(blkg))) {
 				ret = PTR_ERR(blkg);
-				goto fail_unlock;
+				goto fail_preloaded;
 			}
 		}
 
+		radix_tree_preload_end();
+
 		if (pos == blkcg)
 			goto success;
 	}
@@ -905,6 +913,8 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	ctx->body = body;
 	return 0;
 
+fail_preloaded:
+	radix_tree_preload_end();
 fail_unlock:
 	spin_unlock_irq(q->queue_lock);
 	rcu_read_unlock();
-- 
2.27.0

