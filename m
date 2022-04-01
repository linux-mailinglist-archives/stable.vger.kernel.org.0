Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71684EF0C8
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347815AbiDAOgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348253AbiDAOdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBFB1EC60D;
        Fri,  1 Apr 2022 07:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FD3B61C1D;
        Fri,  1 Apr 2022 14:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266DBC340EE;
        Fri,  1 Apr 2022 14:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823491;
        bh=qwb1WY2jHtNY5Hm+ktnqHKmRUzT0l4+oqODn1UVDDVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avi4Sa8x0tBd9rdhYG3kwbuFxLs8fYqC3bQ7e2RYIj6PGtddKx8CewLyCS+x72Xd6
         4WR206OXivkTZ/Z7BAxyATRBWzAmL9ChUWImdtveLAw85uNtdK/qiG4jcA2H70PJXy
         /A5bGldjD0IDZERcWWYboZRm9YKpFHscvJVJ7Qg9nTEW4faupXSCmH989PS/yswTO/
         tJpayP5K63nbu6yOZ4H7sVER4UdzuuQcqPIzsCe5ZiGa52EkaJyIVD6+ZH7q5SEDeB
         WjC1ffeYAbcBj6IcKRT1BC4zTOuHC/hexqEnm77haOv9SDSZXlkK/E3uQLvsnAvSzC
         7aUjmznOXpm+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, matthias.bgg@gmail.com,
        linux-bluetooth@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 116/149] Bluetooth: mediatek: fix the conflict between mtk and msft vendor event
Date:   Fri,  1 Apr 2022 10:25:03 -0400
Message-Id: <20220401142536.1948161-116-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b5ea8d3bffaa..a295a9389892 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -284,13 +284,6 @@ static int btmtksdio_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
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
@@ -306,7 +299,7 @@ static int btmtksdio_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 	if (err < 0)
 		goto err_free_skb;
 
-	if (hdr->evt == HCI_EV_VENDOR) {
+	if (hdr->evt == HCI_EV_WMT) {
 		if (test_and_clear_bit(BTMTKSDIO_TX_WAIT_VND_EVT,
 				       &bdev->tx_state)) {
 			/* Barrier to sync with other CPUs */
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c30d131da784..0959d10a6b84 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2245,7 +2245,6 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 {
 	struct hci_dev *hdev = urb->context;
 	struct btusb_data *data = hci_get_drvdata(hdev);
-	struct hci_event_hdr *hdr;
 	struct sk_buff *skb;
 	int err;
 
@@ -2265,13 +2264,6 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
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
2.34.1

