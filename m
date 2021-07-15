Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875973CA752
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbhGOSxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240600AbhGOSwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:52:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F6DE613DA;
        Thu, 15 Jul 2021 18:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374997;
        bh=MIpPlt2InQnT8qzde8yvEHCB5YK491okDvSk97Nhqak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7qPGSBRNKS00IebgOsry6rCEqphODZC/ud339SwNscdr7vrstImL74Twt/Q35lNa
         2VcKduC/jjWZkFqvxM/BFmB+3rPGftf0Tu7iyhTrboTnH73wM2T4XBJK61CC9xAQRu
         dKIYc2lCDOnecos+bHcXN9agSjSJCE88ubdwvlHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "mark-yw.chen" <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/215] Bluetooth: btusb: Fixed too many in-token issue for Mediatek Chip.
Date:   Thu, 15 Jul 2021 20:38:08 +0200
Message-Id: <20210715182620.059768078@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: mark-yw.chen <mark-yw.chen@mediatek.com>

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



