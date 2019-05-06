Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2605A14EE5
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfEFPFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727547AbfEFOiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:38:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1A1920449;
        Mon,  6 May 2019 14:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153495;
        bh=l+vwBq8B0iCqSp7zzsk2DETMYixOA5pWhzYBakqzhJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fx15v/a2L1xN4Da0l14LrWpD9CtQyRz4Twb3j883wqaOp5KnZgHTNd/pLOzMlO0gJ
         ZcMVCzxUu1SKX5Zcn71V+TGwwlV1rJWwZpSasXu+8uqEMWWHF+t9Kg51/YymHXWmV+
         Homu4gM4cql0m6PqqKrQgYOyVZQlOs81YooPHfmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.0 111/122] gpio: mxc: add check to return defer probe if clock tree NOT ready
Date:   Mon,  6 May 2019 16:32:49 +0200
Message-Id: <20190506143104.441736734@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <anson.huang@nxp.com>

commit a329bbe707cee2cf8c660890ef2ad0d00ec7e8a3 upstream.

On i.MX8MQ platform, clock driver uses platform driver
model and it is probed after GPIO driver, so when GPIO
driver fails to get clock, it should check the error type
to decide whether to return defer probe or just ignore
the clock operation.

Fixes: 2808801aab8a ("gpio: mxc: add clock operation")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-mxc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -438,8 +438,11 @@ static int mxc_gpio_probe(struct platfor
 
 	/* the controller clock is optional */
 	port->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(port->clk))
+	if (IS_ERR(port->clk)) {
+		if (PTR_ERR(port->clk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
 		port->clk = NULL;
+	}
 
 	err = clk_prepare_enable(port->clk);
 	if (err) {


