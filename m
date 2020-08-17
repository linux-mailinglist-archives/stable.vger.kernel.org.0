Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E9C246F06
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731489AbgHQRlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731116AbgHQQQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:16:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B232075B;
        Mon, 17 Aug 2020 16:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680981;
        bh=aFj2RC1IAslrTgOyq9gjjESOkCwLJCnXovMpudGyz3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhZVQ1EsIVmXtdzKJU0lfEXHVzn1NR8PJjsh87sUS770EYjKaWqKlaPNpK85VZMma
         5PXJa3oS9qKMBnB8PHhi5dn7R4E0l7iwJ6oWG/C3QjX7SNLpHT0IJ1uQftC0J2HYRU
         4MmAPNvybG3lZhfBsTU5Wbyp4QNcm6dBrxCahC5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/168] Bluetooth: hci_h5: Set HCI_UART_RESET_ON_INIT to correct flags
Date:   Mon, 17 Aug 2020 17:17:16 +0200
Message-Id: <20200817143738.942387579@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

[ Upstream commit a7ad4b6119d740b1ec5788f1b98be0fd1c1b5a5a ]

HCI_UART_RESET_ON_INIT belongs in hdev_flags, not flags.

Fixes: ce945552fde4a09 ("Bluetooth: hci_h5: Add support for serdev enumerated devices")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_h5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 8eede1197cd2e..5a68cd4dd71cb 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -803,7 +803,7 @@ static int h5_serdev_probe(struct serdev_device *serdev)
 	if (!h5)
 		return -ENOMEM;
 
-	set_bit(HCI_UART_RESET_ON_INIT, &h5->serdev_hu.flags);
+	set_bit(HCI_UART_RESET_ON_INIT, &h5->serdev_hu.hdev_flags);
 
 	h5->hu = &h5->serdev_hu;
 	h5->serdev_hu.serdev = serdev;
-- 
2.25.1



