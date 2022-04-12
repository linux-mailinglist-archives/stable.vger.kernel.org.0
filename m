Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E725E4FD62A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354275AbiDLHvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357133AbiDLHjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E606E0ED;
        Tue, 12 Apr 2022 00:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF3FC61701;
        Tue, 12 Apr 2022 07:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD63FC385A8;
        Tue, 12 Apr 2022 07:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747554;
        bh=uI2XgojJVRs/M3pnMPo98r1Z61W5OShYvXRzR0APpwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cp7rxEM4xb3iEOJNMu7B7r0Y0p4BWvVGRcNvmPDcxTzoGR6T1LrL93b4gbGYbIxyK
         1pc445j9KrbCPOafqAVsGoWa1AogEjIeOzF3RtgsaciaiKE+sZ2vBLz0DF/XIq6uzD
         EbcjW0NIO21aZ083fxjVrpvTV6BkwqzpNbBlhd6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 122/343] Bluetooth: mediatek: fix the conflict between mtk and msft vendor event
Date:   Tue, 12 Apr 2022 08:29:00 +0200
Message-Id: <20220412062954.907253389@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit e4412654e260842e1a94ffe0d4026e8a6fd34246 ]

There is a conflict between MediaTek wmt event and msft vendor extension
logic in the core layer since 145373cb1b1f ("Bluetooth: Add framework for
Microsoft vendor extension") was introduced because we changed the type of
mediatek wmt event to the type of msft vendor event in the driver.

But the purpose we reported mediatek event to the core layer is for the
diagnostic purpose with that we are able to see the full packet trace via
monitoring socket with btmon. Thus, it is harmless we keep the original
type of mediatek vendor event here to avoid breaking the msft extension
function especially they can be supported by Mediatek chipset like MT7921
, MT7922 devices and future devices.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.h     | 1 +
 drivers/bluetooth/btmtksdio.c | 9 +--------
 drivers/bluetooth/btusb.c     | 8 --------
 3 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/bluetooth/btmtk.h b/drivers/bluetooth/btmtk.h
index 6e7b0c7567c0..0defa68bc2ce 100644
--- a/drivers/bluetooth/btmtk.h
+++ b/drivers/bluetooth/btmtk.h
@@ -5,6 +5,7 @@
 #define FIRMWARE_MT7668		"mediatek/mt7668pr2h.bin"
 #define FIRMWARE_MT7961		"mediatek/BT_RAM_CODE_MT7961_1_2_hdr.bin"
 
+#define HCI_EV_WMT 0xe4
 #define HCI_WMT_MAX_EVENT_SIZE		64
 
 #define BTMTK_WMT_REG_READ 0x2
diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 9b868f187316..ecf29cfa7d79 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -370,13 +370,6 @@ static int btmtksdio_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 	struct hci_event_hdr *hdr = (void *)skb->data;
 	int err;
 
-	/* Fix up the vendor event id with 0xff for vendor specific instead
-	 * of 0xe4 so that event send via monitoring socket can be parsed
-	 * properly.
-	 */
-	if (hdr->evt == 0xe4)
-		hdr->evt = HCI_EV_VENDOR;
-
 	/* When someone waits for the WMT event, the skb is being cloned
 	 * and being processed the events from there then.
 	 */
@@ -392,7 +385,7 @@ static int btmtksdio_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 	if (err < 0)
 		goto err_free_skb;
 
-	if (hdr->evt == HCI_EV_VENDOR) {
+	if (hdr->evt == HCI_EV_WMT) {
 		if (test_and_clear_bit(BTMTKSDIO_TX_WAIT_VND_EVT,
 				       &bdev->tx_state)) {
 			/* Barrier to sync with other CPUs */
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 2afbd87d77c9..42234d5f602d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2254,7 +2254,6 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 {
 	struct hci_dev *hdev = urb->context;
 	struct btusb_data *data = hci_get_drvdata(hdev);
-	struct hci_event_hdr *hdr;
 	struct sk_buff *skb;
 	int err;
 
@@ -2274,13 +2273,6 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 		hci_skb_pkt_type(skb) = HCI_EVENT_PKT;
 		skb_put_data(skb, urb->transfer_buffer, urb->actual_length);
 
-		hdr = (void *)skb->data;
-		/* Fix up the vendor event id with 0xff for vendor specific
-		 * instead of 0xe4 so that event send via monitoring socket can
-		 * be parsed properly.
-		 */
-		hdr->evt = 0xff;
-
 		/* When someone waits for the WMT event, the skb is being cloned
 		 * and being processed the events from there then.
 		 */
-- 
2.35.1



