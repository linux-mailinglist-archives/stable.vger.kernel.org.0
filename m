Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B8B29C67E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1826271AbgJ0SSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754141AbgJ0OLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:11:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12B7422384;
        Tue, 27 Oct 2020 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807875;
        bh=6nwMkp7AWLX6m+vIInrJJ/9opj19CuFuB8Axt5gn5m0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xyKWXgD+W/V5G32Qrkbu/w7MXtHISIgy2I1riZ2ygF6wrPL5o1NTe1/LWsIbwXm2u
         VfxEFKomk1QuL1liPA8AvT5IjyQJw4hTgDPWt70Yos+eciId1vexrtYzAntMxSUko8
         MFu0q6/JuwpcsSIAin52JsS5oacbygUpVZBt4DHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 042/191] Bluetooth: hci_uart: Cancel init work before unregistering
Date:   Tue, 27 Oct 2020 14:48:17 +0100
Message-Id: <20201027134911.762018213@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 3b799254cf6f481460719023d7a18f46651e5e7f ]

If hci_uart_tty_close() or hci_uart_unregister_device() is called while
hu->init_ready is scheduled, hci_register_dev() could be called after
the hci_uart is torn down. Avoid this by ensuring the work is complete
or canceled before checking the HCI_UART_REGISTERED flag.

Fixes: 9f2aee848fe6 ("Bluetooth: Add delayed init sequence support for UART controllers")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ldisc.c  | 1 +
 drivers/bluetooth/hci_serdev.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 43221def1d29f..f19606019eb01 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -541,6 +541,7 @@ static void hci_uart_tty_close(struct tty_struct *tty)
 		clear_bit(HCI_UART_PROTO_READY, &hu->flags);
 		percpu_up_write(&hu->proto_lock);
 
+		cancel_work_sync(&hu->init_ready);
 		cancel_work_sync(&hu->write_work);
 
 		if (hdev) {
diff --git a/drivers/bluetooth/hci_serdev.c b/drivers/bluetooth/hci_serdev.c
index 72cf2d97b682c..196b046658ff4 100644
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -361,6 +361,8 @@ void hci_uart_unregister_device(struct hci_uart *hu)
 	struct hci_dev *hdev = hu->hdev;
 
 	clear_bit(HCI_UART_PROTO_READY, &hu->flags);
+
+	cancel_work_sync(&hu->init_ready);
 	if (test_bit(HCI_UART_REGISTERED, &hu->flags))
 		hci_unregister_dev(hdev);
 	hci_free_dev(hdev);
-- 
2.25.1



