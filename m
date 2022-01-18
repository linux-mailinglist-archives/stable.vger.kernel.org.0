Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466384915EE
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345942AbiARCcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40636 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344145AbiARC3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:29:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4CFAB811FF;
        Tue, 18 Jan 2022 02:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14D0C36AEB;
        Tue, 18 Jan 2022 02:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472954;
        bh=lRjqPn9qJ+FH43bnGFmSyWZ6o80v/vkvabiW0x/dIYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivnw7bYDh3zo5l8nWjNj2zu1NCtl+yYkOOvPYDluEr4G9sI1R5LyusBMSYUXjDBnB
         29qfX0icdxDxs/sSWdfui88vlawiuDqjP+M2IysqdKnjCPOcX5vIJ4Ck6OkQc9fjmx
         Yk4WjpkTXHEe4ipI+CyYN5t5Dy044IuCU1vspNcbYyKG4ZxKgHj68C7VJEV/c3a3lz
         yInG7WMcfSoQ7ODicBvKj6leUTo9pdQPYAiEHGDU2Zv6k6UjdNiuR2ezVD7EwnSfpZ
         dgX0/BQe8tvRYGCkzFYDEPWBm43W74Lb1KKRKaK8xmdxesO5EcH3tG7P8LxPk4poRT
         GqVzZjBdWknag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 175/217] Bluetooth: vhci: Set HCI_QUIRK_VALID_LE_STATES
Date:   Mon, 17 Jan 2022 21:18:58 -0500
Message-Id: <20220118021940.1942199-175-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index b45db0db347c6..dff4456bc7089 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -237,6 +237,8 @@ static int __vhci_create_device(struct vhci_data *data, __u8 opcode)
 	if (opcode & 0x80)
 		set_bit(HCI_QUIRK_RAW_DEVICE, &hdev->quirks);
 
+	set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+
 	if (hci_register_dev(hdev) < 0) {
 		BT_ERR("Can't register HCI device");
 		hci_free_dev(hdev);
-- 
2.34.1

