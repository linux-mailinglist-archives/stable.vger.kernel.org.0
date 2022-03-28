Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348844E9462
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240751AbiC1L22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241129AbiC1L0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:26:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB6F6465;
        Mon, 28 Mar 2022 04:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AC73B80EAE;
        Mon, 28 Mar 2022 11:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FBDC340F3;
        Mon, 28 Mar 2022 11:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466623;
        bh=o8wKoUb2M1W9qRi7fF9bUG326XYmoANmb7pml3OIOJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqD6TG5mFILsV+gHm6E8NqwZ+JgopOgkCxlpvD+kg9wqAsOO9ZdnSuEpEVIOS36Gl
         YUQ0LWUulJptUw5mSPDEHiQW/Xc4Wr+uF7rBe1AqH3m2/nBkKDtA1IRzqobYpcIoWu
         DOTJ4CTmO4aEwQiWfYpi5ndmh0rQLt2Vu7kiyoq1gU6a3c4nxWAazU+Y1rY4LMivEJ
         HiW7zhWfBU5BUMNFAJ7oYUS9YIAtSsgHgtMIPkEZokr1GYnGzFfwUvf6y+8Cmnzpco
         89jxxLpMezEW/0V2rD84sXMW144v2KxcqSM2yGMzH/iM6+2HDjTGZdW/SBisVc9AzY
         RMq0oePxpWXQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Leech <cleech@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 20/21] nvme-tcp: lockdep: annotate in-kernel sockets
Date:   Mon, 28 Mar 2022 07:22:53 -0400
Message-Id: <20220328112254.1556286-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112254.1556286-1-sashal@kernel.org>
References: <20220328112254.1556286-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Leech <cleech@redhat.com>

[ Upstream commit 841aee4d75f18fdfb53935080b03de0c65e9b92c ]

Put NVMe/TCP sockets in their own class to avoid some lockdep warnings.
Sockets created by nvme-tcp are not exposed to user-space, and will not
trigger certain code paths that the general socket API exposes.

Lockdep complains about a circular dependency between the socket and
filesystem locks, because setsockopt can trigger a page fault with a
socket lock held, but nvme-tcp sends requests on the socket while file
system locks are held.

  ======================================================
  WARNING: possible circular locking dependency detected
  5.15.0-rc3 #1 Not tainted
  ------------------------------------------------------
  fio/1496 is trying to acquire lock:
  (sk_lock-AF_INET){+.+.}-{0:0}, at: tcp_sendpage+0x23/0x80

  but task is already holding lock:
  (&xfs_dir_ilock_class/5){+.+.}-{3:3}, at: xfs_ilock+0xcf/0x290 [xfs]

  which lock already depends on the new lock.

  other info that might help us debug this:

  chain exists of:
   sk_lock-AF_INET --> sb_internal --> &xfs_dir_ilock_class/5

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&xfs_dir_ilock_class/5);
                                lock(sb_internal);
                                lock(&xfs_dir_ilock_class/5);
   lock(sk_lock-AF_INET);

  *** DEADLOCK ***

  6 locks held by fio/1496:
   #0: (sb_writers#13){.+.+}-{0:0}, at: path_openat+0x9fc/0xa20
   #1: (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{3:3}, at: path_openat+0x296/0xa20
   #2: (sb_internal){.+.+}-{0:0}, at: xfs_trans_alloc_icreate+0x41/0xd0 [xfs]
   #3: (&xfs_dir_ilock_class/5){+.+.}-{3:3}, at: xfs_ilock+0xcf/0x290 [xfs]
   #4: (hctx->srcu){....}-{0:0}, at: hctx_lock+0x51/0xd0
   #5: (&queue->send_mutex){+.+.}-{3:3}, at: nvme_tcp_queue_rq+0x33e/0x380 [nvme_tcp]

This annotation lets lockdep analyze nvme-tcp controlled sockets
independently of what the user-space sockets API does.

Link: https://lore.kernel.org/linux-nvme/CAHj4cs9MDYLJ+q+2_GXUK9HxFizv2pxUryUR0toX974M040z7g@mail.gmail.com/

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 6105894a218a..7e3932033707 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -30,6 +30,44 @@ static int so_priority;
 module_param(so_priority, int, 0644);
 MODULE_PARM_DESC(so_priority, "nvme tcp socket optimize priority");
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+/* lockdep can detect a circular dependency of the form
+ *   sk_lock -> mmap_lock (page fault) -> fs locks -> sk_lock
+ * because dependencies are tracked for both nvme-tcp and user contexts. Using
+ * a separate class prevents lockdep from conflating nvme-tcp socket use with
+ * user-space socket API use.
+ */
+static struct lock_class_key nvme_tcp_sk_key[2];
+static struct lock_class_key nvme_tcp_slock_key[2];
+
+static void nvme_tcp_reclassify_socket(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+
+	if (WARN_ON_ONCE(!sock_allow_reclassification(sk)))
+		return;
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		sock_lock_init_class_and_name(sk, "slock-AF_INET-NVME",
+					      &nvme_tcp_slock_key[0],
+					      "sk_lock-AF_INET-NVME",
+					      &nvme_tcp_sk_key[0]);
+		break;
+	case AF_INET6:
+		sock_lock_init_class_and_name(sk, "slock-AF_INET6-NVME",
+					      &nvme_tcp_slock_key[1],
+					      "sk_lock-AF_INET6-NVME",
+					      &nvme_tcp_sk_key[1]);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+#else
+static void nvme_tcp_reclassify_socket(struct socket *sock) { }
+#endif
+
 enum nvme_tcp_send_state {
 	NVME_TCP_SEND_CMD_PDU = 0,
 	NVME_TCP_SEND_H2C_PDU,
@@ -1422,6 +1460,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 		goto err_destroy_mutex;
 	}
 
+	nvme_tcp_reclassify_socket(queue->sock);
+
 	/* Single syn retry */
 	tcp_sock_set_syncnt(queue->sock->sk, 1);
 
-- 
2.34.1

