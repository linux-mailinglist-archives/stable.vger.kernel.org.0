Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D89B6CC411
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbjC1O7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbjC1O7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:59:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88CEEB50
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 889FAB81D68
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C929EC433EF;
        Tue, 28 Mar 2023 14:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015566;
        bh=p41CkkPmZW2j4bKb9Xnxz45L+bjCf0WowwuqH4CMj4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u36B/p0TDZ61XouZiwy0hRwlYG7XEvRDYQkNIlJEQf3ZHmDqQIqotmqt+2gUJYZBr
         FV0CV4kHmSwxnmZBHqpCGQibFQCNRKx1/4nhUjZmabcECqF17zn/kxVXBsUtGuihVd
         cnsM53pNYfmYTwV81z3z1O601e+GUEXsm0nq8pLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sungwoo Kim <iam@sung-woo.kim>,
        Simon Horman <simon.horman@corigine.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/224] Bluetooth: HCI: Fix global-out-of-bounds
Date:   Tue, 28 Mar 2023 16:41:32 +0200
Message-Id: <20230328142621.223518457@linuxfoundation.org>
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

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit bce56405201111807cc8e4f47c6de3e10b17c1ac ]

To loop a variable-length array, hci_init_stage_sync(stage) considers
that stage[i] is valid as long as stage[i-1].func is valid.
Thus, the last element of stage[].func should be intentionally invalid
as hci_init0[], le_init2[], and others did.
However, amp_init1[] and amp_init2[] have no invalid element, letting
hci_init_stage_sync() keep accessing amp_init1[] over its valid range.
This patch fixes this by adding {} in the last of amp_init1[] and
amp_init2[].

==================================================================
BUG: KASAN: global-out-of-bounds in hci_dev_open_sync (
/v6.2-bzimage/net/bluetooth/hci_sync.c:3154
/v6.2-bzimage/net/bluetooth/hci_sync.c:3343
/v6.2-bzimage/net/bluetooth/hci_sync.c:4418
/v6.2-bzimage/net/bluetooth/hci_sync.c:4609
/v6.2-bzimage/net/bluetooth/hci_sync.c:4689)
Read of size 8 at addr ffffffffaed1ab70 by task kworker/u5:0/1032
CPU: 0 PID: 1032 Comm: kworker/u5:0 Not tainted 6.2.0 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04
Workqueue: hci1 hci_power_on
Call Trace:
 <TASK>
dump_stack_lvl (/v6.2-bzimage/lib/dump_stack.c:107 (discriminator 1))
print_report (/v6.2-bzimage/mm/kasan/report.c:307
  /v6.2-bzimage/mm/kasan/report.c:417)
? hci_dev_open_sync (/v6.2-bzimage/net/bluetooth/hci_sync.c:3154
  /v6.2-bzimage/net/bluetooth/hci_sync.c:3343
  /v6.2-bzimage/net/bluetooth/hci_sync.c:4418
  /v6.2-bzimage/net/bluetooth/hci_sync.c:4609
  /v6.2-bzimage/net/bluetooth/hci_sync.c:4689)
kasan_report (/v6.2-bzimage/mm/kasan/report.c:184
  /v6.2-bzimage/mm/kasan/report.c:519)
? hci_dev_open_sync (/v6.2-bzimage/net/bluetooth/hci_sync.c:3154
  /v6.2-bzimage/net/bluetooth/hci_sync.c:3343
  /v6.2-bzimage/net/bluetooth/hci_sync.c:4418
  /v6.2-bzimage/net/bluetooth/hci_sync.c:4609
  /v6.2-bzimage/net/bluetooth/hci_sync.c:4689)
hci_dev_open_sync (/v6.2-bzimage/net/bluetooth/hci_sync.c:3154
  /v6.2-bzimage/net/bluetooth/hci_sync.c:3343
  /v6.2-bzimage/net/bluetooth/hci_sync.c:4418
  /v6.2-bzimage/net/bluetooth/hci_sync.c:4609
  /v6.2-bzimage/net/bluetooth/hci_sync.c:4689)
? __pfx_hci_dev_open_sync (/v6.2-bzimage/net/bluetooth/hci_sync.c:4635)
? mutex_lock (/v6.2-bzimage/./arch/x86/include/asm/atomic64_64.h:190
  /v6.2-bzimage/./include/linux/atomic/atomic-long.h:443
  /v6.2-bzimage/./include/linux/atomic/atomic-instrumented.h:1781
  /v6.2-bzimage/kernel/locking/mutex.c:171
  /v6.2-bzimage/kernel/locking/mutex.c:285)
? __pfx_mutex_lock (/v6.2-bzimage/kernel/locking/mutex.c:282)
hci_power_on (/v6.2-bzimage/net/bluetooth/hci_core.c:485
  /v6.2-bzimage/net/bluetooth/hci_core.c:984)
? __pfx_hci_power_on (/v6.2-bzimage/net/bluetooth/hci_core.c:969)
? read_word_at_a_time (/v6.2-bzimage/./include/asm-generic/rwonce.h:85)
? strscpy (/v6.2-bzimage/./arch/x86/include/asm/word-at-a-time.h:62
  /v6.2-bzimage/lib/string.c:161)
process_one_work (/v6.2-bzimage/kernel/workqueue.c:2294)
worker_thread (/v6.2-bzimage/./include/linux/list.h:292
  /v6.2-bzimage/kernel/workqueue.c:2437)
? __pfx_worker_thread (/v6.2-bzimage/kernel/workqueue.c:2379)
kthread (/v6.2-bzimage/kernel/kthread.c:376)
? __pfx_kthread (/v6.2-bzimage/kernel/kthread.c:331)
ret_from_fork (/v6.2-bzimage/arch/x86/entry/entry_64.S:314)
 </TASK>
The buggy address belongs to the variable:
amp_init1+0x30/0x60
The buggy address belongs to the physical page:
page:000000003a157ec6 refcount:1 mapcount:0 mapping:0000000000000000 ia
flags: 0x200000000001000(reserved|node=0|zone=2)
raw: 0200000000001000 ffffea0005054688 ffffea0005054688 000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffffffffaed1aa00: f9 f9 f9 f9 00 00 00 00 f9 f9 f9 f9 00 00 00 00
 ffffffffaed1aa80: 00 00 00 00 f9 f9 f9 f9 00 00 00 00 00 00 00 00
>ffffffffaed1ab00: 00 f9 f9 f9 f9 f9 f9 f9 00 00 00 00 00 00 f9 f9
                                                             ^
 ffffffffaed1ab80: f9 f9 f9 f9 00 00 00 00 f9 f9 f9 f9 00 00 00 f9
 ffffffffaed1ac00: f9 f9 f9 f9 00 06 f9 f9 f9 f9 f9 f9 00 00 02 f9

This bug is found by FuzzBT, a modified version of Syzkaller.
Other contributors for this bug are Ruoyu Wu and Peng Hui.

Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 13ec3c86a0dcf..f886c1d05c882 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3340,6 +3340,7 @@ static const struct hci_init_stage amp_init1[] = {
 	HCI_INIT(hci_read_flow_control_mode_sync),
 	/* HCI_OP_READ_LOCATION_DATA */
 	HCI_INIT(hci_read_location_data_sync),
+	{}
 };
 
 static int hci_init1_sync(struct hci_dev *hdev)
@@ -3374,6 +3375,7 @@ static int hci_init1_sync(struct hci_dev *hdev)
 static const struct hci_init_stage amp_init2[] = {
 	/* HCI_OP_READ_LOCAL_FEATURES */
 	HCI_INIT(hci_read_local_features_sync),
+	{}
 };
 
 /* Read Buffer Size (ACL mtu, max pkt, etc.) */
-- 
2.39.2



