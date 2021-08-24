Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAA13F6710
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhHXRaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241423AbhHXR2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:28:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B32BB6140D;
        Tue, 24 Aug 2021 17:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824715;
        bh=kBjL9PWt2DDWaLImG39MR80jsxrkP3Qo92ZSGJ/vr7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kimKMDVbGRsgLEsPuBqTRX/MPUpyYJLorXX+MRFvuFsj21bKlIPFxHzKK5tl3Iz3o
         i39teDdkMczU1AMDwFSXawM2kNa1ed0Rv+XyGtPfUBHbNlBLlPDgQkZcrXCBt2ZmEK
         YlgrroIiQdSLu0N9ORMdSxKWVGhKcwrMGtof6PcpH6MnnxfDw2E5smNW+J57sv3Za8
         A18VUnlRbuYC5XY/q0Js0l/XOL38uYOeF9MyWViiq3v5zuf6ZK6NIrMTLoyVKVcuKX
         ZQIdH1+N7RlpEihPWWqCj1O5QMynASrevDylJp+iNF117QmFX5g2mpD3fF7tep4Bjc
         tDxP1d+BqdPaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/64] vsock/virtio: avoid potential deadlock when vsock device remove
Date:   Tue, 24 Aug 2021 13:04:10 -0400
Message-Id: <20210824170457.710623-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Longpeng(Mike)" <longpeng2@huawei.com>

[ Upstream commit 49b0b6ffe20c5344f4173f3436298782a08da4f2 ]

There's a potential deadlock case when remove the vsock device or
process the RESET event:

  vsock_for_each_connected_socket:
      spin_lock_bh(&vsock_table_lock) ----------- (1)
      ...
          virtio_vsock_reset_sock:
              lock_sock(sk) --------------------- (2)
      ...
      spin_unlock_bh(&vsock_table_lock)

lock_sock() may do initiative schedule when the 'sk' is owned by
other thread at the same time, we would receivce a warning message
that "scheduling while atomic".

Even worse, if the next task (selected by the scheduler) try to
release a 'sk', it need to request vsock_table_lock and the deadlock
occur, cause the system into softlockup state.
  Call trace:
   queued_spin_lock_slowpath
   vsock_remove_bound
   vsock_remove_sock
   virtio_transport_release
   __vsock_release
   vsock_release
   __sock_release
   sock_close
   __fput
   ____fput

So we should not require sk_lock in this case, just like the behavior
in vhost_vsock or vmci.

Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20210812053056.1699-1-longpeng2@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index cc70d651d13e..e34979fcefd2 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -373,11 +373,14 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
 
 static void virtio_vsock_reset_sock(struct sock *sk)
 {
-	lock_sock(sk);
+	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
+	 * under vsock_table_lock so the sock cannot disappear while we're
+	 * executing.
+	 */
+
 	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = ECONNRESET;
 	sk->sk_error_report(sk);
-	release_sock(sk);
 }
 
 static void virtio_vsock_update_guest_cid(struct virtio_vsock *vsock)
-- 
2.30.2

