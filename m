Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD87922F29D
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbgG0OIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgG0OIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:08:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2419620838;
        Mon, 27 Jul 2020 14:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858916;
        bh=E4hMhv9MnCUG4J4l+0OHGK6Kd2A7ToIE1oU1Q6qAS5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsBxG7zkOK2U6DnwrdXJQZD4B0/BN3V9x9FRMe3UYF3oNvq+GlFXwfm2T/k61g9WH
         acMOQ0JlSwUiZkijmo5AylfKQyU/1Oeq2KBOq0XtPaSSpbne4KIQTJbXvIXwMCTdnH
         qp4xF8wlS+UzpO5R02RwFVph6hogrjyXWcY0jWCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/64] i2c: rcar: always clear ICSAR to avoid side effects
Date:   Mon, 27 Jul 2020 16:04:09 +0200
Message-Id: <20200727134912.650137861@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134911.020675249@linuxfoundation.org>
References: <20200727134911.020675249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit eb01597158ffb1853a7a7fc2c57d4c844640f75e ]

On R-Car Gen2, we get a timeout when reading from the address set in
ICSAR, even though the slave interface is disabled. Clearing it fixes
this situation. Note that Gen3 is not affected.

To reproduce: bind and undbind an I2C slave on some bus, run
'i2cdetect' on that bus.

Fixes: de20d1857dd6 ("i2c: rcar: add slave support")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 132c4a405bf83..db9ca8e926ca7 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -817,6 +817,7 @@ static int rcar_unreg_slave(struct i2c_client *slave)
 	/* disable irqs and ensure none is running before clearing ptr */
 	rcar_i2c_write(priv, ICSIER, 0);
 	rcar_i2c_write(priv, ICSCR, 0);
+	rcar_i2c_write(priv, ICSAR, 0); /* Gen2: must be 0 if not using slave */
 
 	synchronize_irq(priv->irq);
 	priv->slave = NULL;
@@ -914,6 +915,8 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out_pm_put;
 
+	rcar_i2c_write(priv, ICSAR, 0); /* Gen2: must be 0 if not using slave */
+
 	if (priv->devtype == I2C_RCAR_GEN3) {
 		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 		if (!IS_ERR(priv->rstc)) {
-- 
2.25.1



