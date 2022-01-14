Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D7A48E54C
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiANIRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236783AbiANIRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:17:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57354C061574;
        Fri, 14 Jan 2022 00:17:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1253CB82434;
        Fri, 14 Jan 2022 08:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D60CC36AE9;
        Fri, 14 Jan 2022 08:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148225;
        bh=iX52VoNb/VAL7lxVlwcWtZMByhicAo7V/IhRaNmpm4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MpvCpDVxrJjhn55+vvboaTVvVRkYe32bTsCtgNtYlIEYCA4EkvyZ2s2fEwrkkbsN4
         M6nH0A4XCfumd48CPL5HPvkPkVwul0PuldKotaAfvAE8tEP51RvkXazq6vMQGP6Nmi
         RHloB5WWRqEw902yV6EUfwBvl+cyDtbI45nyc7i4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Mark-YW.Chen" <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.4 02/18] Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()
Date:   Fri, 14 Jan 2022 09:16:09 +0100
Message-Id: <20220114081541.543510057@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081541.465841464@linuxfoundation.org>
References: <20220114081541.465841464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark-YW.Chen <mark-yw.chen@mediatek.com>

commit 60c6a63a3d3080a62f3e0e20084f58dbeff16748 upstream.

Driver should free `usb->setup_packet` to avoid the leak.

$ cat /sys/kernel/debug/kmemleak
unreferenced object 0xffffffa564a58080 (size 128):
    backtrace:
        [<000000007eb8dd70>] kmem_cache_alloc_trace+0x22c/0x384
        [<000000008a44191d>] btusb_mtk_hci_wmt_sync+0x1ec/0x994
    [btusb]
        [<00000000ca7189a3>] btusb_mtk_setup+0x6b8/0x13cc
    [btusb]
        [<00000000c6105069>] hci_dev_do_open+0x290/0x974
    [bluetooth]
        [<00000000a583f8b8>] hci_power_on+0xdc/0x3cc [bluetooth]
        [<000000005d80e687>] process_one_work+0x514/0xc80
        [<00000000f4d57637>] worker_thread+0x818/0xd0c
        [<00000000dc7bdb55>] kthread+0x2f8/0x3b8
        [<00000000f9999513>] ret_from_fork+0x10/0x30

Fixes: a1c49c434e150 ("Bluetooth: btusb: Add protocol support for MediaTek MT7668U USB devices")
Signed-off-by: Mark-YW.Chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2568,6 +2568,7 @@ static void btusb_mtk_wmt_recv(struct ur
 		skb = bt_skb_alloc(HCI_WMT_MAX_EVENT_SIZE, GFP_ATOMIC);
 		if (!skb) {
 			hdev->stat.err_rx++;
+			kfree(urb->setup_packet);
 			return;
 		}
 
@@ -2588,6 +2589,7 @@ static void btusb_mtk_wmt_recv(struct ur
 			data->evt_skb = skb_clone(skb, GFP_ATOMIC);
 			if (!data->evt_skb) {
 				kfree_skb(skb);
+				kfree(urb->setup_packet);
 				return;
 			}
 		}
@@ -2596,6 +2598,7 @@ static void btusb_mtk_wmt_recv(struct ur
 		if (err < 0) {
 			kfree_skb(data->evt_skb);
 			data->evt_skb = NULL;
+			kfree(urb->setup_packet);
 			return;
 		}
 
@@ -2606,6 +2609,7 @@ static void btusb_mtk_wmt_recv(struct ur
 			wake_up_bit(&data->flags,
 				    BTUSB_TX_WAIT_VND_EVT);
 		}
+		kfree(urb->setup_packet);
 		return;
 	} else if (urb->status == -ENOENT) {
 		/* Avoid suspend failed when usb_kill_urb */
@@ -2626,6 +2630,7 @@ static void btusb_mtk_wmt_recv(struct ur
 	usb_anchor_urb(urb, &data->ctrl_anchor);
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
+		kfree(urb->setup_packet);
 		/* -EPERM: urb is being killed;
 		 * -ENODEV: device got disconnected
 		 */


