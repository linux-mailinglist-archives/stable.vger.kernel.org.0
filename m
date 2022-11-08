Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043406212D2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbiKHNnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbiKHNnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:43:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214DE43849
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:43:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFC6961596
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12A0C433D7;
        Tue,  8 Nov 2022 13:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667914985;
        bh=hpoqRqZ2+OtoVaTwfw1jt/6lQSnM3UbIuCg6tcdqj+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTBKE6RwPH0Hd1lcT2iTi1PpPCln2Tf00RPkrAoER7430jQRU3E24CwH39VklXXct
         tqzMVVLrk3hofEwXoQ5sl5KWPmFMnhm+zILNZMkHLcl0WlpnkAMZ+n2gHGxqDeKM+o
         8MtFJKqi2yZXKVMhtrotNxwQK69uS97Dlc3PbqyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/40] Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()
Date:   Tue,  8 Nov 2022 14:39:02 +0100
Message-Id: <20221108133329.053474988@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
References: <20221108133328.351887714@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 0d0e2d032811280b927650ff3c15fe5020e82533 ]

When l2cap_recv_frame() is invoked to receive data, and the cid is
L2CAP_CID_A2MP, if the channel does not exist, it will create a channel.
However, after a channel is created, the hold operation of the channel
is not performed. In this case, the value of channel reference counting
is 1. As a result, after hci_error_reset() is triggered, l2cap_conn_del()
invokes the close hook function of A2MP to release the channel. Then
 l2cap_chan_unlock(chan) will trigger UAF issue.

The process is as follows:
Receive data:
l2cap_data_channel()
    a2mp_channel_create()  --->channel ref is 2
    l2cap_chan_put()       --->channel ref is 1

Triger event:
    hci_error_reset()
        hci_dev_do_close()
        ...
        l2cap_disconn_cfm()
            l2cap_conn_del()
                l2cap_chan_hold()    --->channel ref is 2
                l2cap_chan_del()     --->channel ref is 1
                a2mp_chan_close_cb() --->channel ref is 0, release channel
                l2cap_chan_unlock()  --->UAF of channel

The detailed Call Trace is as follows:
BUG: KASAN: use-after-free in __mutex_unlock_slowpath+0xa6/0x5e0
Read of size 8 at addr ffff8880160664b8 by task kworker/u11:1/7593
Workqueue: hci0 hci_error_reset
Call Trace:
 <TASK>
 dump_stack_lvl+0xcd/0x134
 print_report.cold+0x2ba/0x719
 kasan_report+0xb1/0x1e0
 kasan_check_range+0x140/0x190
 __mutex_unlock_slowpath+0xa6/0x5e0
 l2cap_conn_del+0x404/0x7b0
 l2cap_disconn_cfm+0x8c/0xc0
 hci_conn_hash_flush+0x11f/0x260
 hci_dev_close_sync+0x5f5/0x11f0
 hci_dev_do_close+0x2d/0x70
 hci_error_reset+0x9e/0x140
 process_one_work+0x98a/0x1620
 worker_thread+0x665/0x1080
 kthread+0x2e4/0x3a0
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 7593:
 kasan_save_stack+0x1e/0x40
 __kasan_kmalloc+0xa9/0xd0
 l2cap_chan_create+0x40/0x930
 amp_mgr_create+0x96/0x990
 a2mp_channel_create+0x7d/0x150
 l2cap_recv_frame+0x51b8/0x9a70
 l2cap_recv_acldata+0xaa3/0xc00
 hci_rx_work+0x702/0x1220
 process_one_work+0x98a/0x1620
 worker_thread+0x665/0x1080
 kthread+0x2e4/0x3a0
 ret_from_fork+0x1f/0x30

Freed by task 7593:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_set_free_info+0x20/0x30
 ____kasan_slab_free+0x167/0x1c0
 slab_free_freelist_hook+0x89/0x1c0
 kfree+0xe2/0x580
 l2cap_chan_put+0x22a/0x2d0
 l2cap_conn_del+0x3fc/0x7b0
 l2cap_disconn_cfm+0x8c/0xc0
 hci_conn_hash_flush+0x11f/0x260
 hci_dev_close_sync+0x5f5/0x11f0
 hci_dev_do_close+0x2d/0x70
 hci_error_reset+0x9e/0x140
 process_one_work+0x98a/0x1620
 worker_thread+0x665/0x1080
 kthread+0x2e4/0x3a0
 ret_from_fork+0x1f/0x30

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40
 __kasan_record_aux_stack+0xbe/0xd0
 call_rcu+0x99/0x740
 netlink_release+0xe6a/0x1cf0
 __sock_release+0xcd/0x280
 sock_close+0x18/0x20
 __fput+0x27c/0xa90
 task_work_run+0xdd/0x1a0
 exit_to_user_mode_prepare+0x23c/0x250
 syscall_exit_to_user_mode+0x19/0x50
 do_syscall_64+0x42/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x40
 __kasan_record_aux_stack+0xbe/0xd0
 call_rcu+0x99/0x740
 netlink_release+0xe6a/0x1cf0
 __sock_release+0xcd/0x280
 sock_close+0x18/0x20
 __fput+0x27c/0xa90
 task_work_run+0xdd/0x1a0
 exit_to_user_mode_prepare+0x23c/0x250
 syscall_exit_to_user_mode+0x19/0x50
 do_syscall_64+0x42/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: d0be8347c623 ("Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 35c04727ddc0..c86bd574bdd8 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6967,6 +6967,7 @@ static void l2cap_data_channel(struct l2cap_conn *conn, u16 cid,
 				return;
 			}
 
+			l2cap_chan_hold(chan);
 			l2cap_chan_lock(chan);
 		} else {
 			BT_DBG("unknown cid 0x%4.4x", cid);
-- 
2.35.1



