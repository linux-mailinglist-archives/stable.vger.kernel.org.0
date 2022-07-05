Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E239566D4A
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbiGEMWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbiGEMPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:15:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186331B7BB;
        Tue,  5 Jul 2022 05:11:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EFEB61988;
        Tue,  5 Jul 2022 12:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C2EC341C7;
        Tue,  5 Jul 2022 12:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023114;
        bh=Pv20hZ6MibaibPaGYKswI47gYlx8KHg9vXJ+EQIoDbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrFpkQoxf8g/tV453gVWJLZ1n8KZEfUY62FvCEov8MiG08U8evO+MlTtRzWbI/IfH
         a00ivJXCBNwD3Oa6NTsp5fP1Iu0GU2z2pyANOqY8ycI3nVqKWCB9z7I2MUZ75QGvSL
         qrcHUpqLmf75klxHS97agr/+b5wKZkJ13eDqjF2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Lundin <glance@acc.umu.se>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 43/98] net: asix: fix "cant send until first packet is send" issue
Date:   Tue,  5 Jul 2022 13:58:01 +0200
Message-Id: <20220705115618.810586920@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 805206e66fab4ba1e0ebd19402006d62cd1d4902 upstream.

If cable is attached after probe sequence, the usbnet framework would
not automatically start processing RX packets except at least one
packet was transmitted.

On systems with any kind of address auto configuration this issue was
not detected, because some packets are send immediately after link state
is changed to "running".

With this patch we will notify usbnet about link status change provided by the
PHYlib.

Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Reported-by: Anton Lundin <glance@acc.umu.se>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Tested-by: Anton Lundin <glance@acc.umu.se>
Link: https://lore.kernel.org/r/20220624075139.3139300-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/asix_common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -431,6 +431,7 @@ void asix_adjust_link(struct net_device
 
 	asix_write_medium_mode(dev, mode, 0);
 	phy_print_status(phydev);
+	usbnet_link_change(dev, phydev->link, 0);
 }
 
 int asix_write_gpio(struct usbnet *dev, u16 value, int sleep, int in_pm)


