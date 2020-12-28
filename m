Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D4C2E3D75
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440750AbgL1OPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440745AbgL1OPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C2F6229C6;
        Mon, 28 Dec 2020 14:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164932;
        bh=xw/Iij3mizGN/qFXcg3m4aUNkCXqNiN65UAqvml23bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pfppLsomKfBtznZvivdoZSsLkrRD3JIjbAXIKRrwq5LRIlD/m03KuCdws99vog0cX
         2b+u5tL6gcFna0c1aJX9FNlPZqy0FfROo0ki998Fr8jaVizdyRewD82uk1cvrtIWvD
         ukjOUEPXKJCrxTeMWMfzup/J9bQjmU4m12Bagaqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 343/717] Bluetooth: btusb: Fix detection of some fake CSR controllers with a bcdDevice val of 0x0134
Date:   Mon, 28 Dec 2020 13:45:41 +0100
Message-Id: <20201228125037.459860075@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d74e0ae7e03032b47b8631cc1e52a7ae1ce988c0 ]

Commit cde1a8a99287 ("Bluetooth: btusb: Fix and detect most of the
Chinese Bluetooth controllers") made the detection of fake controllers
more generic fixing it for much of the newer fakes / clones.

But this does not work for a fake CSR controller with a bcdDevice
value of 0x0134, which was correctly identified as fake before
this change.

Add an extra check for this special case, checking for a combination
of a bcdDevice value of 0x0134, together with a lmp_subver of 0x0c5c
and a hci_ver of BLUETOOTH_VER_2_0.

The chip inside this fake dongle is marked as with "clockwise cw6629d".

Fixes: cde1a8a99287 ("Bluetooth: btusb: Fix and detect most of the Chinese Bluetooth controllers")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a9981678199d7..80468745d5c5e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1763,6 +1763,8 @@ static int btusb_setup_bcm92035(struct hci_dev *hdev)
 
 static int btusb_setup_csr(struct hci_dev *hdev)
 {
+	struct btusb_data *data = hci_get_drvdata(hdev);
+	u16 bcdDevice = le16_to_cpu(data->udev->descriptor.bcdDevice);
 	struct hci_rp_read_local_version *rp;
 	struct sk_buff *skb;
 	bool is_fake = false;
@@ -1832,6 +1834,12 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		 le16_to_cpu(rp->hci_ver) > BLUETOOTH_VER_4_0)
 		is_fake = true;
 
+	/* Other clones which beat all the above checks */
+	else if (bcdDevice == 0x0134 &&
+		 le16_to_cpu(rp->lmp_subver) == 0x0c5c &&
+		 le16_to_cpu(rp->hci_ver) == BLUETOOTH_VER_2_0)
+		is_fake = true;
+
 	if (is_fake) {
 		bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; adding workarounds...");
 
-- 
2.27.0



