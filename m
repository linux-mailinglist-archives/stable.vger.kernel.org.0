Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB4B333DBE
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhCJNYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232815AbhCJNYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD51864FDA;
        Wed, 10 Mar 2021 13:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382665;
        bh=UxmEYKfC122h6ZT5+Wks9ZNXBZyNwDx3a5vHmRPyK4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvPkjeIITf6m25Mai+vM2ZNJmMbsatEXPALImk8gsEblq7B+2D9nBJIas5yCynlMl
         uxWrsO4RVy1IXFgMTKDm5w12o1J0ynaTLcKngr7BVKSZ9apCv7+O+jkBKmYU7T9apB
         XPhkDUPqnoQ+XHqx0QsqrWQTVahPvKjWhmdYSXh8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/49] Bluetooth: btqca: Add valid le states quirk
Date:   Wed, 10 Mar 2021 14:23:21 +0100
Message-Id: <20210310132322.284338281@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

[ Upstream commit 547801380ec7e6104ea679f599d03c342b4b39a0 ]

WCN3991 supports connectable advertisements so we need to add the valid
le states quirk so the 'central-peripheral' role is exposed in
userspace.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 5c26c7d94173..ad47ff0d55c2 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -78,6 +78,7 @@ enum qca_flags {
 
 enum qca_capabilities {
 	QCA_CAP_WIDEBAND_SPEECH = BIT(0),
+	QCA_CAP_VALID_LE_STATES = BIT(1),
 };
 
 /* HCI_IBS transmit side sleep protocol states */
@@ -1782,7 +1783,7 @@ static const struct qca_device_data qca_soc_data_wcn3991 = {
 		{ "vddch0", 450000 },
 	},
 	.num_vregs = 4,
-	.capabilities = QCA_CAP_WIDEBAND_SPEECH,
+	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
 static const struct qca_device_data qca_soc_data_wcn3998 = {
@@ -2019,11 +2020,17 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 		hdev->shutdown = qca_power_off;
 	}
 
-	/* Wideband speech support must be set per driver since it can't be
-	 * queried via hci.
-	 */
-	if (data && (data->capabilities & QCA_CAP_WIDEBAND_SPEECH))
-		set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED, &hdev->quirks);
+	if (data) {
+		/* Wideband speech support must be set per driver since it can't
+		 * be queried via hci. Same with the valid le states quirk.
+		 */
+		if (data->capabilities & QCA_CAP_WIDEBAND_SPEECH)
+			set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
+				&hdev->quirks);
+
+		if (data->capabilities & QCA_CAP_VALID_LE_STATES)
+			set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+	}
 
 	return 0;
 }
-- 
2.30.1



