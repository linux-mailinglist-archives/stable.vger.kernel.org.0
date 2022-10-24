Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EB860A890
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiJXNH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235360AbiJXNGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:06:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA91B2CE22;
        Mon, 24 Oct 2022 05:20:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F27A611B0;
        Mon, 24 Oct 2022 12:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750B2C433C1;
        Mon, 24 Oct 2022 12:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614034;
        bh=nL/pAzm+dIZFsdEKGBzZs3U4ggfZzyn+WAnDW5EQt4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOeot6D9ih3nzfvvNX5WN3spDLUyPR9tvuJ5Y/agP0H+HHpxSuB8Nk+25hNMQ7DW1
         bN3SZLa7ZAzWEapUD0fWMguRvJXAAt4vvftNI1AwqiSst6VvE4ojisMTaWumXt/hC2
         UWJ3xC1zoDQ1if5bD+D7cwRerB+/qyvmqEwhOcmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/390] Bluetooth: btusb: fix excessive stack usage
Date:   Mon, 24 Oct 2022 13:28:24 +0200
Message-Id: <20221024113027.248824888@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 10888140f09c3472146dc206accd0cfa051d0ed4 ]

Enlarging the size of 'struct btmtk_hci_wmt_cmd' makes it no longer
fit on the kernel stack, as seen from this compiler warning:

drivers/bluetooth/btusb.c:3365:12: error: stack frame size of 1036 bytes in function 'btusb_mtk_hci_wmt_sync' [-Werror,-Wframe-larger-than=]

Change the function to dynamically allocate the buffer instead.
As there are other sleeping functions called from the same location,
using GFP_KERNEL should be fine here, and the runtime overhead should
not matter as this is rarely called.

Unfortunately, I could not figure out why the message size is
increased in the previous patch. Using dynamic allocation means
any size is possible now, but there is still a range check that
limits the total size (including the five-byte header) to 255
bytes, so whatever was intended there is now undone.

Fixes: 48c13301e6ba ("Bluetooth: btusb: Fine-tune mt7663 mechanism.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: fd3f106677ba ("Bluetooth: btusb: mediatek: fix WMT failure during runtime suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index eb6e33d168d8..80a3d5019950 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2832,7 +2832,7 @@ struct btmtk_wmt_hdr {
 
 struct btmtk_hci_wmt_cmd {
 	struct btmtk_wmt_hdr hdr;
-	u8 data[1000];
+	u8 data[];
 } __packed;
 
 struct btmtk_hci_wmt_evt {
@@ -3011,7 +3011,7 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 	struct btmtk_hci_wmt_evt_funcc *wmt_evt_funcc;
 	u32 hlen, status = BTMTK_WMT_INVALID;
 	struct btmtk_hci_wmt_evt *wmt_evt;
-	struct btmtk_hci_wmt_cmd wc;
+	struct btmtk_hci_wmt_cmd *wc;
 	struct btmtk_wmt_hdr *hdr;
 	int err;
 
@@ -3020,20 +3020,24 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 	if (hlen > 255)
 		return -EINVAL;
 
-	hdr = (struct btmtk_wmt_hdr *)&wc;
+	wc = kzalloc(hlen, GFP_KERNEL);
+	if (!wc)
+		return -ENOMEM;
+
+	hdr = &wc->hdr;
 	hdr->dir = 1;
 	hdr->op = wmt_params->op;
 	hdr->dlen = cpu_to_le16(wmt_params->dlen + 1);
 	hdr->flag = wmt_params->flag;
-	memcpy(wc.data, wmt_params->data, wmt_params->dlen);
+	memcpy(wc->data, wmt_params->data, wmt_params->dlen);
 
 	set_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags);
 
-	err = __hci_cmd_send(hdev, 0xfc6f, hlen, &wc);
+	err = __hci_cmd_send(hdev, 0xfc6f, hlen, wc);
 
 	if (err < 0) {
 		clear_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags);
-		return err;
+		goto err_free_wc;
 	}
 
 	/* Submit control IN URB on demand to process the WMT event */
@@ -3055,13 +3059,14 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 	if (err == -EINTR) {
 		bt_dev_err(hdev, "Execution of wmt command interrupted");
 		clear_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags);
-		return err;
+		goto err_free_wc;
 	}
 
 	if (err) {
 		bt_dev_err(hdev, "Execution of wmt command timed out");
 		clear_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags);
-		return -ETIMEDOUT;
+		err = -ETIMEDOUT;
+		goto err_free_wc;
 	}
 
 	/* Parse and handle the return WMT event */
@@ -3097,7 +3102,8 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 err_free_skb:
 	kfree_skb(data->evt_skb);
 	data->evt_skb = NULL;
-
+err_free_wc:
+	kfree(wc);
 	return err;
 }
 
-- 
2.35.1



