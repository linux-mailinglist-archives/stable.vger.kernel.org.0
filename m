Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B11483234
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiACOZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbiACOZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:25:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87239C061395;
        Mon,  3 Jan 2022 06:25:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 279806111B;
        Mon,  3 Jan 2022 14:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3332C36AEB;
        Mon,  3 Jan 2022 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219934;
        bh=BiNP+Kkw3KOHP/XtRw2+kB+r1H+C1pHGVmnc0XIsH2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSTV31hfzGHc3xmxz8xwN3SK11b+bfu+UYPwi382HApY8PwJY++Vkn0rIQyHESt4G
         xb+SMRX1YEJsOXwfxc3p4fPlm8RZo1qdTTuWNIYmekIa1Gfzmf7OAsQeNsFvmCFmxn
         2m+jM3eJguPEqMVBweQJpe/pJbWJgahyOb/F/nWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 4.19 22/27] usb: mtu3: set interval of FS intr and isoc endpoint
Date:   Mon,  3 Jan 2022 15:24:02 +0100
Message-Id: <20220103142052.881739621@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
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
@@ -98,6 +98,13 @@ static int mtu3_ep_enable(struct mtu3_ep
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


