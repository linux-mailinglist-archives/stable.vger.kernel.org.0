Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB8236A9A
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 06:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfFFEHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 00:07:45 -0400
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:52218 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfFFEHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 00:07:45 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id x5647ERX006961; Thu, 6 Jun 2019 13:07:14 +0900
X-Iguazu-Qid: 34trdEsBZTUulAggGI
X-Iguazu-QSIG: v=2; s=0; t=1559794027; q=34trdEsBZTUulAggGI; m=LSdtFINHztV/BukiEG0K3ggPH4MxFEHcJEFn433lJtA=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1513) id x56474Av008552;
        Thu, 6 Jun 2019 13:07:05 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id x56474Om000482;
        Thu, 6 Jun 2019 13:07:04 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id x56473NH025568;
        Thu, 6 Jun 2019 13:07:04 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Christian Panton <christian@panton.org>,
        "David S . Miller" <davem@davemloft.net>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4.y] net: cdc_ncm: GetNtbFormat endian fix
Date:   Thu,  6 Jun 2019 13:06:55 +0900
X-TSB-HOP: ON
Message-Id: <20190606040655.28042-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

commit 6314dab4b8fb8493d810e175cb340376052c69b6 upstream.

The GetNtbFormat and SetNtbFormat requests operate on 16 bit little
endian values. We get away with ignoring this most of the time, because
we only care about USB_CDC_NCM_NTB16_FORMAT which is 0x0000.  This
fails for USB_CDC_NCM_NTB32_FORMAT.

Fix comparison between LE value from device and constant by converting
the constant to LE.

Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Fixes: 2b02c20ce0c2 ("cdc_ncm: Set NTB format again after altsetting switch for Huawei devices")
Cc: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: Christian Panton <christian@panton.org>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-By: Enrico Mioso <mrkiko.rs@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/usb/cdc_ncm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 36e1377fc954..1e921e5eddc7 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -727,7 +727,7 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
 	int err;
 	u8 iface_no;
 	struct usb_cdc_parsed_header hdr;
-	u16 curr_ntb_format;
+	__le16 curr_ntb_format;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -841,7 +841,7 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
 			goto error2;
 		}
 
-		if (curr_ntb_format == USB_CDC_NCM_NTB32_FORMAT) {
+		if (curr_ntb_format == cpu_to_le16(USB_CDC_NCM_NTB32_FORMAT)) {
 			dev_info(&intf->dev, "resetting NTB format to 16-bit");
 			err = usbnet_write_cmd(dev, USB_CDC_SET_NTB_FORMAT,
 					       USB_TYPE_CLASS | USB_DIR_OUT
-- 
2.20.1

