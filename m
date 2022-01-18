Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C76491893
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348952AbiARCrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:47:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50482 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344839AbiARCnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AE0DB8124B;
        Tue, 18 Jan 2022 02:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A25C36AE3;
        Tue, 18 Jan 2022 02:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473820;
        bh=gDmFszm+/TUhgaalM12dREB18MEqRLtv9uD+Yy9sdoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjIWQlq6uQ1P2UUASeoMZwiFNiKYLkfR63VHQY/HGh51DQGXETVJrkcGLZYpEzYCd
         HrNNgEcyDdu2OYgzOH74Xzyk+ZF+Brgzi8nmfKKI1pMHeN0hEcJBekdsTPWwVAQ96T
         4WCHrc9hOuIp5iVBguPoB4D7hHaVtxdbXcU3ZMf3slkGFMnDtPODygDyn2oSzQWom7
         OYt0t1DRSp0JlIBao1M2va+Mouc8IhSVebrm6Y6YTjNyVcncIOqP9wBqEbqbs6uGYY
         cNIeM8te1XdmgWlEuAWArvIOJ0t7NIqvJyMkTicdtxyswUvab5IjVl+e1TMLvTqKXg
         VLGCZtkVAY6Jg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 086/116] Bluetooth: vhci: Set HCI_QUIRK_VALID_LE_STATES
Date:   Mon, 17 Jan 2022 21:39:37 -0500
Message-Id: <20220118024007.1950576-86-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit cfb4c313be670fd4bd09650216620fa4514cdb93 ]

This set HCI_QUIRK_VALID_LE_STATES quirk which is required for the likes
of experimental LE simultaneous roles.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_vhci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 8ab26dec5f6e8..8469f9876dd26 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -121,6 +121,8 @@ static int __vhci_create_device(struct vhci_data *data, __u8 opcode)
 	if (opcode & 0x80)
 		set_bit(HCI_QUIRK_RAW_DEVICE, &hdev->quirks);
 
+	set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+
 	if (hci_register_dev(hdev) < 0) {
 		BT_ERR("Can't register HCI device");
 		hci_free_dev(hdev);
-- 
2.34.1

