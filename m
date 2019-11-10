Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF418F65C6
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbfKJCog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728592AbfKJCof (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F9D421D82;
        Sun, 10 Nov 2019 02:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353874;
        bh=J7af8Qtw38Ew9P8n51YmBy+yIcLcxX26TQGIZ7m712s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VteY9gRcnJY2TuewLGeTHaOEOURGNqqjxMSNrn0zcRU03ZLPzWSMQMXZ1JIYbKzmj
         P7huH+GL+8Br/N6J/wtHNsvBff3L3bPSKbp/VbUzlH3N0vHJ4QTulK+zuFvros8Ngd
         5CZqkPJKkm/Tb/xxrBY4HioMNlKJzjkCiJT8HL0o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 153/191] Bluetooth: hci_serdev: clear HCI_UART_PROTO_READY to avoid closing proto races
Date:   Sat,  9 Nov 2019 21:39:35 -0500
Message-Id: <20191110024013.29782-153-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
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
index aa2543b3c2869..46e20444ba19b 100644
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -368,6 +368,7 @@ void hci_uart_unregister_device(struct hci_uart *hu)
 {
 	struct hci_dev *hdev = hu->hdev;
 
+	clear_bit(HCI_UART_PROTO_READY, &hu->flags);
 	hci_unregister_dev(hdev);
 	hci_free_dev(hdev);
 
-- 
2.20.1

