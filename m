Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C465593DB7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242505AbiHOUOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346913AbiHOUMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:12:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A53788DC4;
        Mon, 15 Aug 2022 11:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40B6460A71;
        Mon, 15 Aug 2022 18:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B27BC433D7;
        Mon, 15 Aug 2022 18:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589914;
        bh=90TsjMqOUNEM4+jK+tHM4C/XBOy4yWf55oPYVu5rl94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAjyvGFBO5y0wfhd2WeZOkJ+Tr7mZwYjKJGPrm4+s8QsfnQEJJm2I6q9VrCTN+MGG
         ygvtT+hZgTk11LtZZmf+YWnvamcnR3agvAEYIVKnvoxR2vMv7owF5xMcGsxXQU+/3J
         JuYn7tBlQ8Av/ycigeZ9+6C+B46BiY1NsWlNMxV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.18 0089/1095] mtd: rawnand: arasan: Update NAND bus clock instead of system clock
Date:   Mon, 15 Aug 2022 19:51:28 +0200
Message-Id: <20220815180433.195876501@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>

commit 7499bfeedb47efc1ee4dc793b92c610d46e6d6a6 upstream.

In current implementation the Arasan NAND driver is updating the
system clock(i.e., anand->clk) in accordance to the timing modes
(i.e., SDR or NVDDR). But as per the Arasan NAND controller spec the
flash clock or the NAND bus clock(i.e., nfc->bus_clk), need to be
updated instead. This patch keeps the system clock unchanged and updates
the NAND bus clock as per the timing modes.

Fixes: 197b88fecc50 ("mtd: rawnand: arasan: Add new Arasan NAND controller")
CC: stable@vger.kernel.org # 5.8+
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220628154824.12222-2-amit.kumar-mahapatra@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -347,17 +347,17 @@ static int anfc_select_target(struct nan
 
 	/* Update clock frequency */
 	if (nfc->cur_clk != anand->clk) {
-		clk_disable_unprepare(nfc->controller_clk);
-		ret = clk_set_rate(nfc->controller_clk, anand->clk);
+		clk_disable_unprepare(nfc->bus_clk);
+		ret = clk_set_rate(nfc->bus_clk, anand->clk);
 		if (ret) {
 			dev_err(nfc->dev, "Failed to change clock rate\n");
 			return ret;
 		}
 
-		ret = clk_prepare_enable(nfc->controller_clk);
+		ret = clk_prepare_enable(nfc->bus_clk);
 		if (ret) {
 			dev_err(nfc->dev,
-				"Failed to re-enable the controller clock\n");
+				"Failed to re-enable the bus clock\n");
 			return ret;
 		}
 


