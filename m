Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AF43DD859
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhHBNvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234563AbhHBNui (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 885416052B;
        Mon,  2 Aug 2021 13:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912226;
        bh=1on7F6qjqqXQipDnaqQP814c2+8+InJRDOYMzSi5di4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyxgbO9lcARBS06mc+2SMpds/Jgl6+uT00xFWyKPymSX4lozkdU+gO1T0iDji/Yuw
         0kwg8HgwSy5mnp007l2KoY7UYqAUzHbMHhfxVIdQWTU+88IEfIUPaB4tg3VuybVTYv
         Pn6QnzQlgDuiVSerxA/1ttJ8IVrJN+Zu1TEQJRQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 14/30] nfc: nfcsim: fix use after free during module unload
Date:   Mon,  2 Aug 2021 15:44:52 +0200
Message-Id: <20210802134334.535733136@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.081433902@linuxfoundation.org>
References: <20210802134334.081433902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 5e7b30d24a5b8cb691c173b45b50e3ca0191be19 upstream.

There is a use after free memory corruption during module exit:
 - nfcsim_exit()
  - nfcsim_device_free(dev0)
    - nfc_digital_unregister_device()
      This iterates over command queue and frees all commands,
    - dev->up = false
    - nfcsim_link_shutdown()
      - nfcsim_link_recv_wake()
        This wakes the sleeping thread nfcsim_link_recv_skb().

 - nfcsim_link_recv_skb()
   Wake from wait_event_interruptible_timeout(),
   call directly the deb->cb callback even though (dev->up == false),
   - digital_send_cmd_complete()
     Dereference of "struct digital_cmd" cmd which was freed earlier by
     nfc_digital_unregister_device().

This causes memory corruption shortly after (with unrelated stack
trace):

  nfc nfc0: NFC: nfcsim_recv_wq: Device is down
  llcp: nfc_llcp_recv: err -19
  nfc nfc1: NFC: nfcsim_recv_wq: Device is down
  BUG: unable to handle page fault for address: ffffffffffffffed
  Call Trace:
   fsnotify+0x54b/0x5c0
   __fsnotify_parent+0x1fe/0x300
   ? vfs_write+0x27c/0x390
   vfs_write+0x27c/0x390
   ksys_write+0x63/0xe0
   do_syscall_64+0x3b/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xae

KASAN report:

  BUG: KASAN: use-after-free in digital_send_cmd_complete+0x16/0x50
  Write of size 8 at addr ffff88800a05f720 by task kworker/0:2/71
  Workqueue: events nfcsim_recv_wq [nfcsim]
  Call Trace:
   dump_stack_lvl+0x45/0x59
   print_address_description.constprop.0+0x21/0x140
   ? digital_send_cmd_complete+0x16/0x50
   ? digital_send_cmd_complete+0x16/0x50
   kasan_report.cold+0x7f/0x11b
   ? digital_send_cmd_complete+0x16/0x50
   ? digital_dep_link_down+0x60/0x60
   digital_send_cmd_complete+0x16/0x50
   nfcsim_recv_wq+0x38f/0x3d5 [nfcsim]
   ? nfcsim_in_send_cmd+0x4a/0x4a [nfcsim]
   ? lock_is_held_type+0x98/0x110
   ? finish_wait+0x110/0x110
   ? rcu_read_lock_sched_held+0x9c/0xd0
   ? rcu_read_lock_bh_held+0xb0/0xb0
   ? lockdep_hardirqs_on_prepare+0x12e/0x1f0

This flow of calling digital_send_cmd_complete() callback on driver exit
is specific to nfcsim which implements reading and sending work queues.
Since the NFC digital device was unregistered, the callback should not
be called.

Fixes: 204bddcb508f ("NFC: nfcsim: Make use of the Digital layer")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/nfcsim.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -201,8 +201,7 @@ static void nfcsim_recv_wq(struct work_s
 
 		if (!IS_ERR(skb))
 			dev_kfree_skb(skb);
-
-		skb = ERR_PTR(-ENODEV);
+		return;
 	}
 
 	dev->cb(dev->nfc_digital_dev, dev->arg, skb);


