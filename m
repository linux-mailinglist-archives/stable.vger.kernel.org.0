Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41C6499475
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358313AbiAXUmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:42:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34234 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388459AbiAXUjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:39:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20FD36153D;
        Mon, 24 Jan 2022 20:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B8AC340E5;
        Mon, 24 Jan 2022 20:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056739;
        bh=gDmFszm+/TUhgaalM12dREB18MEqRLtv9uD+Yy9sdoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+Jf8QZmgElbhl4+yb6XhhRA3Zk2yOIUc1RLgffuEqyB0FSH+jaoj6V75BCwWewig
         /lj8DbhD3B9050J49bADXkUgbMGAxTZc6uTCzyslzwKP+G6K9xHJl8Y4Q2uivuGtvd
         9LyW41kwpCoFoVI844yZApfHXQTQi/HmmRVExFa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 585/846] Bluetooth: vhci: Set HCI_QUIRK_VALID_LE_STATES
Date:   Mon, 24 Jan 2022 19:41:42 +0100
Message-Id: <20220124184121.226915672@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



