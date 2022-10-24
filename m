Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A70360B08B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiJXQGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbiJXQEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:04:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332EB2037A;
        Mon, 24 Oct 2022 07:57:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A534B8163F;
        Mon, 24 Oct 2022 12:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8142C433C1;
        Mon, 24 Oct 2022 12:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614032;
        bh=wpKkHDRmyTSy6cvFrclZFS/LNJIZ/HR7B2aaDTv16G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4duEwLj9KZW+1HmYDnPsp5zo2PGKfF+m+/Pn05fZobZHPLW7snYXqwmuK11gl8Ji
         1nvVj8qT/js/Nr4zFRKobdlTbTu0rsa3YyhEF7X/XEVgUUqvBcSdzlk83B81zqU/EU
         LVKByTtanpwhpZeP0XerTTllbJ3cesEwaxAew15A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Chen <Mark-YW.Chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/390] Bluetooth: btusb: Fine-tune mt7663 mechanism.
Date:   Mon, 24 Oct 2022 13:28:23 +0200
Message-Id: <20221024113027.200760921@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Chen <Mark-YW.Chen@mediatek.com>

[ Upstream commit 48c13301e6baba5fd0960b412af519c0baa98011 ]

Fine-tune read register for mt7663/mt7921.
For mediatek chip spcific wmt protocol, we add more delay to send EP0
In-Token.

Signed-off-by: Mark Chen <Mark-YW.Chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: fd3f106677ba ("Bluetooth: btusb: mediatek: fix WMT failure during runtime suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a699e6166aef..eb6e33d168d8 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2816,6 +2816,7 @@ enum {
 enum {
 	BTMTK_WMT_INVALID,
 	BTMTK_WMT_PATCH_UNDONE,
+	BTMTK_WMT_PATCH_PROGRESS,
 	BTMTK_WMT_PATCH_DONE,
 	BTMTK_WMT_ON_UNDONE,
 	BTMTK_WMT_ON_DONE,
@@ -2831,7 +2832,7 @@ struct btmtk_wmt_hdr {
 
 struct btmtk_hci_wmt_cmd {
 	struct btmtk_wmt_hdr hdr;
-	u8 data[256];
+	u8 data[1000];
 } __packed;
 
 struct btmtk_hci_wmt_evt {
@@ -2934,7 +2935,7 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 	 * to generate the event. Otherwise, the WMT event cannot return from
 	 * the device successfully.
 	 */
-	udelay(100);
+	udelay(500);
 
 	usb_anchor_urb(urb, &data->ctrl_anchor);
 	err = usb_submit_urb(urb, GFP_ATOMIC);
@@ -3238,9 +3239,9 @@ static int btusb_mtk_reg_read(struct btusb_data *data, u32 reg, u32 *val)
 	return err;
 }
 
-static int btusb_mtk_id_get(struct btusb_data *data, u32 *id)
+static int btusb_mtk_id_get(struct btusb_data *data, u32 reg, u32 *id)
 {
-	return btusb_mtk_reg_read(data, 0x80000008, id);
+	return btusb_mtk_reg_read(data, reg, id);
 }
 
 static int btusb_mtk_setup(struct hci_dev *hdev)
@@ -3258,7 +3259,7 @@ static int btusb_mtk_setup(struct hci_dev *hdev)
 
 	calltime = ktime_get();
 
-	err = btusb_mtk_id_get(data, &dev_id);
+	err = btusb_mtk_id_get(data, 0x80000008, &dev_id);
 	if (err < 0) {
 		bt_dev_err(hdev, "Failed to get device id (%d)", err);
 		return err;
-- 
2.35.1



