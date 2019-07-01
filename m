Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9429111F5C
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfEBPXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:23:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727150AbfEBPXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:23:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D44021670;
        Thu,  2 May 2019 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810630;
        bh=3wcK7nrcL0Xi+SGjqltNA7ZNaK0Ea5BgY5Qsji04VV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwmbE78NEmOY3DKXNLxGimZP8iZ/nrxADlCb1PF2txBuvuvmp6CrfatVe3j8wHGXe
         mDS3xxo4HHYRgA2WzFIoZFYZnh+FaOvv7GoT8qqG9QejwKCXqR37uGSgllm3kNGRjD
         n9F6UDYj3rmyCcFkKCClSXMLJC0R80gUFxxMTeyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Kappner <agk@godking.net>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 02/49] usbnet: ipheth: prevent TX queue timeouts when device not ready
Date:   Thu,  2 May 2019 17:20:39 +0200
Message-Id: <20190502143324.212585980@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Kappner <agk@godking.net>

commit bb1b40c7cb863f0800a6410c7dcb86cf3f28d3b1 upstream.

iOS devices require the host to be "trusted" before servicing network
packets. Establishing trust requires the user to confirm a dialog on the
iOS device.Until trust is established, the iOS device will silently discard
network packets from the host. Currently, the ipheth driver does not detect
whether an iOS device has established trust with the host, and immediately
sets up the transmit queues.

This causes the following problems:

- Kernel taint due to WARN() in netdev watchdog.
- Dmesg spam ("TX timeout").
- Disruption of user space networking activity (dhcpd, etc...) when new
interface comes up but cannot be used.
- Unnecessary host and device wakeups and USB traffic

Example dmesg output:

[ 1101.319778] NETDEV WATCHDOG: eth1 (ipheth): transmit queue 0 timed out
[ 1101.319817] ------------[ cut here ]------------
[ 1101.319828] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:316 dev_watchdog+0x20f/0x220
[ 1101.319831] Modules linked in: ipheth usbmon nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) iwlmvm mac80211 iwlwifi btusb btrtl btbcm btintel qmi_wwan bluetooth cfg80211 ecdh_generic thinkpad_acpi rfkill [last unloaded: ipheth]
[ 1101.319861] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P           O    4.13.12.1 #1
[ 1101.319864] Hardware name: LENOVO 20ENCTO1WW/20ENCTO1WW, BIOS N1EET62W (1.35 ) 11/10/2016
[ 1101.319867] task: ffffffff81e11500 task.stack: ffffffff81e00000
[ 1101.319873] RIP: 0010:dev_watchdog+0x20f/0x220
[ 1101.319876] RSP: 0018:ffff8810a3c03e98 EFLAGS: 00010292
[ 1101.319880] RAX: 000000000000003a RBX: 0000000000000000 RCX: 0000000000000000
[ 1101.319883] RDX: ffff8810a3c15c48 RSI: ffffffff81ccbfc2 RDI: 00000000ffffffff
[ 1101.319886] RBP: ffff880c04ebc41c R08: 0000000000000000 R09: 0000000000000379
[ 1101.319889] R10: 00000100696589d0 R11: 0000000000000378 R12: ffff880c04ebc000
[ 1101.319892] R13: 0000000000000000 R14: 0000000000000001 R15: ffff880c2865fc80
[ 1101.319896] FS:  0000000000000000(0000) GS:ffff8810a3c00000(0000) knlGS:0000000000000000
[ 1101.319899] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1101.319902] CR2: 00007f3ff24ac000 CR3: 0000000001e0a000 CR4: 00000000003406f0
[ 1101.319905] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1101.319908] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1101.319910] Call Trace:
[ 1101.319914]  <IRQ>
[ 1101.319921]  ? dev_graft_qdisc+0x70/0x70
[ 1101.319928]  ? dev_graft_qdisc+0x70/0x70
[ 1101.319934]  ? call_timer_fn+0x2e/0x170
[ 1101.319939]  ? dev_graft_qdisc+0x70/0x70
[ 1101.319944]  ? run_timer_softirq+0x1ea/0x440
[ 1101.319951]  ? timerqueue_add+0x54/0x80
[ 1101.319956]  ? enqueue_hrtimer+0x38/0xa0
[ 1101.319963]  ? __do_softirq+0xed/0x2e7
[ 1101.319970]  ? irq_exit+0xb4/0xc0
[ 1101.319976]  ? smp_apic_timer_interrupt+0x39/0x50
[ 1101.319981]  ? apic_timer_interrupt+0x8c/0xa0
[ 1101.319983]  </IRQ>
[ 1101.319992]  ? cpuidle_enter_state+0xfa/0x2a0
[ 1101.319999]  ? do_idle+0x1a3/0x1f0
[ 1101.320004]  ? cpu_startup_entry+0x5f/0x70
[ 1101.320011]  ? start_kernel+0x444/0x44c
[ 1101.320017]  ? early_idt_handler_array+0x120/0x120
[ 1101.320023]  ? x86_64_start_kernel+0x145/0x154
[ 1101.320028]  ? secondary_startup_64+0x9f/0x9f
[ 1101.320033] Code: 20 04 00 00 eb 9f 4c 89 e7 c6 05 59 44 71 00 01 e8 a7 df fd ff 89 d9 4c 89 e6 48 c7 c7 70 b7 cd 81 48 89 c2 31 c0 e8 97 64 90 ff <0f> ff eb bf 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
[ 1101.320103] ---[ end trace 0cc4d251e2b57080 ]---
[ 1101.320110] ipheth 1-5:4.2: ipheth_tx_timeout: TX timeout

The last message "TX timeout" is repeated every 5 seconds until trust is
established or the device is disconnected, filling up dmesg.

The proposed patch eliminates the problem by, upon connection, keeping the
TX queue and carrier disabled until a packet is first received from the iOS
device. This is reflected by the confirmed_pairing variable in the device
structure. Only after at least one packet has been received from the iOS
device, the transmit queue and carrier are brought up during the periodic
device poll in ipheth_carrier_set. Because the iOS device will always send
a packet immediately upon trust being established, this should not delay
the interface becoming useable. To prevent failed UBRs in
ipheth_rcvbulk_callback from perpetually re-enabling the queue if it was
disabled, a new check is added so only successful transfers re-enable the
queue, whereas failed transfers only trigger an immediate poll.

This has the added benefit of removing the periodic control requests to the
iOS device until trust has been established and thus should reduce wakeup
events on both the host and the iOS device.

Signed-off-by: Alexander Kappner <agk@godking.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
[groeck: Fixed context conflict seen because 45611c61dd50 was applied first]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -148,6 +148,7 @@ struct ipheth_device {
 	u8 bulk_in;
 	u8 bulk_out;
 	struct delayed_work carrier_work;
+	bool confirmed_pairing;
 };
 
 static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags);
@@ -259,7 +260,7 @@ static void ipheth_rcvbulk_callback(stru
 
 	dev->net->stats.rx_packets++;
 	dev->net->stats.rx_bytes += len;
-
+	dev->confirmed_pairing = true;
 	netif_rx(skb);
 	ipheth_rx_submit(dev, GFP_ATOMIC);
 }
@@ -280,14 +281,21 @@ static void ipheth_sndbulk_callback(stru
 		dev_err(&dev->intf->dev, "%s: urb status: %d\n",
 		__func__, status);
 
-	netif_wake_queue(dev->net);
+	if (status == 0)
+		netif_wake_queue(dev->net);
+	else
+		// on URB error, trigger immediate poll
+		schedule_delayed_work(&dev->carrier_work, 0);
 }
 
 static int ipheth_carrier_set(struct ipheth_device *dev)
 {
 	struct usb_device *udev = dev->udev;
 	int retval;
-
+	if (!dev)
+		return 0;
+	if (!dev->confirmed_pairing)
+		return 0;
 	retval = usb_control_msg(udev,
 			usb_rcvctrlpipe(udev, IPHETH_CTRL_ENDP),
 			IPHETH_CMD_CARRIER_CHECK, /* request */
@@ -302,11 +310,14 @@ static int ipheth_carrier_set(struct iph
 		return retval;
 	}
 
-	if (dev->ctrl_buf[0] == IPHETH_CARRIER_ON)
+	if (dev->ctrl_buf[0] == IPHETH_CARRIER_ON) {
 		netif_carrier_on(dev->net);
-	else
+		if (dev->tx_urb->status != -EINPROGRESS)
+			netif_wake_queue(dev->net);
+	} else {
 		netif_carrier_off(dev->net);
-
+		netif_stop_queue(dev->net);
+	}
 	return 0;
 }
 
@@ -386,7 +397,6 @@ static int ipheth_open(struct net_device
 		return retval;
 
 	schedule_delayed_work(&dev->carrier_work, IPHETH_CARRIER_CHECK_TIMEOUT);
-	netif_start_queue(net);
 	return retval;
 }
 
@@ -489,7 +499,7 @@ static int ipheth_probe(struct usb_inter
 	dev->udev = udev;
 	dev->net = netdev;
 	dev->intf = intf;
-
+	dev->confirmed_pairing = false;
 	/* Set up endpoints */
 	hintf = usb_altnum_to_altsetting(intf, IPHETH_ALT_INTFNUM);
 	if (hintf == NULL) {
@@ -540,7 +550,9 @@ static int ipheth_probe(struct usb_inter
 		retval = -EIO;
 		goto err_register_netdev;
 	}
-
+	// carrier down and transmit queues stopped until packet from device
+	netif_carrier_off(netdev);
+	netif_tx_stop_all_queues(netdev);
 	dev_info(&intf->dev, "Apple iPhone USB Ethernet device attached\n");
 	return 0;
 


