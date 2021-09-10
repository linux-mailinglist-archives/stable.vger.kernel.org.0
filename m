Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC96406BB4
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhIJMdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233730AbhIJMd3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:33:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3BD960E94;
        Fri, 10 Sep 2021 12:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277138;
        bh=4PNFQT0sWdvPFPLHHfWaQiXxNzDhxFvvX3ryFhHiK8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dADFiuEy3+M4Q+G87PhjA/6KFmfyfbmfN3UjItKoakiN/y74akxSgUDRJ/sjx7tZS
         r72SXWJE0prYMvB1fKlI9SePz4wW/lm7UhMmHd6ZPhmB56OvJIHNljGHjCm2zb8VpR
         1yAoxMGTYJk0vyUboxRnGeTb5krCZCMYPktRFUZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.13 17/22] usb: mtu3: fix the wrong HS mult value
Date:   Fri, 10 Sep 2021 14:30:16 +0200
Message-Id: <20210910122916.507832777@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122915.942645251@linuxfoundation.org>
References: <20210910122915.942645251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 44e4439d8f9f8d0e9da767d1f31e7c211081feca upstream.

usb_endpoint_maxp() returns actual max packet size, @mult will
always be zero, fix it by using usb_endpoint_maxp_mult() instead
to get mult.

Fixes: 4d79e042ed8b ("usb: mtu3: add support for usb3.1 IP")
Cc: stable@vger.kernel.org
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1628836253-7432-3-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mtu3/mtu3_gadget.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -64,14 +64,12 @@ static int mtu3_ep_enable(struct mtu3_ep
 	u32 interval = 0;
 	u32 mult = 0;
 	u32 burst = 0;
-	int max_packet;
 	int ret;
 
 	desc = mep->desc;
 	comp_desc = mep->comp_desc;
 	mep->type = usb_endpoint_type(desc);
-	max_packet = usb_endpoint_maxp(desc);
-	mep->maxp = max_packet & GENMASK(10, 0);
+	mep->maxp = usb_endpoint_maxp(desc);
 
 	switch (mtu->g.speed) {
 	case USB_SPEED_SUPER:
@@ -92,7 +90,7 @@ static int mtu3_ep_enable(struct mtu3_ep
 				usb_endpoint_xfer_int(desc)) {
 			interval = desc->bInterval;
 			interval = clamp_val(interval, 1, 16) - 1;
-			mult = (max_packet & GENMASK(12, 11)) >> 11;
+			mult = usb_endpoint_maxp_mult(desc) - 1;
 		}
 		break;
 	default:


