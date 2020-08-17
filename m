Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEEB2470A1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387897AbgHQSMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731063AbgHQQGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:06:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0532245C;
        Mon, 17 Aug 2020 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680406;
        bh=WWNC+Mxdw/AtG09yKiZXNty4nIwcaKcO/uQE8UhtNRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4dSj3pvUbZOKlHUTvnu2NeoAe7TJ1GqRfYX0rJlJkXBpC0oo3uDUeZbFkHkvG8dv
         jUFwSURoUnvM5mctyWWhpDRkZ9yOxOR+n4LR6fqyDNlCdaGvh+1/t+Y5M8H9Ula1Jb
         8n96fs1DG+nbqLjfOZ5yCX3R+dAL3cBsMbj5mf8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/270] Bluetooth: hci_serdev: Only unregister device if it was registered
Date:   Mon, 17 Aug 2020 17:16:16 +0200
Message-Id: <20200817143804.535366869@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

[ Upstream commit 202798db9570104728dce8bb57dfeed47ce764bc ]

We should not call hci_unregister_dev if the device was not
successfully registered.

Fixes: c34dc3bfa7642fd ("Bluetooth: hci_serdev: Introduce hci_uart_unregister_device()")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_serdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_serdev.c b/drivers/bluetooth/hci_serdev.c
index 4652896d49908..ad2f26cb2622e 100644
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -357,7 +357,8 @@ void hci_uart_unregister_device(struct hci_uart *hu)
 	struct hci_dev *hdev = hu->hdev;
 
 	clear_bit(HCI_UART_PROTO_READY, &hu->flags);
-	hci_unregister_dev(hdev);
+	if (test_bit(HCI_UART_REGISTERED, &hu->flags))
+		hci_unregister_dev(hdev);
 	hci_free_dev(hdev);
 
 	cancel_work_sync(&hu->write_work);
-- 
2.25.1



