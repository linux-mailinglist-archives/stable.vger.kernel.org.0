Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABD9406B77
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbhIJMcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233228AbhIJMcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C75A1611C8;
        Fri, 10 Sep 2021 12:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277063;
        bh=JXBXh8hZj8/YaKg68tlhAOnJsIsEUQr5MOtYuacc0Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiB1/zmeVJA5zFgk28g+/OtvtHlDjXuGaDtJv1FT/n1yOwL9oBHyDMmnWKH8JEoaK
         SdaGTwBn6mk3AK2+N+dWVS0TZhK2TGbblW+bTgeqh3TWDl9r8Uz5DKG7aN5UJEu+jk
         GiGFrrN3JXoxiatp/UivF8f5Uh22Bdu0HwZH9HY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.14 13/23] usb: mtu3: use @mult for HS isoc or intr
Date:   Fri, 10 Sep 2021 14:30:03 +0200
Message-Id: <20210910122916.435071874@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
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
@@ -92,7 +92,7 @@ static int mtu3_ep_enable(struct mtu3_ep
 				usb_endpoint_xfer_int(desc)) {
 			interval = desc->bInterval;
 			interval = clamp_val(interval, 1, 16) - 1;
-			burst = (max_packet & GENMASK(12, 11)) >> 11;
+			mult = (max_packet & GENMASK(12, 11)) >> 11;
 		}
 		break;
 	default:


