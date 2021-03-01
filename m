Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B863C328A50
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239021AbhCASPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239452AbhCASIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68816652B3;
        Mon,  1 Mar 2021 17:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620087;
        bh=LhAKqvRNZIEa6tvIdsO+Nze2lhA7qS1Si39VQfZn+rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBWcKA8QFEM8e46IIOTo7fUl3yJzSq8PE1vjEZ+K5yBodgTGkS/5GkKjtsvSN63v0
         4wlQ+G3K3jF1cQft5Gdv0H7KRI5o4jQQAVXo+nqwhKUTE9WeDy9U1LclUf0Lmfzi1L
         5+P9DLSHkFiq8PjcUkdWCez/WrwwFpOR4zGBtrpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claire Chang <tientzu@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 025/775] Bluetooth: hci_uart: Fix a race for write_work scheduling
Date:   Mon,  1 Mar 2021 17:03:13 +0100
Message-Id: <20210301161202.961530386@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claire Chang <tientzu@chromium.org>

[ Upstream commit afe0b1c86458f121b085271e4f3034017a90d4a3 ]

In hci_uart_write_work, there is a loop/goto checking the value of
HCI_UART_TX_WAKEUP. If HCI_UART_TX_WAKEUP is set again, it keeps trying
hci_uart_dequeue; otherwise, it clears HCI_UART_SENDING and returns.

In hci_uart_tx_wakeup, if HCI_UART_SENDING is already set, it sets
HCI_UART_TX_WAKEUP, skips schedule_work and assumes the running/pending
hci_uart_write_work worker will do hci_uart_dequeue properly.

However, if the HCI_UART_SENDING check in hci_uart_tx_wakeup is done after
the loop breaks, but before HCI_UART_SENDING is cleared in
hci_uart_write_work, the schedule_work is skipped incorrectly.

Fix this race by changing the order of HCI_UART_SENDING and
HCI_UART_TX_WAKEUP modification.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 82f5169bf3d3 ("Bluetooth: hci_uart: add serdev driver support library")
Signed-off-by: Claire Chang <tientzu@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ldisc.c  | 7 +++----
 drivers/bluetooth/hci_serdev.c | 4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index f83d67eafc9f0..8be4d807d1370 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -127,10 +127,9 @@ int hci_uart_tx_wakeup(struct hci_uart *hu)
 	if (!test_bit(HCI_UART_PROTO_READY, &hu->flags))
 		goto no_schedule;
 
-	if (test_and_set_bit(HCI_UART_SENDING, &hu->tx_state)) {
-		set_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
+	set_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
+	if (test_and_set_bit(HCI_UART_SENDING, &hu->tx_state))
 		goto no_schedule;
-	}
 
 	BT_DBG("");
 
@@ -174,10 +173,10 @@ restart:
 		kfree_skb(skb);
 	}
 
+	clear_bit(HCI_UART_SENDING, &hu->tx_state);
 	if (test_bit(HCI_UART_TX_WAKEUP, &hu->tx_state))
 		goto restart;
 
-	clear_bit(HCI_UART_SENDING, &hu->tx_state);
 	wake_up_bit(&hu->tx_state, HCI_UART_SENDING);
 }
 
diff --git a/drivers/bluetooth/hci_serdev.c b/drivers/bluetooth/hci_serdev.c
index ef96ad06fa54e..9e03402ef1b37 100644
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -83,9 +83,9 @@ static void hci_uart_write_work(struct work_struct *work)
 			hci_uart_tx_complete(hu, hci_skb_pkt_type(skb));
 			kfree_skb(skb);
 		}
-	} while (test_bit(HCI_UART_TX_WAKEUP, &hu->tx_state));
 
-	clear_bit(HCI_UART_SENDING, &hu->tx_state);
+		clear_bit(HCI_UART_SENDING, &hu->tx_state);
+	} while (test_bit(HCI_UART_TX_WAKEUP, &hu->tx_state));
 }
 
 /* ------- Interface to HCI layer ------ */
-- 
2.27.0



