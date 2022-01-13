Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800FE48D5EE
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 11:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiAMKnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 05:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiAMKnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 05:43:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA44BC06173F
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 02:43:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68CC661C32
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 10:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407F9C36AE3;
        Thu, 13 Jan 2022 10:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642070590;
        bh=ASWo2v9+r+y/gO7toxSA7jxLw+IXRyd+SXUVcCQEKdU=;
        h=Subject:To:Cc:From:Date:From;
        b=VfxHXQ5vOT44Kq6+zBDhgnXH557Pb97WrK/BOhHpFQovxglOPTWiymTEXkmyA4ZKY
         /2L8OuzaBNkG2Ld68b/DcFI9uKVuEa/vLDiOwbBvb0IrW/1oBDaX3gqMq+Yo27W8hk
         RG1eGHxRB+mYfLNFBI4+LSQOVNWDJi/H8uBtSzGo=
Subject: FAILED: patch "[PATCH] Bluetooth: btusb: Handle download_firmware failure cases" failed to apply to 5.15-stable tree
To:     mark-yw.chen@mediatek.com, marcel@holtmann.org,
        sean.wang@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Jan 2022 11:43:08 +0100
Message-ID: <1642070588161168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 00c0ee9850b7b0cb7c40b8daba806ae2245e59d4 Mon Sep 17 00:00:00 2001
From: Mark Chen <mark-yw.chen@mediatek.com>
Date: Tue, 7 Dec 2021 01:33:42 +0800
Subject: [PATCH] Bluetooth: btusb: Handle download_firmware failure cases

For Mediatek chipset, it can not enabled if there are something wrong
in btmtk_setup_firmware_79xx(). Thus, the process must be terminated
and returned error code.

Fixes: fc342c4dc4087 ("Bluetooth: btusb: Add protocol support for MediaTek MT7921U USB devices")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Mark Chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index fda5622b1d6e..c9619096d763 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2633,6 +2633,10 @@ static int btusb_mtk_setup(struct hci_dev *hdev)
 			 dev_id & 0xffff, (fw_version & 0xff) + 1);
 		err = btmtk_setup_firmware_79xx(hdev, fw_bin_name,
 						btusb_mtk_hci_wmt_sync);
+		if (err < 0) {
+			bt_dev_err(hdev, "Failed to set up firmware (%d)", err);
+			return err;
+		}
 
 		/* It's Device EndPoint Reset Option Register */
 		btusb_mtk_uhw_reg_write(data, MTK_EP_RST_OPT, MTK_EP_RST_IN_OUT_OPT);

