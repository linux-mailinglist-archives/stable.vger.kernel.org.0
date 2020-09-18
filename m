Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08F626ED0D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgIRCQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729381AbgIRCQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:16:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CE1C238E6;
        Fri, 18 Sep 2020 02:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395382;
        bh=Hn2PJTowLedylOVnlk+TZvCigtDRVGkntiTrNgEOTnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFf+7X/Kya5UBpe+3+9K2Nkzf3jPekdQfUIyYrI6RrPrZjTB7xRLBXN+TV4ioG1fc
         m6AHgvsmbs9v9d0LsaDoi6W58kZklZqZ/mTpivCPq6Xqi0v6YLCbrZhyWdBZqNdQTn
         HnBT+0wr3iyfkkLWvCFGyB3mnIuZDs+AqnqAxXAw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 73/90] tty: serial: samsung: Correct clock selection logic
Date:   Thu, 17 Sep 2020 22:14:38 -0400
Message-Id: <20200918021455.2067301-73-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bakker <xc-racer2@live.ca>

[ Upstream commit 7d31676a8d91dd18e08853efd1cb26961a38c6a6 ]

Some variants of the samsung tty driver can pick which clock
to use for their baud rate generation.  In the DT conversion,
a default clock was selected to be used if a specific one wasn't
assigned and then a comparison of which clock rate worked better
was done.  Unfortunately, the comparison was implemented in such
a way that only the default clock was ever actually compared.
Fix this by iterating through all possible clocks, except when a
specific clock has already been picked via clk_sel (which is
only possible via board files).

Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/BN6PR04MB06604E63833EA41837EBF77BA3A30@BN6PR04MB0660.namprd04.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/samsung.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 4dfdb59061bea..8c89697c53573 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1157,14 +1157,14 @@ static unsigned int s3c24xx_serial_getclk(struct s3c24xx_uart_port *ourport,
 	struct s3c24xx_uart_info *info = ourport->info;
 	struct clk *clk;
 	unsigned long rate;
-	unsigned int cnt, baud, quot, clk_sel, best_quot = 0;
+	unsigned int cnt, baud, quot, best_quot = 0;
 	char clkname[MAX_CLK_NAME_LENGTH];
 	int calc_deviation, deviation = (1 << 30) - 1;
 
-	clk_sel = (ourport->cfg->clk_sel) ? ourport->cfg->clk_sel :
-			ourport->info->def_clk_sel;
 	for (cnt = 0; cnt < info->num_clks; cnt++) {
-		if (!(clk_sel & (1 << cnt)))
+		/* Keep selected clock if provided */
+		if (ourport->cfg->clk_sel &&
+			!(ourport->cfg->clk_sel & (1 << cnt)))
 			continue;
 
 		sprintf(clkname, "clk_uart_baud%d", cnt);
-- 
2.25.1

