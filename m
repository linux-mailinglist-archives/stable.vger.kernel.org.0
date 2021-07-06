Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F1E3BD506
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbhGFMSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236904AbhGFLfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84D8361C31;
        Tue,  6 Jul 2021 11:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570680;
        bh=1gVbLL1kI2FGGL9Jt893bMZph5qvrOclaJZR6CxvTRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4fehHX1kQ1ps447hEqoc2FllCoEa7EJvTWz5HYhlSkbvCsLGdrkkBqtjXexffPNs
         2OE2nJPBQJtwqWy4UwJhQlsgyfhIM2+WN309aRsrc52qIbuXDkdxvkO3BKPGTDrMgU
         sWV4+zoZ8EbIvLdQ9u90sRgn00TxsAT0Ye2QZS2GtPGF5+LU6l0qOo9xsODxDO/B3d
         5gD6VS1UzYmOS2sGVVI2eFS7OevHNo14OnA+tox/tFhdTseHS1hpxbFCp5cbmQP0XZ
         wo94gqqlvqI7Ydg9W5zzzlZfhSi7zGl/2mbwvyn16h8iEgwxPv0cR3NWQhtgHhAcH+
         fi7D59X2xfl9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "mark-yw.chen" <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 121/137] Bluetooth: btusb: Fixed too many in-token issue for Mediatek Chip.
Date:   Tue,  6 Jul 2021 07:21:47 -0400
Message-Id: <20210706112203.2062605-121-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "mark-yw.chen" <mark-yw.chen@mediatek.com>

[ Upstream commit 8454ed9ff9647e31e061fb5eb2e39ce79bc5e960 ]

This patch reduce in-token during download patch procedure.
Don't submit urb for polling event before sending hci command.

Signed-off-by: mark-yw.chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index b1f0b13cc8bc..8195333e5665 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2963,11 +2963,6 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 	struct btmtk_wmt_hdr *hdr;
 	int err;
 
-	/* Submit control IN URB on demand to process the WMT event */
-	err = btusb_mtk_submit_wmt_recv_urb(hdev);
-	if (err < 0)
-		return err;
-
 	/* Send the WMT command and wait until the WMT event returns */
 	hlen = sizeof(*hdr) + wmt_params->dlen;
 	if (hlen > 255)
@@ -2989,6 +2984,11 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 		return err;
 	}
 
+	/* Submit control IN URB on demand to process the WMT event */
+	err = btusb_mtk_submit_wmt_recv_urb(hdev);
+	if (err < 0)
+		return err;
+
 	/* The vendor specific WMT commands are all answered by a vendor
 	 * specific event and will have the Command Status or Command
 	 * Complete as with usual HCI command flow control.
-- 
2.30.2

