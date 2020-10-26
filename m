Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375D129A0A5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409712AbgJ0AcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409520AbgJZXvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C049521D41;
        Mon, 26 Oct 2020 23:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756306;
        bh=JqPoYV47KK0pwBWa3+G12HTHz4SPvU5B/9nnOWIg1Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUJxls4aAfKgEYcySY0LVFWTX1CSVFTAM8eWQuHI2vnOUMjEq+ZlIJdQNiEdZ7uYy
         S3Zq0dfa1z9MNCuK4fThTHCb4h2W/acpU711gfjd10BIvhlWVumqvKQcm5ehjPCgC6
         1Fdwlzv9IGQKKNy1T+RPuqIUtQGIofV5247L9oxQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 131/147] soc: imx: gpcv2: Use dev_err_probe() to simplify error handling
Date:   Mon, 26 Oct 2020 19:48:49 -0400
Message-Id: <20201026234905.1022767-131-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit b663b798d04fb73f1ad4d54c46582d2fde7a76d6 ]

dev_err_probe() can reduce code size, uniform error handling and record the
defer probe reason etc., use it to simplify the code.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/gpcv2.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/soc/imx/gpcv2.c b/drivers/soc/imx/gpcv2.c
index 6cf8a7a412bde..db7e7fc321b16 100644
--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -487,22 +487,17 @@ static int imx_pgc_domain_probe(struct platform_device *pdev)
 
 	domain->regulator = devm_regulator_get_optional(domain->dev, "power");
 	if (IS_ERR(domain->regulator)) {
-		if (PTR_ERR(domain->regulator) != -ENODEV) {
-			if (PTR_ERR(domain->regulator) != -EPROBE_DEFER)
-				dev_err(domain->dev, "Failed to get domain's regulator\n");
-			return PTR_ERR(domain->regulator);
-		}
+		if (PTR_ERR(domain->regulator) != -ENODEV)
+			return dev_err_probe(domain->dev, PTR_ERR(domain->regulator),
+					     "Failed to get domain's regulator\n");
 	} else if (domain->voltage) {
 		regulator_set_voltage(domain->regulator,
 				      domain->voltage, domain->voltage);
 	}
 
 	ret = imx_pgc_get_clocks(domain);
-	if (ret) {
-		if (ret != -EPROBE_DEFER)
-			dev_err(domain->dev, "Failed to get domain's clocks\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(domain->dev, ret, "Failed to get domain's clocks\n");
 
 	ret = pm_genpd_init(&domain->genpd, NULL, true);
 	if (ret) {
-- 
2.25.1

