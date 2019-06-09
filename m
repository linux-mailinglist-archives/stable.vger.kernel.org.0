Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2943A8F3
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388082AbfFIRGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388910AbfFIRGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:06:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4235F204EC;
        Sun,  9 Jun 2019 17:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099960;
        bh=4VE399NmQi0yl//Hfg5jFZhYd5DXcjKwk5UB8L9ERCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r73ebhjYms7B8UvxJNY3LOl6YWNQPQLLwg2qZGddZ3U7xMyyl0GYnU49MddYDWqea
         hXF5Q0uQ6AMPFFVSxyWwXLswUSXDLBUXWK4n1/xhhDwCaT7KrBinywttUTNA4m2zZi
         fD+z8DAYkCsyjtDMmZJItFOfltlJNyW64JvF3bw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Christian Panton <christian@panton.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 226/241] net: cdc_ncm: GetNtbFormat endian fix
Date:   Sun,  9 Jun 2019 18:42:48 +0200
Message-Id: <20190609164155.230981076@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/cdc_ncm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -727,7 +727,7 @@ int cdc_ncm_bind_common(struct usbnet *d
 	int err;
 	u8 iface_no;
 	struct usb_cdc_parsed_header hdr;
-	u16 curr_ntb_format;
+	__le16 curr_ntb_format;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -841,7 +841,7 @@ int cdc_ncm_bind_common(struct usbnet *d
 			goto error2;
 		}
 
-		if (curr_ntb_format == USB_CDC_NCM_NTB32_FORMAT) {
+		if (curr_ntb_format == cpu_to_le16(USB_CDC_NCM_NTB32_FORMAT)) {
 			dev_info(&intf->dev, "resetting NTB format to 16-bit");
 			err = usbnet_write_cmd(dev, USB_CDC_SET_NTB_FORMAT,
 					       USB_TYPE_CLASS | USB_DIR_OUT


