Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485FE54860E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378311AbiFMNlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378990AbiFMNje (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6256F793BF;
        Mon, 13 Jun 2022 04:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A539B80EAA;
        Mon, 13 Jun 2022 11:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDD3C34114;
        Mon, 13 Jun 2022 11:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119702;
        bh=6lOmx3AsyEf3czrTCiWgKfvKLJC6S5vFM4BRHd+z1Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4PwORsAB8PhjlxGFIPC/sd5nYI5tlDBHGcWVJr26fq2jQOdYCc0OTBalkehlijeB
         16F0g1jc+rfIsozQEi3f17cVctKH8KkT7rDWySnjEjcfOg4ZvEfpDHarUTtU8kJKmb
         SFQ8XKXM4tUlYzuk3stj4Df1ZVuQc8pOwDwcZers=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 090/339] spi: fsi: Fix spurious timeout
Date:   Mon, 13 Jun 2022 12:08:35 +0200
Message-Id: <20220613094929.245397534@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 61bf40ef51aa73f6216b33563271b6acf7ea8d70 ]

The driver may return a timeout error even if the status register
indicates that the transfer may proceed. Fix this by restructuring
the polling loop.

Fixes: 89b35e3f2851 ("spi: fsi: Implement a timeout for polling status")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20220525165852.33167-2-eajames@linux.ibm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-fsi.c b/drivers/spi/spi-fsi.c
index d403a7a3021d..72ab066ce552 100644
--- a/drivers/spi/spi-fsi.c
+++ b/drivers/spi/spi-fsi.c
@@ -319,12 +319,12 @@ static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 
 			end = jiffies + msecs_to_jiffies(SPI_FSI_STATUS_TIMEOUT_MS);
 			do {
+				if (time_after(jiffies, end))
+					return -ETIMEDOUT;
+
 				rc = fsi_spi_status(ctx, &status, "TX");
 				if (rc)
 					return rc;
-
-				if (time_after(jiffies, end))
-					return -ETIMEDOUT;
 			} while (status & SPI_FSI_STATUS_TDR_FULL);
 
 			sent += nb;
@@ -337,12 +337,12 @@ static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 		while (transfer->len > recv) {
 			end = jiffies + msecs_to_jiffies(SPI_FSI_STATUS_TIMEOUT_MS);
 			do {
+				if (time_after(jiffies, end))
+					return -ETIMEDOUT;
+
 				rc = fsi_spi_status(ctx, &status, "RX");
 				if (rc)
 					return rc;
-
-				if (time_after(jiffies, end))
-					return -ETIMEDOUT;
 			} while (!(status & SPI_FSI_STATUS_RDR_FULL));
 
 			rc = fsi_spi_read_reg(ctx, SPI_FSI_DATA_RX, &in);
-- 
2.35.1



