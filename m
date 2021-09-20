Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20ECC411EEF
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351472AbhITRgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351375AbhITRdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:33:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB98F61AFF;
        Mon, 20 Sep 2021 17:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157520;
        bh=1UAMV4qPxs+18602te90RcT0WG0KHwJmiXBzSnIqEa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viioH2+Q5Ei+fjmyam4YoJaJ4uP2uXKI1iL6AmkFSnWnnekG7IU+mfYDuL4+jtn3V
         6Nvn2K49kkFNWpihHYVUkFJl22P6knx2FwxjKlPyItFnC647B1FxtGCkhNSWdwAaQT
         EqnDTHnDmq3UaxlDvexVbZzskO+OSTCa4UYax82g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 4.19 028/293] usb: mtu3: use @mult for HS isoc or intr
Date:   Mon, 20 Sep 2021 18:39:50 +0200
Message-Id: <20210920163934.233458201@linuxfoundation.org>
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

commit fd7cb394ec7efccc3985feb0978cee4d352e1817 upstream.

For HS isoc or intr, should use @mult but not @burst
to save mult value.

Fixes: 4d79e042ed8b ("usb: mtu3: add support for usb3.1 IP")
Cc: stable@vger.kernel.org
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1628836253-7432-2-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mtu3/mtu3_gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -97,7 +97,7 @@ static int mtu3_ep_enable(struct mtu3_ep
 				usb_endpoint_xfer_int(desc)) {
 			interval = desc->bInterval;
 			interval = clamp_val(interval, 1, 16) - 1;
-			burst = (max_packet & GENMASK(12, 11)) >> 11;
+			mult = (max_packet & GENMASK(12, 11)) >> 11;
 		}
 		break;
 	default:


