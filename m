Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906EB409192
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244002AbhIMOCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243837AbhIMOAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F326613AB;
        Mon, 13 Sep 2021 13:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540255;
        bh=L5THohV6IidN9Kc/xggYUb7EwyTAIEaF9O9yKpIKOhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCcG7wWidPz40YwQ/uGaXeaXtL4sjOQC4/iF2fMxxg6JH9Dy92or2SSSUWOdqGSli
         8IVEl/zdDDK6EjCS9+NpfcFcqO1sNxDu4eZbTOEwxZXDLh2ox8DpfxG8rp5IjaI5fz
         jV/95zLjO4Twl7lXuB87RNe2sqgPyDdryBcF8cQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Miao <jun.miao@windriver.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 117/300] Bluetooth: btusb: Fix a unspported condition to set available debug features
Date:   Mon, 13 Sep 2021 15:12:58 +0200
Message-Id: <20210913131113.349744024@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
index 9122f9cc97cb..ae0cf5e71584 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2912,10 +2912,11 @@ static int btusb_setup_intel_new(struct hci_dev *hdev)
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
@@ -3008,10 +3009,11 @@ static int btusb_setup_intel_newgen(struct hci_dev *hdev)
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



