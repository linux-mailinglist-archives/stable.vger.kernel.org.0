Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C810C60892A
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiJVIbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbiJVI3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:29:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDB72E38E2;
        Sat, 22 Oct 2022 01:02:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 067BFB82E15;
        Sat, 22 Oct 2022 07:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55312C433C1;
        Sat, 22 Oct 2022 07:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424646;
        bh=jUXwn7KHB5zBLuslpmUGxlvhoJHk8Cr4CZPjaxdURag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4z6GNUVffkOsELd6eGUWNy4c8m4md/IcYS0FiyzfkQootkNGBT2OhXDHgG3rsIA8
         zA+WMM795Umssa41orYmOlmKIl/0LY44PqWAxARUe/roQXoqI84MSAVdZyLxgsAqdc
         xa+FvBKShqZ+/bhculEXkRa9cS6R47f05Yd888SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Cai <jing.cai@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 223/717] Bluetooth: btusb: mediatek: fix WMT failure during runtime suspend
Date:   Sat, 22 Oct 2022 09:21:42 +0200
Message-Id: <20221022072454.584448188@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index aaba2d737178..6a320ece3276 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2451,15 +2451,29 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 
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
 		goto err_free_wc;
 
-- 
2.35.1



