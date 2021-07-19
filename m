Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34BA3CD8F7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243589AbhGSO0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244034AbhGSOYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65A9761175;
        Mon, 19 Jul 2021 15:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707097;
        bh=FlLUmkhYNJg/EQa4I1qcfkc7BZKJmasTc6LZWd+XwbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bia9q75hsnRFlDcEe3ybeu8HT0n2XZMa4E/SSycrZFfYh5nd0MAbMoc0wyuRI3sR/
         0Tp4hXCnc7TxjuTTjeBAnhjMM/wFgby94YM2dvSbGD7oAQ1OkWcqJDiLMtmkKCcONX
         zcvx08su42enIjz9wCmIsm9S7m3b505ECaLvtWTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.9 004/245] net: can: ems_usb: fix use-after-free in ems_usb_disconnect()
Date:   Mon, 19 Jul 2021 16:49:06 +0200
Message-Id: <20210719144940.509131427@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit ab4a0b8fcb9a95c02909b62049811bd2e586aaa4 upstream.

In ems_usb_disconnect() dev pointer, which is netdev private data, is
used after free_candev() call:
| 	if (dev) {
| 		unregister_netdev(dev->netdev);
| 		free_candev(dev->netdev);
|
| 		unlink_all_urbs(dev);
|
| 		usb_free_urb(dev->intr_urb);
|
| 		kfree(dev->intr_in_buffer);
| 		kfree(dev->tx_msg_buffer);
| 	}

Fix it by simply moving free_candev() at the end of the block.

Fail log:
| BUG: KASAN: use-after-free in ems_usb_disconnect
| Read of size 8 at addr ffff88804e041008 by task kworker/1:2/2895
|
| CPU: 1 PID: 2895 Comm: kworker/1:2 Not tainted 5.13.0-rc5+ #164
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.4
| Workqueue: usb_hub_wq hub_event
| Call Trace:
|     dump_stack (lib/dump_stack.c:122)
|     print_address_description.constprop.0.cold (mm/kasan/report.c:234)
|     kasan_report.cold (mm/kasan/report.c:420 mm/kasan/report.c:436)
|     ems_usb_disconnect (drivers/net/can/usb/ems_usb.c:683 drivers/net/can/usb/ems_usb.c:1058)

Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Link: https://lore.kernel.org/r/20210617185130.5834-1-paskripkin@gmail.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/ems_usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -1064,7 +1064,6 @@ static void ems_usb_disconnect(struct us
 
 	if (dev) {
 		unregister_netdev(dev->netdev);
-		free_candev(dev->netdev);
 
 		unlink_all_urbs(dev);
 
@@ -1072,6 +1071,8 @@ static void ems_usb_disconnect(struct us
 
 		kfree(dev->intr_in_buffer);
 		kfree(dev->tx_msg_buffer);
+
+		free_candev(dev->netdev);
 	}
 }
 


