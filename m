Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0965483390
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbiACOiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235728AbiACOhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:37:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C22BC061394;
        Mon,  3 Jan 2022 06:33:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CC3EB80F2B;
        Mon,  3 Jan 2022 14:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7535FC36AED;
        Mon,  3 Jan 2022 14:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220419;
        bh=qA2EPowMX94cc/WxasrA6rl01EFVrBTpn4vKhyM0fVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oikYuiBvU/KO7UCr+ma/OVjmwBa3AnZ/iUxGNjALWBR+PAr+sx7KhmWCs9605FLUm
         ppG0DS/8wuZ1ymuqFRBeL6qkWkhHAWFjBrK7qPioGHqcjj91Y2tqe/dDTFzR614HJR
         +YcIdsQydA8Yf6Szo/HUCNYo+jPznQacmzzX1TqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.15 62/73] usb: mtu3: set interval of FS intr and isoc endpoint
Date:   Mon,  3 Jan 2022 15:24:23 +0100
Message-Id: <20220103142058.932701024@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 43f3b8cbcf93da7c2755af4a543280c31f4adf16 upstream.

Add support to set interval also for FS intr and isoc endpoint.

Fixes: 4d79e042ed8b ("usb: mtu3: add support for usb3.1 IP")
Cc: stable@vger.kernel.org
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20211218095749.6250-4-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mtu3/mtu3_gadget.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -93,6 +93,13 @@ static int mtu3_ep_enable(struct mtu3_ep
 			mult = usb_endpoint_maxp_mult(desc) - 1;
 		}
 		break;
+	case USB_SPEED_FULL:
+		if (usb_endpoint_xfer_isoc(desc))
+			interval = clamp_val(desc->bInterval, 1, 16);
+		else if (usb_endpoint_xfer_int(desc))
+			interval = clamp_val(desc->bInterval, 1, 255);
+
+		break;
 	default:
 		break; /*others are ignored */
 	}


