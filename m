Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B573ED607
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbhHPNQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240272AbhHPNPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD69C632DA;
        Mon, 16 Aug 2021 13:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119526;
        bh=l/uEGIH7iZ8RlWhtRjXA0lwS6dV08yXnDyH8fTWbG1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1825WcnfM0UAXjMIb0FCzlc9psvVA1mo1RnpDnMBcVZ+NiPGWttkQgZzmmU9hGEo
         9RV9U70Gtf07Kwt3B9Rq3AEXVu0TllMpb1u8av6nO1Zhd9V0O402s01Y8N9C1RmqUl
         QObptUxAkasSVh/TFJFrPeu40/2+aDzXdnlVxXEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.13 027/151] pinctrl: k210: Fix k210_fpioa_probe()
Date:   Mon, 16 Aug 2021 15:00:57 +0200
Message-Id: <20210816125444.973135954@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 31697ef7f3f45293bba3da87bcc710953e97fc3e upstream.

In k210_fpioa_probe(), add missing calls to clk_disable_unprepare() in
case of error after cenabling the clk and pclk clocks. Also add missing
error handling when enabling pclk.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: d4c34d09ab03 ("pinctrl: Add RISC-V Canaan Kendryte K210 FPIOA driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Link: https://lore.kernel.org/r/20210806004311.52859-1-damien.lemoal@wdc.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-k210.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/pinctrl/pinctrl-k210.c
+++ b/drivers/pinctrl/pinctrl-k210.c
@@ -950,23 +950,37 @@ static int k210_fpioa_probe(struct platf
 		return ret;
 
 	pdata->pclk = devm_clk_get_optional(dev, "pclk");
-	if (!IS_ERR(pdata->pclk))
-		clk_prepare_enable(pdata->pclk);
+	if (!IS_ERR(pdata->pclk)) {
+		ret = clk_prepare_enable(pdata->pclk);
+		if (ret)
+			goto disable_clk;
+	}
 
 	pdata->sysctl_map =
 		syscon_regmap_lookup_by_phandle_args(np,
 						"canaan,k210-sysctl-power",
 						1, &pdata->power_offset);
-	if (IS_ERR(pdata->sysctl_map))
-		return PTR_ERR(pdata->sysctl_map);
+	if (IS_ERR(pdata->sysctl_map)) {
+		ret = PTR_ERR(pdata->sysctl_map);
+		goto disable_pclk;
+	}
 
 	k210_fpioa_init_ties(pdata);
 
 	pdata->pctl = pinctrl_register(&k210_pinctrl_desc, dev, (void *)pdata);
-	if (IS_ERR(pdata->pctl))
-		return PTR_ERR(pdata->pctl);
+	if (IS_ERR(pdata->pctl)) {
+		ret = PTR_ERR(pdata->pctl);
+		goto disable_pclk;
+	}
 
 	return 0;
+
+disable_pclk:
+	clk_disable_unprepare(pdata->pclk);
+disable_clk:
+	clk_disable_unprepare(pdata->clk);
+
+	return ret;
 }
 
 static const struct of_device_id k210_fpioa_dt_ids[] = {


