Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2479B1F8865
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 12:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgFNK3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 06:29:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725265AbgFNK3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jun 2020 06:29:22 -0400
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F03EC204EA;
        Sun, 14 Jun 2020 10:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592130561;
        bh=6cFZsG1Cg06Z0SqhU1Lqbfsgs6dC88nSSS50fU5oMng=;
        h=From:To:Cc:Subject:Date:From;
        b=ckNqKqXB5xIVStBcC6h3zibB/rXKBPHPgoclByL12a7tePbDcGjcXkUNM16yDNI+/
         82in1GhOFLIfvJmVlG3tsP7RsI3UsybodNNatpgdEPEa7WqF+TBhs5wkE4bjkhZu4v
         O7mZGAV43rqRolEyPo3+cYr+tnIZX0MIgeMq+iE0=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] i2c: imx: Fix PM runtime inbalance in probe error path
Date:   Sun, 14 Jun 2020 12:29:03 +0200
Message-Id: <1592130544-19759-1-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When pm_runtime_get_sync() fails in probe(), the error path should not
call pm_runtime_put_noidle().  This would lead to inbalance in
usage_count.

Fixes: 588eb93ea49f ("i2c: imx: add runtime pm support to improve the performance")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Changes since v1:
1. New patch
---
 drivers/i2c/busses/i2c-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 0ab5381aa012..6e45958565d1 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1239,8 +1239,8 @@ static int i2c_imx_probe(struct platform_device *pdev)
 
 clk_notifier_unregister:
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
-rpm_disable:
 	pm_runtime_put_noidle(&pdev->dev);
+rpm_disable:
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.7.4

