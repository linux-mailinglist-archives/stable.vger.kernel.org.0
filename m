Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C4C595117
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbiHPEtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiHPEsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:48:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B50B08BC;
        Mon, 15 Aug 2022 13:43:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8DE86127C;
        Mon, 15 Aug 2022 20:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B88C433C1;
        Mon, 15 Aug 2022 20:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596201;
        bh=/qLeM6O+hsKWkm56b8NdyqMMrg/DKwhFZQtIKkk3yxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPIYxXg5WjWVsCmYyEVYNs4XHMnXCBp1HKO9YDxXInDqbZ++t2aluUy68k8ZlhzBi
         91qhcCm/2efLPx6ji6BbK5eQ2CjOZRzVVIMdhk1kQYtvaNa9RvCapQAbqVgY0DkqQk
         dRvMYhp/HfiuWMgF8dRAAABtTb0FnoGQwvzA/E94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1003/1157] tty: serial: fsl_lpuart: correct the count of break characters
Date:   Mon, 15 Aug 2022 20:05:59 +0200
Message-Id: <20220815180519.918305358@linuxfoundation.org>
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
index 0d6e62f6bb07..561d6d0b7c94 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -990,12 +990,12 @@ static void lpuart32_rxint(struct lpuart_port *sport)
 
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
@@ -1010,12 +1010,12 @@ static void lpuart32_rxint(struct lpuart_port *sport)
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



