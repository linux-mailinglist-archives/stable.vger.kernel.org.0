Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D9D3CA916
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242550AbhGOTFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242363AbhGOTDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:03:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C5276127C;
        Thu, 15 Jul 2021 18:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375574;
        bh=stvcF6uXrbquSGSrH8uLYFq78eQal4IKJZFjo3M7OhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDCWBfGrHFl9G08W8+xluwk3G5OHidjbSeuJaj85Py5Ahc5HL5B+XQQY4ZxqnPqTx
         sn3FWtRifwc86qXPPmZQRyFTWtz7bPdniYjUJlJJuxlIebzAzUKO/a1WBqt99//3Gi
         IoKsfo2T/Y/wGeoBk8hOPPII/QCE2ma/pmHusSbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Jiang <tjiang@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 144/242] Bluetooth: btusb: use default nvm if boardID is 0 for wcn6855.
Date:   Thu, 15 Jul 2021 20:38:26 +0200
Message-Id: <20210715182618.523947667@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



