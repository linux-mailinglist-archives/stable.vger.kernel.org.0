Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5705A594F98
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiHPEa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiHPEag (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:30:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D0515CE2C;
        Mon, 15 Aug 2022 13:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D1A7B81136;
        Mon, 15 Aug 2022 20:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B723C433D6;
        Mon, 15 Aug 2022 20:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594690;
        bh=ugN1MXcCApqALg9q87upT46qcpdfkj7zJELzLfbEAFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRFr5rfv1ohFX+XVBhaHCL1Wlfze8RkANP8VPfkkJI1Skan1p/nuFeMgQLCyalOba
         HdHYUx0FhR0VoIqIIyZVvkzepvnPoRPpUmi6I7LZ8LerCz9gSZjAhPCKPnTgtb9DPV
         tXI5FH28412pKG0yZEPGv2mpgUF88NTUBv28efBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+63bed493aebbf6872647@syzkaller.appspotmail.com,
        Schspa Shi <schspa@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0528/1157] Bluetooth: When HCI work queue is drained, only queue chained work
Date:   Mon, 15 Aug 2022 19:58:04 +0200
Message-Id: <20220815180500.780472691@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Schspa Shi <schspa@gmail.com>

[ Upstream commit 877afadad2dce8aae1f2aad8ce47e072d4f6165e ]

The HCI command, event, and data packet processing workqueue is drained
to avoid deadlock in commit
76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state").

There is another delayed work, which will queue command to this drained
workqueue. Which results in the following error report:

Bluetooth: hci2: command 0x040f tx timeout
WARNING: CPU: 1 PID: 18374 at kernel/workqueue.c:1438 __queue_work+0xdad/0x1140
Workqueue: events hci_cmd_timeout
RIP: 0010:__queue_work+0xdad/0x1140
RSP: 0000:ffffc90002cffc60 EFLAGS: 00010093
RAX: 0000000000000000 RBX: ffff8880b9d3ec00 RCX: 0000000000000000
RDX: ffff888024ba0000 RSI: ffffffff814e048d RDI: ffff8880b9d3ec08
RBP: 0000000000000008 R08: 0000000000000000 R09: 00000000b9d39700
R10: ffffffff814f73c6 R11: 0000000000000000 R12: ffff88807cce4c60
R13: 0000000000000000 R14: ffff8880796d8800 R15: ffff8880796d8800
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c0174b4000 CR3: 000000007cae9000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ? queue_work_on+0xcb/0x110
 ? lockdep_hardirqs_off+0x90/0xd0
 queue_work_on+0xee/0x110
 process_one_work+0x996/0x1610
 ? pwq_dec_nr_in_flight+0x2a0/0x2a0
 ? rwlock_bug.part.0+0x90/0x90
 ? _raw_spin_lock_irq+0x41/0x50
 worker_thread+0x665/0x1080
 ? process_one_work+0x1610/0x1610
 kthread+0x2e9/0x3a0
 ? kthread_complete_and_exit+0x40/0x40
 ret_from_fork+0x1f/0x30
 </TASK>

To fix this, we can add a new HCI_DRAIN_WQ flag, and don't queue the
timeout workqueue while command workqueue is draining.

Fixes: 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state")
Reported-by: syzbot+63bed493aebbf6872647@syzkaller.appspotmail.com
Signed-off-by: Schspa Shi <schspa@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_core.c    | 10 +++++++++-
 net/bluetooth/hci_event.c   |  5 +++--
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index fe7935be7dc4..4a45c48eb0d2 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -361,6 +361,7 @@ enum {
 	HCI_QUALITY_REPORT,
 	HCI_OFFLOAD_CODECS_ENABLED,
 	HCI_LE_SIMULTANEOUS_ROLES,
+	HCI_CMD_DRAIN_WORKQUEUE,
 
 	__HCI_NUM_FLAGS,
 };
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index a0f99baafd35..6a53bcc5cfbb 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -594,6 +594,11 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
 	skb_queue_purge(&hdev->rx_q);
 	skb_queue_purge(&hdev->cmd_q);
 
+	/* Cancel these to avoid queueing non-chained pending work */
+	hci_dev_set_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
+	cancel_delayed_work(&hdev->cmd_timer);
+	cancel_delayed_work(&hdev->ncmd_timer);
+
 	/* Avoid potential lockdep warnings from the *_flush() calls by
 	 * ensuring the workqueue is empty up front.
 	 */
@@ -607,6 +612,8 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
 	if (hdev->flush)
 		hdev->flush(hdev);
 
+	hci_dev_clear_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
+
 	atomic_set(&hdev->cmd_cnt, 1);
 	hdev->acl_cnt = 0; hdev->sco_cnt = 0; hdev->le_cnt = 0;
 
@@ -3864,7 +3871,8 @@ static void hci_cmd_work(struct work_struct *work)
 			if (res < 0)
 				__hci_cmd_sync_cancel(hdev, -res);
 
-			if (test_bit(HCI_RESET, &hdev->flags))
+			if (test_bit(HCI_RESET, &hdev->flags) ||
+			    hci_dev_test_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE))
 				cancel_delayed_work(&hdev->cmd_timer);
 			else
 				schedule_delayed_work(&hdev->cmd_timer,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index af17dfb20e01..7cb956d3abb2 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3768,8 +3768,9 @@ static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev, u8 ncmd)
 			cancel_delayed_work(&hdev->ncmd_timer);
 			atomic_set(&hdev->cmd_cnt, 1);
 		} else {
-			schedule_delayed_work(&hdev->ncmd_timer,
-					      HCI_NCMD_TIMEOUT);
+			if (!hci_dev_test_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE))
+				schedule_delayed_work(&hdev->ncmd_timer,
+						      HCI_NCMD_TIMEOUT);
 		}
 	}
 }
-- 
2.35.1



