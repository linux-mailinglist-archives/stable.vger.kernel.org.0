Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DE059A12E
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350425AbiHSP4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350650AbiHSPzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:55:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE81107D96;
        Fri, 19 Aug 2022 08:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5FEB61702;
        Fri, 19 Aug 2022 15:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCACC433B5;
        Fri, 19 Aug 2022 15:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924193;
        bh=ohXzVHtE6DItpFVp9j+MEuEkFNvRx8jj9TPewUENQ+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSPxcwMmD9JrhxpfixrENDOqamGgZxhuwSesEoD0rEdhcMbD8WQyVDxyxUJPk0Tu4
         Q1nkDBI1knZUjTd8QhxA28UcdQTqjMH/itVUcqDqdjj56Pdx1ZrmCY5F7XpOsQD45+
         8iIpETjZS7OxCTC28ouO++4iChx/uyLPmjq1gbzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 048/545] mtd: rawnand: arasan: Update NAND bus clock instead of system clock
Date:   Fri, 19 Aug 2022 17:36:58 +0200
Message-Id: <20220819153831.365442311@linuxfoundation.org>
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
@@ -283,17 +283,17 @@ static int anfc_select_target(struct nan
 
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
 


