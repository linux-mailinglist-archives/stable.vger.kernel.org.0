Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD7F59A181
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351655AbiHSQOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351657AbiHSQNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:13:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F776115214;
        Fri, 19 Aug 2022 08:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79BACB8281A;
        Fri, 19 Aug 2022 15:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA513C433C1;
        Fri, 19 Aug 2022 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924663;
        bh=+7o2r0aJqaeH7HNBtLIJ3QHNTeo1M/iksaW/zsRdm0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLsoSIq/j62FsklsWMUyT6d2Nah1JEkpiFjbXECKKHM85FWA/nU53ikwTZePsMcHY
         5MFWNtb9wE9TFHqVtjt7O2tgVKOUsfYfvZZf/6Q6p6gU7ZNnm7yAlpx5Wc5ueVMBFa
         /t6YoY1CCBE20IWK6jfVvJibdVCMeQmqCiBpYyaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/545] can: usb_8dev: do not report txerr and rxerr during bus-off
Date:   Fri, 19 Aug 2022 17:40:12 +0200
Message-Id: <20220819153840.187606733@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 985e00aee4ee..885c54c6f81a 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -442,9 +442,10 @@ static void usb_8dev_rx_err_msg(struct usb_8dev_priv *priv,
 
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



