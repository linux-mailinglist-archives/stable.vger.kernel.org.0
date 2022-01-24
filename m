Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF2B49A422
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369394AbiAYABk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384582AbiAXXYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:24:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A21EC073090;
        Mon, 24 Jan 2022 13:29:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62454B8105C;
        Mon, 24 Jan 2022 21:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7A2C36AE9;
        Mon, 24 Jan 2022 21:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059763;
        bh=PT9cOZRjZokQfTIoZoyk+ac+Lh97j0RFBNiuxEnwne8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdDPTGiiq2swvGhWrDVDwnNYkp28PpotciFMI0U2UW1fiHAdIcC7/8hBoL9uEM2Ce
         BKUi7G2rCtej7Rz/cnAl8kGixMRL8S7A9mTG2uvG+rvRovK3VsvMeyIaJvsGYFULY+
         PK6mniXRmZRsst/h8MrTdvHQfNa2qV45xI8bp/08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0692/1039] Bluetooth: vhci: Set HCI_QUIRK_VALID_LE_STATES
Date:   Mon, 24 Jan 2022 19:41:21 +0100
Message-Id: <20220124184148.603873277@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 5fd91106e853d..95af01bdd02a2 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -239,6 +239,8 @@ static int __vhci_create_device(struct vhci_data *data, __u8 opcode)
 	if (opcode & 0x80)
 		set_bit(HCI_QUIRK_RAW_DEVICE, &hdev->quirks);
 
+	set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+
 	if (hci_register_dev(hdev) < 0) {
 		BT_ERR("Can't register HCI device");
 		hci_free_dev(hdev);
-- 
2.34.1



