Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E85E5F98FE
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiJJHFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiJJHEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:04:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A320052E61;
        Mon, 10 Oct 2022 00:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6069CB80E54;
        Mon, 10 Oct 2022 07:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8F1C433D6;
        Mon, 10 Oct 2022 07:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385464;
        bh=9TaVU9acwI902OnE6elPW0nf4T3kB68NpMHKm/VssLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1S8N2lZM53YkviKs/uF27Y3bYCEBFfelcclRChyrsmypg6sMF5KGBr77GpZUYaGoO
         aKHobOtsQrQlQcq7YcNxlR6a0fz8IecS/++4n8lmRZnpXqUMCCEzrc4KnMW3oEkdSL
         SWmCpds7fo/KchTH59m7fkN2Mw3lSdANM2loGi44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+243b7d89777f90f7613b@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.0 17/17] Bluetooth: use hdev->workqueue when queuing hdev->{cmd,ncmd}_timer works
Date:   Mon, 10 Oct 2022 09:04:40 +0200
Message-Id: <20221010070330.725277419@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
References: <20221010070330.159911806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit deee93d13d385103205879a8a0915036ecd83261 upstream.

syzbot is reporting attempt to schedule hdev->cmd_work work from system_wq
WQ into hdev->workqueue WQ which is under draining operation [1], for
commit c8efcc2589464ac7 ("workqueue: allow chained queueing during
destruction") does not allow such operation.

The check introduced by commit 877afadad2dce8aa ("Bluetooth: When HCI work
queue is drained, only queue chained work") was incomplete.

Use hdev->workqueue WQ when queuing hdev->{cmd,ncmd}_timer works because
hci_{cmd,ncmd}_timeout() calls queue_work(hdev->workqueue). Also, protect
the queuing operation with RCU read lock in order to avoid calling
queue_delayed_work() after cancel_delayed_work() completed.

Link: https://syzkaller.appspot.com/bug?extid=243b7d89777f90f7613b [1]
Reported-by: syzbot <syzbot+243b7d89777f90f7613b@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 877afadad2dce8aa ("Bluetooth: When HCI work queue is drained, only queue chained work")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c  |   15 +++++++++++++--
 net/bluetooth/hci_event.c |    6 ++++--
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -597,6 +597,15 @@ static int hci_dev_do_reset(struct hci_d
 
 	/* Cancel these to avoid queueing non-chained pending work */
 	hci_dev_set_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
+	/* Wait for
+	 *
+	 *    if (!hci_dev_test_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE))
+	 *        queue_delayed_work(&hdev->{cmd,ncmd}_timer)
+	 *
+	 * inside RCU section to see the flag or complete scheduling.
+	 */
+	synchronize_rcu();
+	/* Explicitly cancel works in case scheduled after setting the flag. */
 	cancel_delayed_work(&hdev->cmd_timer);
 	cancel_delayed_work(&hdev->ncmd_timer);
 
@@ -4056,12 +4065,14 @@ static void hci_cmd_work(struct work_str
 			if (res < 0)
 				__hci_cmd_sync_cancel(hdev, -res);
 
+			rcu_read_lock();
 			if (test_bit(HCI_RESET, &hdev->flags) ||
 			    hci_dev_test_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE))
 				cancel_delayed_work(&hdev->cmd_timer);
 			else
-				schedule_delayed_work(&hdev->cmd_timer,
-						      HCI_CMD_TIMEOUT);
+				queue_delayed_work(hdev->workqueue, &hdev->cmd_timer,
+						   HCI_CMD_TIMEOUT);
+			rcu_read_unlock();
 		} else {
 			skb_queue_head(&hdev->cmd_q, skb);
 			queue_work(hdev->workqueue, &hdev->cmd_work);
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3766,16 +3766,18 @@ static inline void handle_cmd_cnt_and_ti
 {
 	cancel_delayed_work(&hdev->cmd_timer);
 
+	rcu_read_lock();
 	if (!test_bit(HCI_RESET, &hdev->flags)) {
 		if (ncmd) {
 			cancel_delayed_work(&hdev->ncmd_timer);
 			atomic_set(&hdev->cmd_cnt, 1);
 		} else {
 			if (!hci_dev_test_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE))
-				schedule_delayed_work(&hdev->ncmd_timer,
-						      HCI_NCMD_TIMEOUT);
+				queue_delayed_work(hdev->workqueue, &hdev->ncmd_timer,
+						   HCI_NCMD_TIMEOUT);
 		}
 	}
+	rcu_read_unlock();
 }
 
 static u8 hci_cc_le_read_buffer_size_v2(struct hci_dev *hdev, void *data,


