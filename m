Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77AF499568
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441819AbiAXUvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40554 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391264AbiAXUrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:47:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52FF160918;
        Mon, 24 Jan 2022 20:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E2FC340E5;
        Mon, 24 Jan 2022 20:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057231;
        bh=0L0DDiEfxGJyaxQOimR7aMe0htOuKRpRbrOBhnHMJQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIm2smwI83+kCrbs6gtP1CSERxISnBXev6wzPMaGGpkUsRtefrCKbd0YWQXg8tuqj
         x2WmWbBM0/AeVEIIqQrnhWlDu/E7665gBAOv9iD/6SRSyXTHV1IK3pwY9COknlnWVp
         NTg60XqXua5MkaK1gLWdCnHjOPzA0UXzOgusIftM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel Hojda <ghojda@yo2urs.ro>,
        Markus Reichl <m.reichl@fivetechno.de>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 744/846] net: usb: Correct reset handling of smsc95xx
Date:   Mon, 24 Jan 2022 19:44:21 +0100
Message-Id: <20220124184126.654026824@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -1961,7 +1961,8 @@ static const struct driver_info smsc95xx
 	.bind		= smsc95xx_bind,
 	.unbind		= smsc95xx_unbind,
 	.link_reset	= smsc95xx_link_reset,
-	.reset		= smsc95xx_start_phy,
+	.reset		= smsc95xx_reset,
+	.check_connect	= smsc95xx_start_phy,
 	.stop		= smsc95xx_stop,
 	.rx_fixup	= smsc95xx_rx_fixup,
 	.tx_fixup	= smsc95xx_tx_fixup,


