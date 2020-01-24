Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DCE147658
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbgAXBRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:17:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730684AbgAXBRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DB4D2467E;
        Fri, 24 Jan 2020 01:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828661;
        bh=yi3SPWfrdUc2hmBaEB9c9QudFRVizN2qqqi3ustrzIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zatxfaj0W2RlSuKJSVrjxITHkBgbhvydFnHszMq4GNjdWMJYk9E4S6W78bVPiZqTf
         sANufA6NyV1ohgqh4iCAVJL+eIwXdLFNcJ9jlVhW+EBhFHEwmWjJPbCKZDVRJLTaKD
         4CEGX1ZpnKJi5GNwB5UF1fH0Zm7sqyP8QXDYW5fo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Heider <a.heider@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 28/33] Bluetooth: btbcm: Use the BDADDR_PROPERTY quirk
Date:   Thu, 23 Jan 2020 20:17:03 -0500
Message-Id: <20200124011708.18232-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Heider <a.heider@gmail.com>

[ Upstream commit a4f95f31a9f38d9bb1fd313fcc2d0c0d48116ee3 ]

Some devices ship with the controller default address, like the
Orange Pi 3 (BCM4345C5).

Allow the bootloader to set a valid address through the device tree.

Signed-off-by: Andre Heider <a.heider@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btbcm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 2d2e6d8620681..f02a4bdc0ca75 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -440,6 +440,12 @@ int btbcm_finalize(struct hci_dev *hdev)
 
 	set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
 
+	/* Some devices ship with the controller default address.
+	 * Allow the bootloader to set a valid address through the
+	 * device tree.
+	 */
+	set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(btbcm_finalize);
-- 
2.20.1

