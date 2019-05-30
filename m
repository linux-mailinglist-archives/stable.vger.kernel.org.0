Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7162F5E4
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfE3EvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbfE3DK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:58 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36C2E244A6;
        Thu, 30 May 2019 03:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185858;
        bh=n9vu/XathnYo9cp5R+057NGrPTtOcLzi8eigQVORSXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ft9GWfZIuAChojaOKVnyHD4yCSy7GDf1IVcgNp8rqLIwvqL6dtfl9PsvCJdJLKSYi
         OXblf56pV9yJ8CpkxphTF/VZPdChnHwQUXZUaICYAyG36kKKY2wfg4ZQjWVzs8SFjx
         mnGTg8bxx0QbtgKZvo1bFN6EqY5gcBbIdksKF6/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ferry Toth <ftoth@exalondelft.nl>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 144/405] Bluetooth: btbcm: Add default address for BCM43341B
Date:   Wed, 29 May 2019 20:02:22 -0700
Message-Id: <20190530030548.417582869@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5035726128cd2e3813ee44deedb9898509edb232 ]

The BCM43341B has the default MAC address 43:34:1B:00:1F:AC if none
is given. This address was found when enabling Bluetooth on multiple
Intel Edison modules. It also contains the sequence 43341B, the name
the chip identifies itself as. Using the same BD_ADDR is problematic
when having multiple Intel Edison modules in each others range.
The default address also has the LAA (locally administered address)
bit set which prevents a BNEP device from being created, needed for
BT tethering.

Add this to the list of black listed default MAC addresses and let
the user configure a valid one using f.i.
`btmgmt -i hci0 public-addr xx:xx:xx:xx:xx:xx`

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btbcm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index d5d6e6e5da3bf..62d3aa2b26f60 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -37,6 +37,7 @@
 #define BDADDR_BCM43430A0 (&(bdaddr_t) {{0xac, 0x1f, 0x12, 0xa0, 0x43, 0x43}})
 #define BDADDR_BCM4324B3 (&(bdaddr_t) {{0x00, 0x00, 0x00, 0xb3, 0x24, 0x43}})
 #define BDADDR_BCM4330B1 (&(bdaddr_t) {{0x00, 0x00, 0x00, 0xb1, 0x30, 0x43}})
+#define BDADDR_BCM43341B (&(bdaddr_t) {{0xac, 0x1f, 0x00, 0x1b, 0x34, 0x43}})
 
 int btbcm_check_bdaddr(struct hci_dev *hdev)
 {
@@ -82,7 +83,8 @@ int btbcm_check_bdaddr(struct hci_dev *hdev)
 	    !bacmp(&bda->bdaddr, BDADDR_BCM20702A1) ||
 	    !bacmp(&bda->bdaddr, BDADDR_BCM4324B3) ||
 	    !bacmp(&bda->bdaddr, BDADDR_BCM4330B1) ||
-	    !bacmp(&bda->bdaddr, BDADDR_BCM43430A0)) {
+	    !bacmp(&bda->bdaddr, BDADDR_BCM43430A0) ||
+	    !bacmp(&bda->bdaddr, BDADDR_BCM43341B)) {
 		bt_dev_info(hdev, "BCM: Using default device address (%pMR)",
 			    &bda->bdaddr);
 		set_bit(HCI_QUIRK_INVALID_BDADDR, &hdev->quirks);
-- 
2.20.1



