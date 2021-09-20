Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EC5411ECF
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347965AbhITRfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351413AbhITRdc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:33:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED4E861361;
        Mon, 20 Sep 2021 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157522;
        bh=Zfiz6uUpfAmQKu0y0eZfgcbvcd1GfUzEVHePAr2Wi7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tlJahMNLTj5Bg0UmGhkqL5MunUh2swAIYIsE6cURFVwYwGADH933vjWETpvE/ILNr
         4WT12CavTxfol7Bbq02bxTGZBimrKtzGN+3aelPc1uuU054S4mlYx3lEPxfUqi84DD
         jmlkkQFAtJpTdmcI7kpbOtteiQWxcBWSGaFzuDvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 4.19 029/293] usb: mtu3: fix the wrong HS mult value
Date:   Mon, 20 Sep 2021 18:39:51 +0200
Message-Id: <20210920163934.266944058@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
@@ -69,14 +69,12 @@ static int mtu3_ep_enable(struct mtu3_ep
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
@@ -97,7 +95,7 @@ static int mtu3_ep_enable(struct mtu3_ep
 				usb_endpoint_xfer_int(desc)) {
 			interval = desc->bInterval;
 			interval = clamp_val(interval, 1, 16) - 1;
-			mult = (max_packet & GENMASK(12, 11)) >> 11;
+			mult = usb_endpoint_maxp_mult(desc) - 1;
 		}
 		break;
 	default:


