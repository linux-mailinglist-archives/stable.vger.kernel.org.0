Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741EC48329F
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiACO30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:29:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59418 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbiACO2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:28:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38ABEB80F03;
        Mon,  3 Jan 2022 14:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B818C36AEB;
        Mon,  3 Jan 2022 14:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220083;
        bh=l48SW5Xda3K0KdZnXrnm9z6wy1H7zDj4y0jSBe766u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jvwd9rHjGj/InlAvmRBJNCcidoaOGnN4UU9qFgSh48Y1HQM7w1h67Xm67RsfvzB3L
         ynXcVkbBttqXtkur6lAclgoKwTYWoyWWLd4kojLqus4Im6GFgZAtFqJewZ0TZLWkhk
         12+3FcLa86tdpVGOcrsDaBJbPCoQ7VFJqYOYnpzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.4 31/37] usb: mtu3: set interval of FS intr and isoc endpoint
Date:   Mon,  3 Jan 2022 15:24:09 +0100
Message-Id: <20220103142052.835795430@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
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
@@ -101,6 +101,13 @@ static int mtu3_ep_enable(struct mtu3_ep
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


