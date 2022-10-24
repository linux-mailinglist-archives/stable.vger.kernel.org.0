Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE4D60A877
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbiJXNGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbiJXNEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:04:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409DC82D32;
        Mon, 24 Oct 2022 05:20:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0338061017;
        Mon, 24 Oct 2022 12:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CD1C433C1;
        Mon, 24 Oct 2022 12:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614037;
        bh=OV4m7KUP2Ogn00c80OLzn4F/OXzDpQCCIO99uKCA0Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsuIQNO5X6/j0c4sZeLI3TWMumJixrB1g6MGEFu3vRkr3XQvNSMbswFSvYiAG4P2N
         TJSxzLmzActcnNaUhS+M5hwe5Wd7UxEJ8cwczmGUnO3repqXYDkFXq0mkfqsp1DQdx
         g/RxUha8uTVk5w+/ZWeXtKDXq+LOXgJe7zUKyESM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Cai <jing.cai@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/390] Bluetooth: btusb: mediatek: fix WMT failure during runtime suspend
Date:   Mon, 24 Oct 2022 13:28:25 +0200
Message-Id: <20221024113027.300885336@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit fd3f106677bac70437dc12e76c827294ed495a44 ]

WMT cmd/event doesn't follow up the generic HCI cmd/event handling, it
needs constantly polling control pipe until the host received the WMT
event, thus, we should require to specifically acquire PM counter on the
USB to prevent the interface from entering auto suspended while WMT
cmd/event in progress.

Fixes: a1c49c434e15 ("Bluetooth: btusb: Add protocol support for MediaTek MT7668U USB devices")
Co-developed-by: Jing Cai <jing.cai@mediatek.com>
Signed-off-by: Jing Cai <jing.cai@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 80a3d5019950..6efd981979bd 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3033,15 +3033,29 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 
 	set_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags);
 
+	/* WMT cmd/event doesn't follow up the generic HCI cmd/event handling,
+	 * it needs constantly polling control pipe until the host received the
+	 * WMT event, thus, we should require to specifically acquire PM counter
+	 * on the USB to prevent the interface from entering auto suspended
+	 * while WMT cmd/event in progress.
+	 */
+	err = usb_autopm_get_interface(data->intf);
+	if (err < 0)
+		goto err_free_wc;
+
 	err = __hci_cmd_send(hdev, 0xfc6f, hlen, wc);
 
 	if (err < 0) {
 		clear_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags);
+		usb_autopm_put_interface(data->intf);
 		goto err_free_wc;
 	}
 
 	/* Submit control IN URB on demand to process the WMT event */
 	err = btusb_mtk_submit_wmt_recv_urb(hdev);
+
+	usb_autopm_put_interface(data->intf);
+
 	if (err < 0)
 		return err;
 
-- 
2.35.1



