Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD73420F84
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237923AbhJDNfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237926AbhJDNd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:33:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB63161BD1;
        Mon,  4 Oct 2021 13:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353314;
        bh=PVQxchNJYVmgCOmwM3J2JXorZwGMXhX/490UHVjdzv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQOHPlPMRXgMRbRAY0Df2l+DyZr42JmtElR7JiYoeIZuZPNWBFkcXC7RxoNWs4yt5
         QuLTL1GaRXSYbHh4PWKF+gbGGvtfyWsFHbmIC+jB5pcqDQx/H28dlnI5/6ZaiPRRkY
         TGm8I4gHqUbZcBOFc7O3pOu3oS85L6PvnHibkSr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Liu <thomas.liu@ucloud.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 079/172] RDMA/cma: Fix listener leak in rdma_cma_listen_on_all() failure
Date:   Mon,  4 Oct 2021 14:52:09 +0200
Message-Id: <20211004125047.547112539@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Liu <thomas.liu@ucloud.cn>

[ Upstream commit ca465e1f1f9b38fe916a36f7d80c5d25f2337c81 ]

If cma_listen_on_all() fails it leaves the per-device ID still on the
listen_list but the state is not set to RDMA_CM_ADDR_BOUND.

When the cmid is eventually destroyed cma_cancel_listens() is not called
due to the wrong state, however the per-device IDs are still holding the
refcount preventing the ID from being destroyed, thus deadlocking:

 task:rping state:D stack:   0 pid:19605 ppid: 47036 flags:0x00000084
 Call Trace:
  __schedule+0x29a/0x780
  ? free_unref_page_commit+0x9b/0x110
  schedule+0x3c/0xa0
  schedule_timeout+0x215/0x2b0
  ? __flush_work+0x19e/0x1e0
  wait_for_completion+0x8d/0xf0
  _destroy_id+0x144/0x210 [rdma_cm]
  ucma_close_id+0x2b/0x40 [rdma_ucm]
  __destroy_id+0x93/0x2c0 [rdma_ucm]
  ? __xa_erase+0x4a/0xa0
  ucma_destroy_id+0x9a/0x120 [rdma_ucm]
  ucma_write+0xb8/0x130 [rdma_ucm]
  vfs_write+0xb4/0x250
  ksys_write+0xb5/0xd0
  ? syscall_trace_enter.isra.19+0x123/0x190
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Ensure that cma_listen_on_all() atomically unwinds its action under the
lock during error.

Fixes: c80a0c52d85c ("RDMA/cma: Add missing error handling of listen_id")
Link: https://lore.kernel.org/r/20210913093344.17230-1-thomas.liu@ucloud.cn
Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 107462905b21..dbbacc8e9273 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1746,15 +1746,16 @@ static void cma_cancel_route(struct rdma_id_private *id_priv)
 	}
 }
 
-static void cma_cancel_listens(struct rdma_id_private *id_priv)
+static void _cma_cancel_listens(struct rdma_id_private *id_priv)
 {
 	struct rdma_id_private *dev_id_priv;
 
+	lockdep_assert_held(&lock);
+
 	/*
 	 * Remove from listen_any_list to prevent added devices from spawning
 	 * additional listen requests.
 	 */
-	mutex_lock(&lock);
 	list_del(&id_priv->list);
 
 	while (!list_empty(&id_priv->listen_list)) {
@@ -1768,6 +1769,12 @@ static void cma_cancel_listens(struct rdma_id_private *id_priv)
 		rdma_destroy_id(&dev_id_priv->id);
 		mutex_lock(&lock);
 	}
+}
+
+static void cma_cancel_listens(struct rdma_id_private *id_priv)
+{
+	mutex_lock(&lock);
+	_cma_cancel_listens(id_priv);
 	mutex_unlock(&lock);
 }
 
@@ -2587,7 +2594,7 @@ static int cma_listen_on_all(struct rdma_id_private *id_priv)
 	return 0;
 
 err_listen:
-	list_del(&id_priv->list);
+	_cma_cancel_listens(id_priv);
 	mutex_unlock(&lock);
 	if (to_destroy)
 		rdma_destroy_id(&to_destroy->id);
-- 
2.33.0



