Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F38E50524A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbiDRMlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240884AbiDRMjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35095659C;
        Mon, 18 Apr 2022 05:31:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7D90B80ED6;
        Mon, 18 Apr 2022 12:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D42C385A7;
        Mon, 18 Apr 2022 12:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285083;
        bh=/jIivVQtkVAjSzFR552FfDtSGsQvx7FTbgfVC8vjH5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkigkyJz0/nDVJh6LYnA3ZHj0ecH9Jt/lVPCtNj8+3RlQWTGnVL9XW3rEm6dxvaXi
         f/onL35AcEeTbd1XiEqvZ89KYPtJ/ERhNl9JJPfkXJiyQrsIanK6YUb5j2ef8K1b8z
         MMPlEYtqWi+EI3z9y8juOWu2zVgz7DJ5sY9YFXfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/189] nfc: nci: add flush_workqueue to prevent uaf
Date:   Mon, 18 Apr 2022 14:11:59 +0200
Message-Id: <20220418121203.313992827@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit ef27324e2cb7bb24542d6cb2571740eefe6b00dc ]

Our detector found a concurrent use-after-free bug when detaching an
NCI device. The main reason for this bug is the unexpected scheduling
between the used delayed mechanism (timer and workqueue).

The race can be demonstrated below:

Thread-1                           Thread-2
                                 | nci_dev_up()
                                 |   nci_open_device()
                                 |     __nci_request(nci_reset_req)
                                 |       nci_send_cmd
                                 |         queue_work(cmd_work)
nci_unregister_device()          |
  nci_close_device()             | ...
    del_timer_sync(cmd_timer)[1] |
...                              | Worker
nci_free_device()                | nci_cmd_work()
  kfree(ndev)[3]                 |   mod_timer(cmd_timer)[2]

In short, the cleanup routine thought that the cmd_timer has already
been detached by [1] but the mod_timer can re-attach the timer [2], even
it is already released [3], resulting in UAF.

This UAF is easy to trigger, crash trace by POC is like below

[   66.703713] ==================================================================
[   66.703974] BUG: KASAN: use-after-free in enqueue_timer+0x448/0x490
[   66.703974] Write of size 8 at addr ffff888009fb7058 by task kworker/u4:1/33
[   66.703974]
[   66.703974] CPU: 1 PID: 33 Comm: kworker/u4:1 Not tainted 5.18.0-rc2 #5
[   66.703974] Workqueue: nfc2_nci_cmd_wq nci_cmd_work
[   66.703974] Call Trace:
[   66.703974]  <TASK>
[   66.703974]  dump_stack_lvl+0x57/0x7d
[   66.703974]  print_report.cold+0x5e/0x5db
[   66.703974]  ? enqueue_timer+0x448/0x490
[   66.703974]  kasan_report+0xbe/0x1c0
[   66.703974]  ? enqueue_timer+0x448/0x490
[   66.703974]  enqueue_timer+0x448/0x490
[   66.703974]  __mod_timer+0x5e6/0xb80
[   66.703974]  ? mark_held_locks+0x9e/0xe0
[   66.703974]  ? try_to_del_timer_sync+0xf0/0xf0
[   66.703974]  ? lockdep_hardirqs_on_prepare+0x17b/0x410
[   66.703974]  ? queue_work_on+0x61/0x80
[   66.703974]  ? lockdep_hardirqs_on+0xbf/0x130
[   66.703974]  process_one_work+0x8bb/0x1510
[   66.703974]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[   66.703974]  ? pwq_dec_nr_in_flight+0x230/0x230
[   66.703974]  ? rwlock_bug.part.0+0x90/0x90
[   66.703974]  ? _raw_spin_lock_irq+0x41/0x50
[   66.703974]  worker_thread+0x575/0x1190
[   66.703974]  ? process_one_work+0x1510/0x1510
[   66.703974]  kthread+0x2a0/0x340
[   66.703974]  ? kthread_complete_and_exit+0x20/0x20
[   66.703974]  ret_from_fork+0x22/0x30
[   66.703974]  </TASK>
[   66.703974]
[   66.703974] Allocated by task 267:
[   66.703974]  kasan_save_stack+0x1e/0x40
[   66.703974]  __kasan_kmalloc+0x81/0xa0
[   66.703974]  nci_allocate_device+0xd3/0x390
[   66.703974]  nfcmrvl_nci_register_dev+0x183/0x2c0
[   66.703974]  nfcmrvl_nci_uart_open+0xf2/0x1dd
[   66.703974]  nci_uart_tty_ioctl+0x2c3/0x4a0
[   66.703974]  tty_ioctl+0x764/0x1310
[   66.703974]  __x64_sys_ioctl+0x122/0x190
[   66.703974]  do_syscall_64+0x3b/0x90
[   66.703974]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   66.703974]
[   66.703974] Freed by task 406:
[   66.703974]  kasan_save_stack+0x1e/0x40
[   66.703974]  kasan_set_track+0x21/0x30
[   66.703974]  kasan_set_free_info+0x20/0x30
[   66.703974]  __kasan_slab_free+0x108/0x170
[   66.703974]  kfree+0xb0/0x330
[   66.703974]  nfcmrvl_nci_unregister_dev+0x90/0xd0
[   66.703974]  nci_uart_tty_close+0xdf/0x180
[   66.703974]  tty_ldisc_kill+0x73/0x110
[   66.703974]  tty_ldisc_hangup+0x281/0x5b0
[   66.703974]  __tty_hangup.part.0+0x431/0x890
[   66.703974]  tty_release+0x3a8/0xc80
[   66.703974]  __fput+0x1f0/0x8c0
[   66.703974]  task_work_run+0xc9/0x170
[   66.703974]  exit_to_user_mode_prepare+0x194/0x1a0
[   66.703974]  syscall_exit_to_user_mode+0x19/0x50
[   66.703974]  do_syscall_64+0x48/0x90
[   66.703974]  entry_SYSCALL_64_after_hwframe+0x44/0xae

To fix the UAF, this patch adds flush_workqueue() to ensure the
nci_cmd_work is finished before the following del_timer_sync.
This combination will promise the timer is actually detached.

Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index e41e2e9e5498..189c9f428a3c 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -560,6 +560,10 @@ static int nci_close_device(struct nci_dev *ndev)
 	mutex_lock(&ndev->req_lock);
 
 	if (!test_and_clear_bit(NCI_UP, &ndev->flags)) {
+		/* Need to flush the cmd wq in case
+		 * there is a queued/running cmd_work
+		 */
+		flush_workqueue(ndev->cmd_wq);
 		del_timer_sync(&ndev->cmd_timer);
 		del_timer_sync(&ndev->data_timer);
 		mutex_unlock(&ndev->req_lock);
-- 
2.35.1



