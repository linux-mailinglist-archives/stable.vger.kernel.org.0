Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C00C594F9E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiHPEa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiHPEaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:30:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5B31607B8;
        Mon, 15 Aug 2022 13:19:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6F3D60FD0;
        Mon, 15 Aug 2022 20:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2D7C433D6;
        Mon, 15 Aug 2022 20:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594752;
        bh=uruAPTWq+uwmNsnotCboz8+40N/AfDji6438gd667fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlVK/9HJyd3SgcMyHvAZ6omdQPwZ4sTbCGZUg/vTz4BdQbBkx+IxHrzXXZkRMmCgd
         pPoZOMXfsCJqhgSl6PkdXdDmmY7uQ8nhudhOjMwDy+SSln81iJIOB00UnZiVvHNuIS
         rtL5lDEBcc/DANjZTNozn173FbNVPgJtbEn4A/wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0516/1157] can: pch_can: do not report txerr and rxerr during bus-off
Date:   Mon, 15 Aug 2022 19:57:52 +0200
Message-Id: <20220815180500.339609662@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index fde3ac516d26..497ef77340ea 100644
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
 }
-- 
2.35.1



