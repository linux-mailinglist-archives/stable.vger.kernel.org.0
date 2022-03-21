Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7234E295B
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348896AbiCUOEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349005AbiCUODO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806C840A12;
        Mon, 21 Mar 2022 07:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C61B4B816D7;
        Mon, 21 Mar 2022 13:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFB7C340E8;
        Mon, 21 Mar 2022 13:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871190;
        bh=VyqiZa+McEGjcbbsPS6zcIHRdgCkZADjXTnVD631GgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhTJSF763UyG5N3jxHUDPy+yvJaPUBftO02ZcR6PDj6XfzKfxo+dratpm9gOE5Z0q
         yp6urCEu7H1UxvH0dCRXr6xvyK8KBySV20YZl0gcJ0BK9eXygEKUV2RQstIhrGc6vz
         Dr8xDw8bFw9ouwuCPHKFHPNpB08UPcjeLE6V3esY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel Hojda <ghojda@yo2urs.ro>,
        Markus Reichl <m.reichl@fivetechno.de>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 5.10 27/30] net: usb: Correct reset handling of smsc95xx
Date:   Mon, 21 Mar 2022 14:52:57 +0100
Message-Id: <20220321133220.431816122@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
References: <20220321133219.643490199@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Cc: Fabio Estevam <festevam@gmail.com>
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


