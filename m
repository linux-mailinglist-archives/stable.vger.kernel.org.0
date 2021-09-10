Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB353406BE8
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhIJMfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234192AbhIJMei (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:34:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C949560E94;
        Fri, 10 Sep 2021 12:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277207;
        bh=WqSVZqc8W+0qcj8G9jPcDiTahB3uUNnrxTIuy542Qzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3EIaicDSV+Un2WbVEPbRmKftqrlMJ66zulD5v5oBwBgGeiqSV1alrD0GKvX8VLBS
         6gZATp0BUI6eqY/LaN7FsikGbGHQxWumWEKPYXTOrG5oMDwIePzneTpNrd3OTyWi4b
         +4Ar61t5YhKB8D4nF9dCr+Yy0Qt3ktFPIjVrEhT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.10 19/26] usb: gadget: tegra-xudc: fix the wrong mult value for HS isoc or intr
Date:   Fri, 10 Sep 2021 14:30:23 +0200
Message-Id: <20210910122916.875884800@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
References: <20210910122916.253646001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit eeb0cfb6b2b6b731902e68af641e30bd31be3c7b upstream.

usb_endpoint_maxp() only returns the bit[10:0] of wMaxPacketSize
of endpoint descriptor, not includes bit[12:11] anymore, so use
usb_endpoint_maxp_mult() instead.
Meanwhile no need AND 0x7ff when get maxp, remove it.

Fixes: 49db427232fe ("usb: gadget: Add UDC driver for tegra XUSB device mode controller")
Cc: stable@vger.kernel.org
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1628836253-7432-5-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -1610,7 +1610,7 @@ static void tegra_xudc_ep_context_setup(
 	u16 maxpacket, maxburst = 0, esit = 0;
 	u32 val;
 
-	maxpacket = usb_endpoint_maxp(desc) & 0x7ff;
+	maxpacket = usb_endpoint_maxp(desc);
 	if (xudc->gadget.speed == USB_SPEED_SUPER) {
 		if (!usb_endpoint_xfer_control(desc))
 			maxburst = comp_desc->bMaxBurst;
@@ -1621,7 +1621,7 @@ static void tegra_xudc_ep_context_setup(
 		   (usb_endpoint_xfer_int(desc) ||
 		    usb_endpoint_xfer_isoc(desc))) {
 		if (xudc->gadget.speed == USB_SPEED_HIGH) {
-			maxburst = (usb_endpoint_maxp(desc) >> 11) & 0x3;
+			maxburst = usb_endpoint_maxp_mult(desc) - 1;
 			if (maxburst == 0x3) {
 				dev_warn(xudc->dev,
 					 "invalid endpoint maxburst\n");


