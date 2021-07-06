Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F85D3BD026
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbhGFLcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235765AbhGFLaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0755861DE5;
        Tue,  6 Jul 2021 11:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570509;
        bh=stvcF6uXrbquSGSrH8uLYFq78eQal4IKJZFjo3M7OhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i574mTBt+A3GniqD0AJwzFqy+2PadelR5zjB3TPAQT4oNZ8LVpQToTtufZ0i1TGAO
         A9ZYXO+YhJFh795C6yNpIwe9QhlejsZ0ix+w7zMkvFcF7E2jrwK7qdRruqNKr53/mi
         kvsmQ3cnP3QvexhU2U5HvcYYI6vMozz0QMB64V3NHg0h8+R6v/lVx9vLceMxMkLysR
         gU/6pOKL6I/n3gwq0sAWgHIt6G/trx1bAPKb0khMK+h+R6ircYB3az3TX/zfghxwSx
         vKndxdgNBLXmzmvdX9mDsIb6hEbyRvUHdTfUSAqnVHf4NQnQiYUFVFkiHoLlDQqTWO
         jyfb7/QlPvuSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Jiang <tjiang@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 151/160] Bluetooth: btusb: use default nvm if boardID is 0 for wcn6855.
Date:   Tue,  6 Jul 2021 07:18:17 -0400
Message-Id: <20210706111827.2060499-151-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Jiang <tjiang@codeaurora.org>

[ Upstream commit ca17a5cccf8b6d35dab4729bea8f4350bc0b4caf ]

if boardID is 0, will use the default nvm file without surfix.

Signed-off-by: Tim Jiang <tjiang@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index ec17772defc2..64b0e68c68eb 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4228,9 +4228,15 @@ static int btusb_setup_qca_load_nvm(struct hci_dev *hdev,
 	int err;
 
 	if (((ver->flag >> 8) & 0xff) == QCA_FLAG_MULTI_NVM) {
-		snprintf(fwname, sizeof(fwname), "qca/nvm_usb_%08x_%04x.bin",
-			 le32_to_cpu(ver->rom_version),
-			 le16_to_cpu(ver->board_id));
+		/* if boardid equal 0, use default nvm without surfix */
+		if (le16_to_cpu(ver->board_id) == 0x0) {
+			snprintf(fwname, sizeof(fwname), "qca/nvm_usb_%08x.bin",
+				 le32_to_cpu(ver->rom_version));
+		} else {
+			snprintf(fwname, sizeof(fwname), "qca/nvm_usb_%08x_%04x.bin",
+				le32_to_cpu(ver->rom_version),
+				le16_to_cpu(ver->board_id));
+		}
 	} else {
 		snprintf(fwname, sizeof(fwname), "qca/nvm_usb_%08x.bin",
 			 le32_to_cpu(ver->rom_version));
-- 
2.30.2

