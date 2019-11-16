Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D3DFF3D6
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfKPPlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727556AbfKPPlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:17 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9936020740;
        Sat, 16 Nov 2019 15:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918877;
        bh=hQREgqaink3iuJiBJ6qFVYV+ZcjGT3/g+cK8dXTXJjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uD1gvp1ZST0epJCDOaT2KKMAgVHMfn0yZWSzWqNkIPORrhlfE0GMh7rRqM/0ZhLz
         DJF3LvGv0uodV0Fd9MLL4Y3QYGTX2wsu9tzZnnmydS6oekJDADyn62yHaaI/GI0I1a
         KUTg1+fyZem3oZkzYPAt7UF/4qH2g6Fvn6ljXxkY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 005/237] pinctrl: madera: Fix uninitialized variable bug in madera_mux_set_mux
Date:   Sat, 16 Nov 2019 10:37:20 -0500
Message-Id: <20191116154113.7417-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit 4fe81669df50889ff1072c030c59df5f1fa6534e ]

There is a potential execution path in which variable *ret* is checked
in an IF statement, and then its value is used to report an error at
line 659 without being properly initialized previously:

659 if (ret)
660	dev_err(priv->dev, "Failed to write to 0x%x (%d)\n", reg, ret);

Fix this by initializing variable *ret* to 0 in order to
avoid unpredictable or unintended results.

Addresses-Coverity-ID: 1471969 ("Uninitialized scalar variable")
Fixes: 218d72a77b0b ("pinctrl: madera: Add driver for Cirrus Logic Madera codecs")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/cirrus/pinctrl-madera-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/cirrus/pinctrl-madera-core.c b/drivers/pinctrl/cirrus/pinctrl-madera-core.c
index c4f4d904e4a61..618e04407ac85 100644
--- a/drivers/pinctrl/cirrus/pinctrl-madera-core.c
+++ b/drivers/pinctrl/cirrus/pinctrl-madera-core.c
@@ -608,7 +608,7 @@ static int madera_mux_set_mux(struct pinctrl_dev *pctldev,
 	unsigned int n_chip_groups = priv->chip->n_pin_groups;
 	const char *func_name = madera_mux_funcs[selector].name;
 	unsigned int reg;
-	int i, ret;
+	int i, ret = 0;
 
 	dev_dbg(priv->dev, "%s selecting %u (%s) for group %u (%s)\n",
 		__func__, selector, func_name, group,
-- 
2.20.1

