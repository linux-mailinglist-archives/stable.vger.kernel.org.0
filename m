Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE1A59D6EA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244479AbiHWJmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352084AbiHWJkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:40:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081F545041;
        Tue, 23 Aug 2022 01:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75F99B81C69;
        Tue, 23 Aug 2022 08:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B5FC433C1;
        Tue, 23 Aug 2022 08:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244087;
        bh=6o7dFMo7ClTdnFjrVOtoQR+dS9HFFHcI3I/lUGs2dLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17fsAOGYS3LkFdWTsVaFOCRC+uwAp9DAL9B2UDD6rg19XE1ZMK8EC21dotMlXqKMe
         K2/sXgVkv26rWp87er0NNmOxP6ELg338TNTAZAeaWenyZgkWauDkaP7j1IDX02RNOk
         3ooP05QRGGimmFhbo/WhB4EVv/ByLj3081ihjOck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 084/229] can: usb_8dev: do not report txerr and rxerr during bus-off
Date:   Tue, 23 Aug 2022 10:24:05 +0200
Message-Id: <20220823080056.731785849@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit aebe8a2433cd090ccdc222861f44bddb75eb01de ]

During bus off, the error count is greater than 255 and can not fit in
a u8.

Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
Link: https://lore.kernel.org/all/20220719143550.3681-10-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/usb_8dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 232f45f722f0..5cb5be4dc941 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -453,9 +453,10 @@ static void usb_8dev_rx_err_msg(struct usb_8dev_priv *priv,
 
 	if (rx_errors)
 		stats->rx_errors++;
-
-	cf->data[6] = txerr;
-	cf->data[7] = rxerr;
+	if (priv->can.state != CAN_STATE_BUS_OFF) {
+		cf->data[6] = txerr;
+		cf->data[7] = rxerr;
+	}
 
 	priv->bec.txerr = txerr;
 	priv->bec.rxerr = rxerr;
-- 
2.35.1



