Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3503A579B7D
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239747AbiGSM2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239838AbiGSM0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:26:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2184148C93;
        Tue, 19 Jul 2022 05:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A7E061632;
        Tue, 19 Jul 2022 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721AEC341D1;
        Tue, 19 Jul 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232616;
        bh=NGZvUX2/8YYY7PFd7hqg4wLi0Lty1gk9Q+AsMykP6rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9qvoEYOnYhjRAj2wN2gw7NJgR2Zb4ntOAugoTh47fcroHApnY+G1StKUyI5z142d
         pLW4CTsZS+6JlPVR0rV6VMI/LKJQmgq1Hd+DFjS/9l28Uppt0KKY13jHyyoha3veZS
         ZdFzrIcQOM0iVBmT16FlZS6CkGQtjuhHfdycEh38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/112] Revert "can: xilinx_can: Limit CANFD brp to 2"
Date:   Tue, 19 Jul 2022 13:54:33 +0200
Message-Id: <20220719114636.525532808@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

[ Upstream commit c6da4590fe819dfe28a4f8037a8dc1e056542fb4 ]

This reverts commit 05ca14fdb6fe65614e0652d03e44b02748d25af7.

On early silicon engineering samples observed bit shrinking issue when
we use brp as 1. Hence updated brp_min as 2. As in production silicon
this issue is fixed, so reverting the patch.

Link: https://lore.kernel.org/all/20220609082433.1191060-2-srinivas.neeli@xilinx.com
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/xilinx_can.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 1c42417810fc..1a3fba352cad 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -259,7 +259,7 @@ static const struct can_bittiming_const xcan_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 128,
 	.sjw_max = 128,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
@@ -272,7 +272,7 @@ static const struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 16,
 	.sjw_max = 16,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
-- 
2.35.1



