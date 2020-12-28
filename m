Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745882E40C6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504210AbgL1O5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:57:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391774AbgL1OQY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B77A220731;
        Mon, 28 Dec 2020 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164944;
        bh=LgldpMDVU4q8dllax2srGkExxRoqlemJ1a2XzNMXvZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMZVvYFnRNcMJtjC/ckovdL4pTkURF1LRqLVll2P1n7fGVy5uQcvLOwXDsSrwUUr5
         4/rEoSq9JMX+5TO5obKW36CIiZcjnbUrh3Kduycq7HuJ7x1yl3tc/at+HZZlEF2SuE
         DJXQwSgPnoN55HzJRgns1hBbYfft+3MbJab9w7uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 355/717] clk: fsl-sai: fix memory leak
Date:   Mon, 28 Dec 2020 13:45:53 +0100
Message-Id: <20201228125038.028369564@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit e81bed419f032824e7ddf8b5630153be6637e480 ]

If the device is removed we don't unregister the composite clock. Fix
that.

Fixes: 9cd10205227c ("clk: fsl-sai: new driver")
Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20201105192746.19564-2-michael@walle.cc
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-fsl-sai.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/clk/clk-fsl-sai.c b/drivers/clk/clk-fsl-sai.c
index 0221180a4dd73..1e81c8d8a6fd3 100644
--- a/drivers/clk/clk-fsl-sai.c
+++ b/drivers/clk/clk-fsl-sai.c
@@ -68,9 +68,20 @@ static int fsl_sai_clk_probe(struct platform_device *pdev)
 	if (IS_ERR(hw))
 		return PTR_ERR(hw);
 
+	platform_set_drvdata(pdev, hw);
+
 	return devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, hw);
 }
 
+static int fsl_sai_clk_remove(struct platform_device *pdev)
+{
+	struct clk_hw *hw = platform_get_drvdata(pdev);
+
+	clk_hw_unregister_composite(hw);
+
+	return 0;
+}
+
 static const struct of_device_id of_fsl_sai_clk_ids[] = {
 	{ .compatible = "fsl,vf610-sai-clock" },
 	{ }
@@ -79,6 +90,7 @@ MODULE_DEVICE_TABLE(of, of_fsl_sai_clk_ids);
 
 static struct platform_driver fsl_sai_clk_driver = {
 	.probe = fsl_sai_clk_probe,
+	.remove = fsl_sai_clk_remove,
 	.driver		= {
 		.name	= "fsl-sai-clk",
 		.of_match_table = of_fsl_sai_clk_ids,
-- 
2.27.0



