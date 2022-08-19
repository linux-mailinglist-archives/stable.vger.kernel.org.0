Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAA359A1DE
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351920AbiHSQNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349877AbiHSQLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:11:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC55113DCC;
        Fri, 19 Aug 2022 08:57:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CF3D61745;
        Fri, 19 Aug 2022 15:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2645CC433D7;
        Fri, 19 Aug 2022 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924641;
        bh=HKBF7gyGs5TtyLS+uysNuzQ3Vs4JaleRGlwtrNz9Zb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOHzS+Z1ytZVOLVBQI5NqsDJusVD2saaIVrEVQovgIUhwYot2r/TydiYD/jsMACgH
         5Dmyb5rIbghnDeVbQ/rNrTQS8ztfRN7MPc6ZF1X459CVLE14ZmFJWPF4ZFvvEsauQd
         bbzNvt5VP6LIgc2P7G6oy4ME7CsaNSE1CZiAzsU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/545] can: pch_can: do not report txerr and rxerr during bus-off
Date:   Fri, 19 Aug 2022 17:40:05 +0200
Message-Id: <20220819153839.870502125@linuxfoundation.org>
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

[ Upstream commit 3a5c7e4611ddcf0ef37a3a17296b964d986161a6 ]

During bus off, the error count is greater than 255 and can not fit in
a u8.

Fixes: 0c78ab76a05c ("pch_can: Add setting TEC/REC statistics processing")
Link: https://lore.kernel.org/all/20220719143550.3681-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/pch_can.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 79d9abdcc65a..1adfcc0b9424 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -496,6 +496,9 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 		cf->can_id |= CAN_ERR_BUSOFF;
 		priv->can.can_stats.bus_off++;
 		can_bus_off(ndev);
+	} else {
+		cf->data[6] = errc & PCH_TEC;
+		cf->data[7] = (errc & PCH_REC) >> 8;
 	}
 
 	errc = ioread32(&priv->regs->errc);
@@ -556,9 +559,6 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 		break;
 	}
 
-	cf->data[6] = errc & PCH_TEC;
-	cf->data[7] = (errc & PCH_REC) >> 8;
-
 	priv->can.state = state;
 	netif_receive_skb(skb);
 
-- 
2.35.1



