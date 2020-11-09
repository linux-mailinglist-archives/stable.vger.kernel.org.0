Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60342ABB77
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732166AbgKINNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:13:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731621AbgKINNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:13:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB26E2083B;
        Mon,  9 Nov 2020 13:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927621;
        bh=hdqDq+TaiDRElSCvu1+PkOkwPfGZkN6dKoBDHWd73AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9lvuKH3KMAJR0oMEH5qCyigKb3ozIOLKNA827KbRTMF0sotZs12qZSzbKNQnYUuI
         ZoKiZagQwgfIBXS9AHQ/IEqlaHsFlGAuJ2X40FQrI2Wez6QrtOMDP9iS+COf8lvMLz
         QttqSEfM+F4QHlC4Qi0XjxJBUtQSHAlgxlj9wt0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 50/85] blk-cgroup: Pre-allocate tree node on blkg_conf_prep
Date:   Mon,  9 Nov 2020 13:55:47 +0100
Message-Id: <20201109125024.984972318@linuxfoundation.org>
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
index a4793cfb68f28..3d34ac02d76ef 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -855,6 +855,12 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto fail;
 		}
 
+		if (radix_tree_preload(GFP_KERNEL)) {
+			blkg_free(new_blkg);
+			ret = -ENOMEM;
+			goto fail;
+		}
+
 		rcu_read_lock();
 		spin_lock_irq(&q->queue_lock);
 
@@ -862,7 +868,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		if (IS_ERR(blkg)) {
 			ret = PTR_ERR(blkg);
 			blkg_free(new_blkg);
-			goto fail_unlock;
+			goto fail_preloaded;
 		}
 
 		if (blkg) {
@@ -871,10 +877,12 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			blkg = blkg_create(pos, q, new_blkg);
 			if (IS_ERR(blkg)) {
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
@@ -884,6 +892,8 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	ctx->body = input;
 	return 0;
 
+fail_preloaded:
+	radix_tree_preload_end();
 fail_unlock:
 	spin_unlock_irq(&q->queue_lock);
 	rcu_read_unlock();
-- 
2.27.0



