Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5FBF648E
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfKJDAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbfKJC4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2FD32249E;
        Sun, 10 Nov 2019 02:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354086;
        bh=fg91nLDGVt3w607YoMYtnBvNOU3I7TSwxUy5GAjZX40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qS/T/2YY7VCsxIfv9Z2e/PUJRRLWSi3KpaCCxepIgvuKyAKBYpkBTT1rKTWirGS0H
         BCgY9/nKavdmbqRchHu++cg0cJgxium5zApat8uF2fg/N+ymPxQIv/46JUTXWjdXiu
         LQ5S0aqlp9QTk6wQYOeihCJ4qiXPy8iO8IPnaX/o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 083/109] Bluetooth: hci_serdev: clear HCI_UART_PROTO_READY to avoid closing proto races
Date:   Sat,  9 Nov 2019 21:45:15 -0500
Message-Id: <20191110024541.31567-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

