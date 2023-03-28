Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042836CC458
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbjC1PEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbjC1PEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:04:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482E3EC7E
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:02:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AC0F6181D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD04C433EF;
        Tue, 28 Mar 2023 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015757;
        bh=gavlMGtxXSwrJ/ohFz/ESjITzjNT/6pLtOqjllQPSKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8P8bOm84uJl1bZwXCIoojuZL+kS1IJFoYmky7fWAlkFAdBtMV2ccuPS3cvAhFWAs
         cLy/vhz9yYn+j6iAB64DUpRbOCq5iFk6A/K9ZXKkygHnTZoJUTuZTi4qkK5pn8GJsu
         CrhUW4ofIqZkKIvGQWkR4LJ3U7ZqT3QUYhtV8neA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Min Li <lm0963hack@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 165/224] Bluetooth: Fix race condition in hci_cmd_sync_clear
Date:   Tue, 28 Mar 2023 16:42:41 +0200
Message-Id: <20230328142624.250251738@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Min Li <lm0963hack@gmail.com>

commit 1c66bee492a5fe00ae3fe890bb693bfc99f994c6 upstream.

There is a potential race condition in hci_cmd_sync_work and
hci_cmd_sync_clear, and could lead to use-after-free. For instance,
hci_cmd_sync_work is added to the 'req_workqueue' after cancel_work_sync
The entry of 'cmd_sync_work_list' may be freed in hci_cmd_sync_clear, and
causing kernel panic when it is used in 'hci_cmd_sync_work'.

Here's the call trace:

dump_stack_lvl+0x49/0x63
print_report.cold+0x5e/0x5d3
? hci_cmd_sync_work+0x282/0x320
kasan_report+0xaa/0x120
? hci_cmd_sync_work+0x282/0x320
__asan_report_load8_noabort+0x14/0x20
hci_cmd_sync_work+0x282/0x320
process_one_work+0x77b/0x11c0
? _raw_spin_lock_irq+0x8e/0xf0
worker_thread+0x544/0x1180
? poll_idle+0x1e0/0x1e0
kthread+0x285/0x320
? process_one_work+0x11c0/0x11c0
? kthread_complete_and_exit+0x30/0x30
ret_from_fork+0x22/0x30
</TASK>

Allocated by task 266:
kasan_save_stack+0x26/0x50
__kasan_kmalloc+0xae/0xe0
kmem_cache_alloc_trace+0x191/0x350
hci_cmd_sync_queue+0x97/0x2b0
hci_update_passive_scan+0x176/0x1d0
le_conn_complete_evt+0x1b5/0x1a00
hci_le_conn_complete_evt+0x234/0x340
hci_le_meta_evt+0x231/0x4e0
hci_event_packet+0x4c5/0xf00
hci_rx_work+0x37d/0x880
process_one_work+0x77b/0x11c0
worker_thread+0x544/0x1180
kthread+0x285/0x320
ret_from_fork+0x22/0x30

Freed by task 269:
kasan_save_stack+0x26/0x50
kasan_set_track+0x25/0x40
kasan_set_free_info+0x24/0x40
____kasan_slab_free+0x176/0x1c0
__kasan_slab_free+0x12/0x20
slab_free_freelist_hook+0x95/0x1a0
kfree+0xba/0x2f0
hci_cmd_sync_clear+0x14c/0x210
hci_unregister_dev+0xff/0x440
vhci_release+0x7b/0xf0
__fput+0x1f3/0x970
____fput+0xe/0x20
task_work_run+0xd4/0x160
do_exit+0x8b0/0x22a0
do_group_exit+0xba/0x2a0
get_signal+0x1e4a/0x25b0
arch_do_signal_or_restart+0x93/0x1f80
exit_to_user_mode_prepare+0xf5/0x1a0
syscall_exit_to_user_mode+0x26/0x50
ret_from_fork+0x15/0x30

Fixes: 6a98e3836fa2 ("Bluetooth: Add helper for serialized HCI command execution")
Cc: stable@vger.kernel.org
Signed-off-by: Min Li <lm0963hack@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -643,6 +643,7 @@ void hci_cmd_sync_clear(struct hci_dev *
 	cancel_work_sync(&hdev->cmd_sync_work);
 	cancel_work_sync(&hdev->reenable_adv_work);
 
+	mutex_lock(&hdev->cmd_sync_work_lock);
 	list_for_each_entry_safe(entry, tmp, &hdev->cmd_sync_work_list, list) {
 		if (entry->destroy)
 			entry->destroy(hdev, entry->data, -ECANCELED);
@@ -650,6 +651,7 @@ void hci_cmd_sync_clear(struct hci_dev *
 		list_del(&entry->list);
 		kfree(entry);
 	}
+	mutex_unlock(&hdev->cmd_sync_work_lock);
 }
 
 void __hci_cmd_sync_cancel(struct hci_dev *hdev, int err)


