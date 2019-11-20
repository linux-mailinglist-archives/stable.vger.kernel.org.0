Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA2F1031DF
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 04:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfKTDHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 22:07:25 -0500
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:53728 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfKTDHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 22:07:25 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id xAK37Nfu013238; Wed, 20 Nov 2019 12:07:23 +0900
X-Iguazu-Qid: 34ts1RrN0nTFD9LZze
X-Iguazu-QSIG: v=2; s=0; t=1574219243; q=34ts1RrN0nTFD9LZze; m=uM+/VZWrtCuads7105kfAm1fCNt6GpI3KgzccHklqmE=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1512) id xAK37Msk025891;
        Wed, 20 Nov 2019 12:07:23 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id xAK37MUC028154
        for <stable@vger.kernel.org>; Wed, 20 Nov 2019 12:07:22 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id xAK37Ms1017057
        for <stable@vger.kernel.org>; Wed, 20 Nov 2019 12:07:22 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Subject: [PATCH for 4.4.y, 4.9.y, 4.14.y, 4.19.y] net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()
Date:   Wed, 20 Nov 2019 12:07:10 +0900
X-TSB-HOP: ON
Message-Id: <20191120030710.5169-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a56dcc6b455830776899ce3686735f1172e12243 upstream.

This code is supposed to test for negative error codes and partial
reads, but because sizeof() is size_t (unsigned) type then negative
error codes are type promoted to high positive values and the condition
doesn't work as expected.

Fixes: 332f989a3b00 ("CDC-NCM: handle incomplete transfer of MTU")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/usb/cdc_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 71ef895b4dca..bab13ccfb085 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -534,7 +534,7 @@ static void cdc_ncm_set_dgram_size(struct usbnet *dev, int new_size)
 	err = usbnet_read_cmd(dev, USB_CDC_GET_MAX_DATAGRAM_SIZE,
 			      USB_TYPE_CLASS | USB_DIR_IN | USB_RECIP_INTERFACE,
 			      0, iface_no, &max_datagram_size, sizeof(max_datagram_size));
-	if (err < sizeof(max_datagram_size)) {
+	if (err != sizeof(max_datagram_size)) {
 		dev_dbg(&dev->intf->dev, "GET_MAX_DATAGRAM_SIZE failed\n");
 		goto out;
 	}
-- 
2.23.0

