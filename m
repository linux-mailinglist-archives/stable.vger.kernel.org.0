Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5C9499B09
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbiAXVtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50934 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378386AbiAXVjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC0FAB8123D;
        Mon, 24 Jan 2022 21:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19EFC340E4;
        Mon, 24 Jan 2022 21:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060345;
        bh=bPj+/VtfiWo0N44MEdLgqfeCoWwdaSWRHiXq8k/ovb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CZzCyw6Sj65epi5f9E3DSPO6UAJS09tvnhTJb/gJefUXmzBUS0s2N7QGfFPEZ3nw
         zrhe02AoKjU7IReVe8jOUbUgQUvtSloyp/hnWlGgNXir4uvbmMV07PSP2s2IG+sDkL
         kprulooWGCMyldK1QWZI7QEB8/VRcag4Pd5oWFfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel Hojda <ghojda@yo2urs.ro>,
        Markus Reichl <m.reichl@fivetechno.de>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 0918/1039] net: usb: Correct reset handling of smsc95xx
Date:   Mon, 24 Jan 2022 19:45:07 +0100
Message-Id: <20220124184156.151964131@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Reichl <m.reichl@fivetechno.de>

commit 0bf3885324a8599e3af4c7379b8d4f621c9bbffa upstream.

On boards with LAN9514 and no preconfigured MAC address we don't get an
ip address from DHCP after commit a049a30fc27c ("net: usb: Correct PHY handling
of smsc95xx") anymore. Adding an explicit reset before starting the phy
fixes the issue.

[1]
https://lore.kernel.org/netdev/199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com/

From: Gabriel Hojda <ghojda@yo2urs.ro>
Fixes: a049a30fc27c ("net: usb: Correct PHY handling of smsc95xx")
Signed-off-by: Gabriel Hojda <ghojda@yo2urs.ro>
Signed-off-by: Markus Reichl <m.reichl@fivetechno.de>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/smsc95xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1962,7 +1962,8 @@ static const struct driver_info smsc95xx
 	.bind		= smsc95xx_bind,
 	.unbind		= smsc95xx_unbind,
 	.link_reset	= smsc95xx_link_reset,
-	.reset		= smsc95xx_start_phy,
+	.reset		= smsc95xx_reset,
+	.check_connect	= smsc95xx_start_phy,
 	.stop		= smsc95xx_stop,
 	.rx_fixup	= smsc95xx_rx_fixup,
 	.tx_fixup	= smsc95xx_tx_fixup,


