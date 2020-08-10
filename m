Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F312408FC
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgHJP1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbgHJP1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:27:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8B1A22B47;
        Mon, 10 Aug 2020 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073264;
        bh=un7zhe35iB5O7wWshqcS9w6y1MdzU0o5XKOhS/qQX6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmgVaz30MT3YyxTNjqcOsUxg8/Y0A/ylChxFxcLrFDrD9Gqfy7RcbcZgoM09Gf7Xb
         MhaDPskKpYwh59OatdJ58ZOVE8bFwWDjU/elKVmOKS5XTpAbcXNTNCsAvmEyfHA2FW
         go/3a8zZFHvILGw0lBi8zL0J2v2QzQN/PsCRCmjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/67] igb: reinit_locked() should be called with rtnl_lock
Date:   Mon, 10 Aug 2020 17:21:30 +0200
Message-Id: <20200810151811.567105484@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Ruggeri <fruggeri@arista.com>

[ Upstream commit 024a8168b749db7a4aa40a5fbdfa04bf7e77c1c0 ]

We observed two panics involving races with igb_reset_task.
The first panic is caused by this race condition:

	kworker			reboot -f

	igb_reset_task
	igb_reinit_locked
	igb_down
	napi_synchronize
				__igb_shutdown
				igb_clear_interrupt_scheme
				igb_free_q_vectors
				igb_free_q_vector
				adapter->q_vector[v_idx] = NULL;
	napi_disable
	Panics trying to access
	adapter->q_vector[v_idx].napi_state

The second panic (a divide error) is caused by this race:

kworker		reboot -f	tx packet

igb_reset_task
		__igb_shutdown
		rtnl_lock()
		...
		igb_clear_interrupt_scheme
		igb_free_q_vectors
		adapter->num_tx_queues = 0
		...
		rtnl_unlock()
rtnl_lock()
igb_reinit_locked
igb_down
igb_up
netif_tx_start_all_queues
				dev_hard_start_xmit
				igb_xmit_frame
				igb_tx_queue_mapping
				Panics on
				r_idx % adapter->num_tx_queues

This commit applies to igb_reset_task the same changes that
were applied to ixgbe in commit 2f90b8657ec9 ("ixgbe: this patch
adds support for DCB to the kernel and ixgbe driver"),
commit 8f4c5c9fb87a ("ixgbe: reinit_locked() should be called with
rtnl_lock") and commit 88adce4ea8f9 ("ixgbe: fix possible race in
reset subtask").

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index ed7e667d7eb29..3e41b20ed8eb5 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6194,9 +6194,18 @@ static void igb_reset_task(struct work_struct *work)
 	struct igb_adapter *adapter;
 	adapter = container_of(work, struct igb_adapter, reset_task);
 
+	rtnl_lock();
+	/* If we're already down or resetting, just bail */
+	if (test_bit(__IGB_DOWN, &adapter->state) ||
+	    test_bit(__IGB_RESETTING, &adapter->state)) {
+		rtnl_unlock();
+		return;
+	}
+
 	igb_dump(adapter);
 	netdev_err(adapter->netdev, "Reset adapter\n");
 	igb_reinit_locked(adapter);
+	rtnl_unlock();
 }
 
 /**
-- 
2.25.1



