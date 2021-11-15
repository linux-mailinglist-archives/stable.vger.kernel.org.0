Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C3F452603
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347997AbhKPCBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239454AbhKOSHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C1116331C;
        Mon, 15 Nov 2021 17:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998365;
        bh=62XO83ls1ybj6vxifPXM1SLdSQnD8Ljl2MyFTy+HT54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlQlIsBHCUK7LDDYVlc0J7AU6i8I4Ue3AOMXa87FleINqMsspHhEY+BsrNm7hF1/9
         rQM1sdqJyU0KgDg38Ym4E7tfNcEaFa7r0VQ29h6Le0OFZ5eJ92uyFVZUddA21LwLw3
         pTmOa9ukDCTXqze1n9HrDRwoPTg+3ZcXD8NB1bXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 483/575] rtc: rv3032: fix error handling in rv3032_clkout_set_rate()
Date:   Mon, 15 Nov 2021 18:03:28 +0100
Message-Id: <20211115165400.410033382@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c3336b8ac6091df60a5c1049a8c685d0b947cc61 ]

Do not call rv3032_exit_eerd() if the enter function fails but don't
forget to call the exit when the enter succeeds.

Fixes: 2eeaa532acca ("rtc: rv3032: Add a driver for Microcrystal RV-3032")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211012101028.GT2083@kadam
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv3032.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-rv3032.c b/drivers/rtc/rtc-rv3032.c
index 3e67f71f42614..9e6166864bd73 100644
--- a/drivers/rtc/rtc-rv3032.c
+++ b/drivers/rtc/rtc-rv3032.c
@@ -617,11 +617,11 @@ static int rv3032_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	ret = rv3032_enter_eerd(rv3032, &eerd);
 	if (ret)
-		goto exit_eerd;
+		return ret;
 
 	ret = regmap_write(rv3032->regmap, RV3032_CLKOUT1, hfd & 0xff);
 	if (ret)
-		return ret;
+		goto exit_eerd;
 
 	ret = regmap_write(rv3032->regmap, RV3032_CLKOUT2, RV3032_CLKOUT2_OS |
 			    FIELD_PREP(RV3032_CLKOUT2_HFD_MSK, hfd >> 8));
-- 
2.33.0



