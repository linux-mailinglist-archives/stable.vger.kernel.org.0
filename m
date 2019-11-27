Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBDB10B9B4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbfK0Uz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730454AbfK0Uz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:55:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FB2D215F1;
        Wed, 27 Nov 2019 20:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888157;
        bh=UswhGyhlrFUy869t5k6JApHEm0e8NMgYOjtnmdfSLmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgLxKbUQjNyiGBbG1Mz4+AX+48EqMkyDTUB3hAv/LxYtts0VW7DXJoeoXDHQaguBY
         qRtl9AJTHog98vsi/OJm8ypWS5HWJjTlsQVZkI/4DbuzOvfSWw4km3U9DCubchonv7
         NSDcWKqd9mg4jprXPsSmwLEzvTN3x+Kj6VHZ7pGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/306] pinctrl: madera: Fix uninitialized variable bug in madera_mux_set_mux
Date:   Wed, 27 Nov 2019 21:27:56 +0100
Message-Id: <20191127203116.602885955@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

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



