Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639F9593AB0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344233AbiHOTjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245630AbiHOThe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:37:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D2431349;
        Mon, 15 Aug 2022 11:46:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E57B9B81057;
        Mon, 15 Aug 2022 18:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044B9C433C1;
        Mon, 15 Aug 2022 18:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589181;
        bh=+z29A/P3gfUa+DLcK1Cr+c4N/+VadkGSz84KoYlC+7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/clz9Ee3eI2cfG2ggRWs6SegMHv/6r87saS2tksE+qNPU5bs5gNhVEE6G8sy265W
         kjK7hOoDKFw0+AHvb8ufIzIG27lSbqgq9s8Z2vyw0SG8QF0WjPhyLZqJo7TJvGU6RG
         rH8PcwDaAojTyV3PJxYoj4VR4vVgT5i6VrAQPVZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 639/779] tty: serial: fsl_lpuart: correct the count of break characters
Date:   Mon, 15 Aug 2022 20:04:43 +0200
Message-Id: <20220815180404.666599482@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 707f816f25590c20e056b3bd4a17ce69b03fe856 ]

The LPUART can't distinguish between a break signal and a framing error,
so need to count the break characters if there is a framing error and
received data is zero instead of the parity error.

Fixes: 5541a9bacfe5 ("serial: fsl_lpuart: handle break and make sysrq work")
Reviewed-by: Michael Walle <michael@walle.cc>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20220725050115.12396-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 481107fdd69b..4155bd10711d 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -982,12 +982,12 @@ static void lpuart32_rxint(struct lpuart_port *sport)
 
 		if (sr & (UARTSTAT_PE | UARTSTAT_OR | UARTSTAT_FE)) {
 			if (sr & UARTSTAT_PE) {
+				sport->port.icount.parity++;
+			} else if (sr & UARTSTAT_FE) {
 				if (is_break)
 					sport->port.icount.brk++;
 				else
-					sport->port.icount.parity++;
-			} else if (sr & UARTSTAT_FE) {
-				sport->port.icount.frame++;
+					sport->port.icount.frame++;
 			}
 
 			if (sr & UARTSTAT_OR)
@@ -1002,12 +1002,12 @@ static void lpuart32_rxint(struct lpuart_port *sport)
 			sr &= sport->port.read_status_mask;
 
 			if (sr & UARTSTAT_PE) {
+				flg = TTY_PARITY;
+			} else if (sr & UARTSTAT_FE) {
 				if (is_break)
 					flg = TTY_BREAK;
 				else
-					flg = TTY_PARITY;
-			} else if (sr & UARTSTAT_FE) {
-				flg = TTY_FRAME;
+					flg = TTY_FRAME;
 			}
 
 			if (sr & UARTSTAT_OR)
-- 
2.35.1



