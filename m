Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195292C0979
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388269AbgKWNIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732857AbgKWMst (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ED8A20657;
        Mon, 23 Nov 2020 12:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135727;
        bh=Fh7vt6ohCYFpk/PBBj4u47Kfj7cQ1Xq/+g2UZaUNW90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGQFAlUm2Ad2Q89odSt3t7UyPTkdftxrX+W+hRlad91AFaFYZGf4IA5751gxc4wMf
         4IzOzQYcB6SuYnt1CZRuuDXcGywgs6/JRolN7xIq5RBbgdtEIKWnAwuYCMsziih3T3
         8LU8Oy8CGM6fDtmr37dL+Kd2+5k7FVGh+ovCtyek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 146/252] spi: cadence-quadspi: Fix error return code in cqspi_probe
Date:   Mon, 23 Nov 2020 13:21:36 +0100
Message-Id: <20201123121842.641730851@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit ac9978fcad3c5abc43cdd225441ce9459c36e16b ]

Fix to return the error code from
devm_reset_control_get_optional_exclusive() instaed of 0
in cqspi_probe().

Fixes: 31fb632b5d43ca ("spi: Move cadence-quadspi driver to drivers/spi/")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20201116141836.2970579-1-chengzhihao1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index c6795c684b16a..9f8cae7a35bb6 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1263,12 +1263,14 @@ static int cqspi_probe(struct platform_device *pdev)
 	/* Obtain QSPI reset control */
 	rstc = devm_reset_control_get_optional_exclusive(dev, "qspi");
 	if (IS_ERR(rstc)) {
+		ret = PTR_ERR(rstc);
 		dev_err(dev, "Cannot get QSPI reset.\n");
 		goto probe_reset_failed;
 	}
 
 	rstc_ocp = devm_reset_control_get_optional_exclusive(dev, "qspi-ocp");
 	if (IS_ERR(rstc_ocp)) {
+		ret = PTR_ERR(rstc_ocp);
 		dev_err(dev, "Cannot get QSPI OCP reset.\n");
 		goto probe_reset_failed;
 	}
-- 
2.27.0



