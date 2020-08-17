Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4A62470B7
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390451AbgHQSNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731062AbgHQQGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:06:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A465720B1F;
        Mon, 17 Aug 2020 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680404;
        bh=rPYc3AInrmGfeTHQs2L3TSEMnna29Wvbsg8g5ZM1mDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BTA/cftcnlXf5lM7a3y+7ZQAs/EZg3TaZ0rVZWglWgpMQrt5KgN3D38m+IsgCh+S
         H9RZfqJhZIGkQwQIBaL3LVNqDXk3i6NreF91yFnH2/uqVtnxPJHg4UyYSAOVAN2lw2
         VpctZzlNbTV5PhlMeSp44ock/XMTDJT8H0qaaHHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 174/270] Bluetooth: hci_h5: Set HCI_UART_RESET_ON_INIT to correct flags
Date:   Mon, 17 Aug 2020 17:16:15 +0200
Message-Id: <20200817143804.488785996@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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
index dacf297baf595..5df0651b6cd55 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -790,7 +790,7 @@ static int h5_serdev_probe(struct serdev_device *serdev)
 	if (!h5)
 		return -ENOMEM;
 
-	set_bit(HCI_UART_RESET_ON_INIT, &h5->serdev_hu.flags);
+	set_bit(HCI_UART_RESET_ON_INIT, &h5->serdev_hu.hdev_flags);
 
 	h5->hu = &h5->serdev_hu;
 	h5->serdev_hu.serdev = serdev;
-- 
2.25.1



