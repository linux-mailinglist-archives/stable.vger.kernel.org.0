Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912A1330E6A
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhCHMg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232381AbhCHMgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDEB1651D3;
        Mon,  8 Mar 2021 12:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206994;
        bh=3jMa1XUs5vB9tet2aTawrtlcbJyzFB4dTvKANC6xzPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxvCRr9015Iget7Xnq4maHTIpCc0Ya/9/a4okT1u+/rz9dlXhwwxDPo10RGjq6cJW
         iJN0h9eVbDfJOyB/o6kAz035L5/bnjYQdwz33viJMDE/8nGiHWeazrbuWInhwtPbaG
         MmjYCPjzcQoV2alwHQerO4BtsgIqmgrVzyNI8qJU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 32/44] RDMA/cm: Fix IRQ restore in ib_send_cm_sidr_rep
Date:   Mon,  8 Mar 2021 13:35:10 +0100
Message-Id: <20210308122720.124746072@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 221384df6123747d2a75517dd06cc01752f81518 ]

ib_send_cm_sidr_rep() {
	spin_lock_irqsave()
        cm_send_sidr_rep_locked() {
                ...
        	spin_lock_irq()
                ....
                spin_unlock_irq() <--- this will enable interrupts
        }
        spin_unlock_irqrestore()
}

spin_unlock_irqrestore() expects interrupts to be disabled but the
internal spin_unlock_irq() will always enable hard interrupts.

Fix this by replacing the internal spin_{lock,unlock}_irq() with
irqsave/restore variants.

It fixes the following kernel trace:

 raw_local_irq_restore() called with IRQs enabled
 WARNING: CPU: 2 PID: 20001 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20

 Call Trace:
  _raw_spin_unlock_irqrestore+0x4e/0x50
  ib_send_cm_sidr_rep+0x3a/0x50 [ib_cm]
  cma_send_sidr_rep+0xa1/0x160 [rdma_cm]
  rdma_accept+0x25e/0x350 [rdma_cm]
  ucma_accept+0x132/0x1cc [rdma_ucm]
  ucma_write+0xbf/0x140 [rdma_ucm]
  vfs_write+0xc1/0x340
  ksys_write+0xb3/0xe0
  do_syscall_64+0x2d/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 87c4c774cbef ("RDMA/cm: Protect access to remote_sidr_table")
Link: https://lore.kernel.org/r/20210301081844.445823-1-leon@kernel.org
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index be996dba040c..3d194bb60840 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3651,6 +3651,7 @@ static int cm_send_sidr_rep_locked(struct cm_id_private *cm_id_priv,
 				   struct ib_cm_sidr_rep_param *param)
 {
 	struct ib_mad_send_buf *msg;
+	unsigned long flags;
 	int ret;
 
 	lockdep_assert_held(&cm_id_priv->lock);
@@ -3676,12 +3677,12 @@ static int cm_send_sidr_rep_locked(struct cm_id_private *cm_id_priv,
 		return ret;
 	}
 	cm_id_priv->id.state = IB_CM_IDLE;
-	spin_lock_irq(&cm.lock);
+	spin_lock_irqsave(&cm.lock, flags);
 	if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node)) {
 		rb_erase(&cm_id_priv->sidr_id_node, &cm.remote_sidr_table);
 		RB_CLEAR_NODE(&cm_id_priv->sidr_id_node);
 	}
-	spin_unlock_irq(&cm.lock);
+	spin_unlock_irqrestore(&cm.lock, flags);
 	return 0;
 }
 
-- 
2.30.1



