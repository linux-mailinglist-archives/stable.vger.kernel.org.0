Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 050D3101684
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbfKSFyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:54:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732095AbfKSFyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:54:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D53A920721;
        Tue, 19 Nov 2019 05:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142844;
        bh=fg91nLDGVt3w607YoMYtnBvNOU3I7TSwxUy5GAjZX40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0363rzaXbWMN4P+jOxXSazyZksRlFP7sp8SM9+r+9XJcXmbn1EiQJQhANDsNxKsqI
         BESaDELK4y0BJq0yDd1AhSmJnmIe3lrTPYnhViHaIACqv8vwFwVjUenQVLd4YsRzaQ
         FLgwmNtmTd1cLMTZFx+VdT56I9208W4NClTzC3+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 212/239] Bluetooth: hci_serdev: clear HCI_UART_PROTO_READY to avoid closing proto races
Date:   Tue, 19 Nov 2019 06:20:12 +0100
Message-Id: <20191119051338.451348099@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Balakrishna Godavarthi <bgodavar@codeaurora.org>

[ Upstream commit 7cf7846d27bfc9731e449857db3eec5e0e9701ba ]

Clearing HCI_UART_PROTO_READY will avoid usage of proto function pointers
before running the proto close function pointer. There is chance of kernel
crash, due to usage of non proto close function pointers after proto close.

Signed-off-by: Balakrishna Godavarthi <bgodavar@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_serdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/hci_serdev.c b/drivers/bluetooth/hci_serdev.c
index 52e6d4d1608e3..69c00a3db5382 100644
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -360,6 +360,7 @@ void hci_uart_unregister_device(struct hci_uart *hu)
 {
 	struct hci_dev *hdev = hu->hdev;
 
+	clear_bit(HCI_UART_PROTO_READY, &hu->flags);
 	hci_unregister_dev(hdev);
 	hci_free_dev(hdev);
 
-- 
2.20.1



