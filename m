Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A0A3BD1A5
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbhGFLj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237253AbhGFLgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 700F861ED3;
        Tue,  6 Jul 2021 11:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570788;
        bh=YKDKaRGl7fO7ELmzr9hBkOFhBeqnWCkO4x0aW4zfCPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LV5S6k/nPF7tUbmUa1I+tjokFUrBsh9V/vgIDhZ/o/hF5Iw35csRC6Y4HUanRDH7L
         M9Dr9DXL/f5S+gGjO3LcwUPdDTBEFnSXYdayJODuFzFa2qfcGUgUtj3A4tM8S+YhZS
         tJIRebgctlR+T0AyrHxhxVDjNsMhtt3labW8nAoVCMR9vYINSDQxNBhz0a7voolQRi
         9EwAyqU9/3V/4+ksZd9Lh9oX0NsgNxCoMpK/1PORj5JIp7EUw+oRsgn/s2SYzhMO1m
         VHGxCke2/N/0EHKj3vZnOHOS60wnscEXpXOw47pHcRM/2DgQh/IQ3mHLiiWxbtWVc4
         1JvdOpLfy9iFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "mark-yw.chen" <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 67/74] Bluetooth: btusb: Fixed too many in-token issue for Mediatek Chip.
Date:   Tue,  6 Jul 2021 07:24:55 -0400
Message-Id: <20210706112502.2064236-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index b467fd05c5e8..27ff7a6e2fc9 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2700,11 +2700,6 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
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
@@ -2726,6 +2721,11 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
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

