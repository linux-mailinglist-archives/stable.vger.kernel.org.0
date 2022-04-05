Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC484F31DC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbiDEJD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240721AbiDEIra (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:47:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447AD25C6C;
        Tue,  5 Apr 2022 01:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA0A1B81BC0;
        Tue,  5 Apr 2022 08:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4C6C385A0;
        Tue,  5 Apr 2022 08:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147775;
        bh=3TnHiDcoE4UN7piXzw8IEQIziQxDeP2KahwoBf8cuVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3sDX8ec/Mxr45hjEXtV2oYUB063QL3vi4WJ/OVf4+mZom6ZmFEadxv7eFkJVZ6Xr
         rlG5TNeZXHXrcrt5GrsEnPBm3Sc4FYtw1W3Ij9E6+8wVj0siDpVk05e2HxSkGkG2zA
         0aQqP2Pg8C0C2cAOWI5toWvNWWUvjeiuNioGgGnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mason Yang <masonccyang@mxic.com.tw>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Zhengxun Li <zhengxunli@mxic.com.tw>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 0078/1017] spi: mxic: Fix the transmit path
Date:   Tue,  5 Apr 2022 09:16:31 +0200
Message-Id: <20220405070356.506732153@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 5fd6739e0df7e320bcac103dfb95fe75941fea17 upstream.

By working with external hardware ECC engines, we figured out that
Under certain circumstances, it is needed for the SPI controller to
check INT_TX_EMPTY and INT_RX_NOT_EMPTY in both receive and transmit
path (not only in the receive path). The delay penalty being
negligible, move this code in the common path.

Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
Cc: stable@vger.kernel.org
Suggested-by: Mason Yang <masonccyang@mxic.com.tw>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Zhengxun Li <zhengxunli@mxic.com.tw>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/linux-mtd/20220127091808.1043392-10-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mxic.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -304,25 +304,21 @@ static int mxic_spi_data_xfer(struct mxi
 
 		writel(data, mxic->regs + TXD(nbytes % 4));
 
-		if (rxbuf) {
-			ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
-						 sts & INT_TX_EMPTY, 0,
-						 USEC_PER_SEC);
-			if (ret)
-				return ret;
+		ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
+					 sts & INT_TX_EMPTY, 0, USEC_PER_SEC);
+		if (ret)
+			return ret;
 
-			ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
-						 sts & INT_RX_NOT_EMPTY, 0,
-						 USEC_PER_SEC);
-			if (ret)
-				return ret;
+		ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
+					 sts & INT_RX_NOT_EMPTY, 0,
+					 USEC_PER_SEC);
+		if (ret)
+			return ret;
 
-			data = readl(mxic->regs + RXD);
+		data = readl(mxic->regs + RXD);
+		if (rxbuf) {
 			data >>= (8 * (4 - nbytes));
 			memcpy(rxbuf + pos, &data, nbytes);
-			WARN_ON(readl(mxic->regs + INT_STS) & INT_RX_NOT_EMPTY);
-		} else {
-			readl(mxic->regs + RXD);
 		}
 		WARN_ON(readl(mxic->regs + INT_STS) & INT_RX_NOT_EMPTY);
 


