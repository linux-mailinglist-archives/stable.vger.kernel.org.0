Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7E74F391D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377621AbiDEL3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351908AbiDEKD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:03:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284BD9858B;
        Tue,  5 Apr 2022 02:52:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83CCF61673;
        Tue,  5 Apr 2022 09:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960B8C385A2;
        Tue,  5 Apr 2022 09:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152351;
        bh=3QrwAnZrKDP0fVySNioupQGgjA6QCBXvVIXIl9fUcVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1941UjYwUjLbz1AOpkqPIShG1FSR4eewtLMf9KdiVb0RBJ07lGsj/Lfjb2Bbof8b
         UKnMfXSN4MiV8iG1BPzeqGp2o3YRC/0CfAhizdjtSn1Pogq45AH+vLy3YffAB8zmXj
         RhPumqe4pY+jb4c70jUTtVvP9odNoREL8ZnvKiHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Leech <cleech@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 707/913] nvme-tcp: lockdep: annotate in-kernel sockets
Date:   Tue,  5 Apr 2022 09:29:29 +0200
Message-Id: <20220405070401.027134404@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ef65d24639c4..10882d3d554c 100644
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
@@ -1436,6 +1474,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 		goto err_destroy_mutex;
 	}
 
+	nvme_tcp_reclassify_socket(queue->sock);
+
 	/* Single syn retry */
 	tcp_sock_set_syncnt(queue->sock->sk, 1);
 
-- 
2.34.1



