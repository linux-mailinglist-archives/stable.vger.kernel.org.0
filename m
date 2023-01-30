Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D17C681154
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbjA3OMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237263AbjA3OMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:12:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AF03BD96
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:12:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A783A61083
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8D6C433D2;
        Mon, 30 Jan 2023 14:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087924;
        bh=sHbuAB0xGBrgYdyYET4QwZFnaRR2w4lZrI2uMAAPQ7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJ9SFfl0eXlLyaeQHUlTwmRBrZfHDc6gAugO/rxm5nhuSZ/1GFbodTshI5heVwLtD
         Ivm9+r89kChWPOUKcr8/c4rpYHSB1PxEo009e+ZYoILfKEaxbpCEEO1WGiRiNnSSMV
         Ghnk8iq2ifxmFjJZikw+m9bJrxQpi2Z3zpkjMLYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jisoo Jang <jisoo.jang@yonsei.ac.kr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/204] net: nfc: Fix use-after-free in local_cleanup()
Date:   Mon, 30 Jan 2023 14:50:03 +0100
Message-Id: <20230130134317.982590888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisoo Jang <jisoo.jang@yonsei.ac.kr>

[ Upstream commit 4bb4db7f3187c6e3de6b229ffc87cdb30a2d22b6 ]

Fix a use-after-free that occurs in kfree_skb() called from
local_cleanup(). This could happen when killing nfc daemon (e.g. neard)
after detaching an nfc device.
When detaching an nfc device, local_cleanup() called from
nfc_llcp_unregister_device() frees local->rx_pending and decreases
local->ref by kref_put() in nfc_llcp_local_put().
In the terminating process, nfc daemon releases all sockets and it leads
to decreasing local->ref. After the last release of local->ref,
local_cleanup() called from local_release() frees local->rx_pending
again, which leads to the bug.

Setting local->rx_pending to NULL in local_cleanup() could prevent
use-after-free when local_cleanup() is called twice.

Found by a modified version of syzkaller.

BUG: KASAN: use-after-free in kfree_skb()

Call Trace:
dump_stack_lvl (lib/dump_stack.c:106)
print_address_description.constprop.0.cold (mm/kasan/report.c:306)
kasan_check_range (mm/kasan/generic.c:189)
kfree_skb (net/core/skbuff.c:955)
local_cleanup (net/nfc/llcp_core.c:159)
nfc_llcp_local_put.part.0 (net/nfc/llcp_core.c:172)
nfc_llcp_local_put (net/nfc/llcp_core.c:181)
llcp_sock_destruct (net/nfc/llcp_sock.c:959)
__sk_destruct (net/core/sock.c:2133)
sk_destruct (net/core/sock.c:2181)
__sk_free (net/core/sock.c:2192)
sk_free (net/core/sock.c:2203)
llcp_sock_release (net/nfc/llcp_sock.c:646)
__sock_release (net/socket.c:650)
sock_close (net/socket.c:1365)
__fput (fs/file_table.c:306)
task_work_run (kernel/task_work.c:179)
ptrace_notify (kernel/signal.c:2354)
syscall_exit_to_user_mode_prepare (kernel/entry/common.c:278)
syscall_exit_to_user_mode (kernel/entry/common.c:296)
do_syscall_64 (arch/x86/entry/common.c:86)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:106)

Allocated by task 4719:
kasan_save_stack (mm/kasan/common.c:45)
__kasan_slab_alloc (mm/kasan/common.c:325)
slab_post_alloc_hook (mm/slab.h:766)
kmem_cache_alloc_node (mm/slub.c:3497)
__alloc_skb (net/core/skbuff.c:552)
pn533_recv_response (drivers/nfc/pn533/usb.c:65)
__usb_hcd_giveback_urb (drivers/usb/core/hcd.c:1671)
usb_giveback_urb_bh (drivers/usb/core/hcd.c:1704)
tasklet_action_common.isra.0 (kernel/softirq.c:797)
__do_softirq (kernel/softirq.c:571)

Freed by task 1901:
kasan_save_stack (mm/kasan/common.c:45)
kasan_set_track (mm/kasan/common.c:52)
kasan_save_free_info (mm/kasan/genericdd.c:518)
__kasan_slab_free (mm/kasan/common.c:236)
kmem_cache_free (mm/slub.c:3809)
kfree_skbmem (net/core/skbuff.c:874)
kfree_skb (net/core/skbuff.c:931)
local_cleanup (net/nfc/llcp_core.c:159)
nfc_llcp_unregister_device (net/nfc/llcp_core.c:1617)
nfc_unregister_device (net/nfc/core.c:1179)
pn53x_unregister_nfc (drivers/nfc/pn533/pn533.c:2846)
pn533_usb_disconnect (drivers/nfc/pn533/usb.c:579)
usb_unbind_interface (drivers/usb/core/driver.c:458)
device_release_driver_internal (drivers/base/dd.c:1279)
bus_remove_device (drivers/base/bus.c:529)
device_del (drivers/base/core.c:3665)
usb_disable_device (drivers/usb/core/message.c:1420)
usb_disconnect (drivers/usb/core.c:2261)
hub_event (drivers/usb/core/hub.c:5833)
process_one_work (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:212 include/trace/events/workqueue.h:108 kernel/workqueue.c:2281)
worker_thread (include/linux/list.h:282 kernel/workqueue.c:2423)
kthread (kernel/kthread.c:319)
ret_from_fork (arch/x86/entry/entry_64.S:301)

Fixes: 3536da06db0b ("NFC: llcp: Clean local timers and works when removing a device")
Signed-off-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Link: https://lore.kernel.org/r/20230111131914.3338838-1-jisoo.jang@yonsei.ac.kr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index eaeb2b1cfa6a..fd43e75abd94 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -159,6 +159,7 @@ static void local_cleanup(struct nfc_llcp_local *local)
 	cancel_work_sync(&local->rx_work);
 	cancel_work_sync(&local->timeout_work);
 	kfree_skb(local->rx_pending);
+	local->rx_pending = NULL;
 	del_timer_sync(&local->sdreq_timer);
 	cancel_work_sync(&local->sdreq_timeout_work);
 	nfc_llcp_free_sdp_tlv_list(&local->pending_sdreqs);
-- 
2.39.0



