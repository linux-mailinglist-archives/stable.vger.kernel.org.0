Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5114832E1
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbiACObb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbiACOaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:30:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F87C0613A1;
        Mon,  3 Jan 2022 06:29:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 679F36110F;
        Mon,  3 Jan 2022 14:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C52C36AEB;
        Mon,  3 Jan 2022 14:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220196;
        bh=qA2EPowMX94cc/WxasrA6rl01EFVrBTpn4vKhyM0fVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JftUhU9+NekEW9iFw7ZERPAX/bnzqH/yeAN8uMSLzOPa8JMQ2U9Nzf06tKH8hhAp1
         FGiBQ7peLe4IWlGc5OxzcdfARVPCXOaZwbQdBIsx8eV2sJg14B8lC+v2q4qchyI7kV
         l6Rjp4xqa1yG3VfuBQ6bYIkiBBFBP/YQl+53VHcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.10 41/48] usb: mtu3: set interval of FS intr and isoc endpoint
Date:   Mon,  3 Jan 2022 15:24:18 +0100
Message-Id: <20220103142054.863062579@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
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


