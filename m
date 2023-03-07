Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8656E6AF3B0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbjCGTHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbjCGTHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:07:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C089BC0807
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A15A961518
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979ABC433EF;
        Tue,  7 Mar 2023 18:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215165;
        bh=68liD92AGvBt6EF1OxvlnzDKc61aRwiMKuj6bWGPfiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09vG1lZnD+C96dZtCL9y0wBDUc0b1ub1pig5GuGtx2PSPn6PJud0cc6hoLGLgQzDj
         KTFbnrN7YOh8h7bud4IQjgmN1mNFKcvJVTJfEOEiL+8F0y5nvVjNBAFBBaYzDEasUS
         UTgBPn8aK983V5ogSb+DEWjcD8UNTo5S18qJkbfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Frank Jungclaus <frank.jungclaus@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/567] can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error
Date:   Tue,  7 Mar 2023 17:58:11 +0100
Message-Id: <20230307165912.667642552@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Jungclaus <frank.jungclaus@esd.eu>

[ Upstream commit 118469f88180438ef43dee93d71f77c00e7b425d ]

Move the supply for cf->data[3] (bit stream position of CAN error), in
case of a bus- or protocol-error, outside of the "switch (ecc &
SJA1000_ECC_MASK){}"-statement, because this bit stream position is
independent of the error type.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: https://lore.kernel.org/all/20230216190450.3901254-2-frank.jungclaus@esd.eu
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/esd_usb2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 9ed048cb07e6d..1abdf88597de0 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -278,7 +278,6 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 				cf->data[2] |= CAN_ERR_PROT_STUFF;
 				break;
 			default:
-				cf->data[3] = ecc & SJA1000_ECC_SEG;
 				break;
 			}
 
@@ -286,6 +285,9 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 			if (!(ecc & SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
+			/* Bit stream position in CAN frame as the error was detected */
+			cf->data[3] = ecc & SJA1000_ECC_SEG;
+
 			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
 			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
 				cf->data[1] = (txerr > rxerr) ?
-- 
2.39.2



