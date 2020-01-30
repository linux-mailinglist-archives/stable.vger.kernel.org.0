Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B2E14E1A8
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbgA3Sqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:46:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731205AbgA3Sq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:46:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3E3520674;
        Thu, 30 Jan 2020 18:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409988;
        bh=vVzGl/1LrNLQUWSDodjDFOxHqfKPOheroeyONEUOIAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbOjZYsAreMswFh4xQflWn+MXQDsqOpSA6zneMCV5npIGikW9gcfcn/oWH1HMv1O0
         ISzJRuJ591bo8QVYgxah0r+cKt2t6rSaci6Jsji2Xl+XeS7AxCHTeXqD0+nr1RuHfw
         BYYXGQCELOHcij3AxvLo5r6ADxdmUGNTOZgdQcOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Andre Heider <a.heider@gmail.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/110] Bluetooth: Allow combination of BDADDR_PROPERTY and INVALID_BDADDR quirks
Date:   Thu, 30 Jan 2020 19:39:13 +0100
Message-Id: <20200130183625.357467844@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

[ Upstream commit 7fdf6c6a0d0e032aac2aa4537a23af1e04a397ce ]

When utilizing BDADDR_PROPERTY and INVALID_BDADDR quirks together it
results in an unconfigured controller even if the bootloader provides
a valid address. Fix this by allowing a bootloader provided address
to mark the controller as configured.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Tested-by: Andre Heider <a.heider@gmail.com>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0cc9ce9172229..9e19d5a3aac87 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1444,11 +1444,20 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 
 	if (hci_dev_test_flag(hdev, HCI_SETUP) ||
 	    test_bit(HCI_QUIRK_NON_PERSISTENT_SETUP, &hdev->quirks)) {
+		bool invalid_bdaddr;
+
 		hci_sock_dev_event(hdev, HCI_DEV_SETUP);
 
 		if (hdev->setup)
 			ret = hdev->setup(hdev);
 
+		/* The transport driver can set the quirk to mark the
+		 * BD_ADDR invalid before creating the HCI device or in
+		 * its setup callback.
+		 */
+		invalid_bdaddr = test_bit(HCI_QUIRK_INVALID_BDADDR,
+					  &hdev->quirks);
+
 		if (ret)
 			goto setup_failed;
 
@@ -1457,20 +1466,33 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 				hci_dev_get_bd_addr_from_property(hdev);
 
 			if (bacmp(&hdev->public_addr, BDADDR_ANY) &&
-			    hdev->set_bdaddr)
+			    hdev->set_bdaddr) {
 				ret = hdev->set_bdaddr(hdev,
 						       &hdev->public_addr);
+
+				/* If setting of the BD_ADDR from the device
+				 * property succeeds, then treat the address
+				 * as valid even if the invalid BD_ADDR
+				 * quirk indicates otherwise.
+				 */
+				if (!ret)
+					invalid_bdaddr = false;
+			}
 		}
 
 setup_failed:
 		/* The transport driver can set these quirks before
 		 * creating the HCI device or in its setup callback.
 		 *
+		 * For the invalid BD_ADDR quirk it is possible that
+		 * it becomes a valid address if the bootloader does
+		 * provide it (see above).
+		 *
 		 * In case any of them is set, the controller has to
 		 * start up as unconfigured.
 		 */
 		if (test_bit(HCI_QUIRK_EXTERNAL_CONFIG, &hdev->quirks) ||
-		    test_bit(HCI_QUIRK_INVALID_BDADDR, &hdev->quirks))
+		    invalid_bdaddr)
 			hci_dev_set_flag(hdev, HCI_UNCONFIGURED);
 
 		/* For an unconfigured controller it is required to
-- 
2.20.1



