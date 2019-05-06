Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22DD14C2A
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfEFOhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727291AbfEFOhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 772FC206A3;
        Mon,  6 May 2019 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153427;
        bh=d7uNJrLitMhqX15euf0F9ce9ER6b9bWi/IESkGcFvrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYSCoCplaRbHfcaptlwaYEffAQsjU6P7/H7ZF8ar69xMz1nC/ogECRbqkS1kWNyg4
         z34FInmwuHvZHjKnvudONtOJQrcDQqN4FWGhwrqinMGRJtQKmpS5Wd7Vng0eFCZHer
         NrswbGXJJg2AC0qWeVZt+c4fmOOiySDyaFd/0klY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.0 085/122] Bluetooth: mediatek: fix up an error path to restore bdev->tx_state
Date:   Mon,  6 May 2019 16:32:23 +0200
Message-Id: <20190506143102.378302993@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

commit 77f328dbc6cf42f22c691a164958a5452142a542 upstream.

Restore bdev->tx_state with clearing bit BTMTKUART_TX_WAIT_VND_EVT
when there is an error on waiting for the corresponding event.

Fixes: 7237c4c9ec92 ("Bluetooth: mediatek: Add protocol support for MediaTek serial devices")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btmtkuart.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/bluetooth/btmtkuart.c
+++ b/drivers/bluetooth/btmtkuart.c
@@ -115,11 +115,13 @@ static int mtk_hci_wmt_sync(struct hci_d
 				  TASK_INTERRUPTIBLE, HCI_INIT_TIMEOUT);
 	if (err == -EINTR) {
 		bt_dev_err(hdev, "Execution of wmt command interrupted");
+		clear_bit(BTMTKUART_TX_WAIT_VND_EVT, &bdev->tx_state);
 		return err;
 	}
 
 	if (err) {
 		bt_dev_err(hdev, "Execution of wmt command timed out");
+		clear_bit(BTMTKUART_TX_WAIT_VND_EVT, &bdev->tx_state);
 		return -ETIMEDOUT;
 	}
 


