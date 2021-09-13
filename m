Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21815409459
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242287AbhIMOax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344780AbhIMO2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:28:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F5A161B61;
        Mon, 13 Sep 2021 13:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541002;
        bh=au6tdu5mnSA7gUeuzh/WYg1gf/zwi0eeaZEPu9fhJB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CupWcnGFr4yNcvd0eC5wSiyCBJXhcQrUHsE9cMKE8vNLbWfbJyEUneaDgc0zjyt9T
         D/ujD5/3j5mF3631xy0V9BPGiB+T7MOIZ0g0PStlzCpWOxFHfD2fx5mwJsZla8svZu
         whH/CqJIYh7dQS46XWcHW1TqtJEgZ1w+NpAuSKbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Miao <jun.miao@windriver.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 122/334] Bluetooth: btusb: Fix a unspported condition to set available debug features
Date:   Mon, 13 Sep 2021 15:12:56 +0200
Message-Id: <20210913131117.498076291@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun Miao <jun.miao@windriver.com>

[ Upstream commit 20a831f04f1526f2c3442efd3dece8630216b5d2 ]

When reading the support debug features failed, there are not available
features init. Continue to set the debug features is illogical, we should
skip btintel_set_debug_features(), even if check it by "if (!features)".

Fixes: c453b10c2b28 ("Bluetooth: btusb: Configure Intel debug feature based on available support")
Signed-off-by: Jun Miao <jun.miao@windriver.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 0255bf243ce5..bd37d6fb88c2 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2921,10 +2921,11 @@ static int btusb_setup_intel_new(struct hci_dev *hdev)
 	/* Read the Intel supported features and if new exception formats
 	 * supported, need to load the additional DDC config to enable.
 	 */
-	btintel_read_debug_features(hdev, &features);
-
-	/* Set DDC mask for available debug features */
-	btintel_set_debug_features(hdev, &features);
+	err = btintel_read_debug_features(hdev, &features);
+	if (!err) {
+		/* Set DDC mask for available debug features */
+		btintel_set_debug_features(hdev, &features);
+	}
 
 	/* Read the Intel version information after loading the FW  */
 	err = btintel_read_version(hdev, &ver);
@@ -3017,10 +3018,11 @@ static int btusb_setup_intel_newgen(struct hci_dev *hdev)
 	/* Read the Intel supported features and if new exception formats
 	 * supported, need to load the additional DDC config to enable.
 	 */
-	btintel_read_debug_features(hdev, &features);
-
-	/* Set DDC mask for available debug features */
-	btintel_set_debug_features(hdev, &features);
+	err = btintel_read_debug_features(hdev, &features);
+	if (!err) {
+		/* Set DDC mask for available debug features */
+		btintel_set_debug_features(hdev, &features);
+	}
 
 	/* Read the Intel version information after loading the FW  */
 	err = btintel_read_version_tlv(hdev, &version);
-- 
2.30.2



