Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B819140020
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390458AbgAPXTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:19:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390456AbgAPXTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:19:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E50F62072E;
        Thu, 16 Jan 2020 23:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216780;
        bh=tL8PqyFVxZml9STucnW49Uk4VHzgmxIX2lyzMjCWgr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNDv0LQcS3U8mVdjDDvvIBNtWSrAQtMBXGnN+yhZw+rgVd++sMVGjCI/HdigPxm7z
         eVL3RRUMYItmCYjPRcrLJIfELpzZEDo1+O1Zfbet6Di5BG2VsrSi+KTNWuBwqKtMNW
         wOl5IL+32jWoFo+d21ipDArQHqTj274QNLzG5suU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <wahrenst@gmx.net>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.4 008/203] i2c: bcm2835: Store pointer to bus clock
Date:   Fri, 17 Jan 2020 00:15:25 +0100
Message-Id: <20200116231745.723014121@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>

commit 3b722da6672df8392f9c43d7c7e04bddd81d7e37 upstream.

The commit bebff81fb8b9 ("i2c: bcm2835: Model Divider in CCF") introduced
a NULL pointer dereference on driver unload. It seems that we can't fetch
the bus clock via devm_clk_get in bcm2835_i2c_remove. As an alternative
approach store a pointer to the bus clock in the private driver structure.

Fixes: bebff81fb8b9 ("i2c: bcm2835: Model Divider in CCF")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-bcm2835.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -58,6 +58,7 @@ struct bcm2835_i2c_dev {
 	struct i2c_adapter adapter;
 	struct completion completion;
 	struct i2c_msg *curr_msg;
+	struct clk *bus_clk;
 	int num_msgs;
 	u32 msg_err;
 	u8 *msg_buf;
@@ -404,7 +405,6 @@ static int bcm2835_i2c_probe(struct plat
 	struct resource *mem, *irq;
 	int ret;
 	struct i2c_adapter *adap;
-	struct clk *bus_clk;
 	struct clk *mclk;
 	u32 bus_clk_rate;
 
@@ -427,11 +427,11 @@ static int bcm2835_i2c_probe(struct plat
 		return PTR_ERR(mclk);
 	}
 
-	bus_clk = bcm2835_i2c_register_div(&pdev->dev, mclk, i2c_dev);
+	i2c_dev->bus_clk = bcm2835_i2c_register_div(&pdev->dev, mclk, i2c_dev);
 
-	if (IS_ERR(bus_clk)) {
+	if (IS_ERR(i2c_dev->bus_clk)) {
 		dev_err(&pdev->dev, "Could not register clock\n");
-		return PTR_ERR(bus_clk);
+		return PTR_ERR(i2c_dev->bus_clk);
 	}
 
 	ret = of_property_read_u32(pdev->dev.of_node, "clock-frequency",
@@ -442,13 +442,13 @@ static int bcm2835_i2c_probe(struct plat
 		bus_clk_rate = 100000;
 	}
 
-	ret = clk_set_rate_exclusive(bus_clk, bus_clk_rate);
+	ret = clk_set_rate_exclusive(i2c_dev->bus_clk, bus_clk_rate);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Could not set clock frequency\n");
 		return ret;
 	}
 
-	ret = clk_prepare_enable(bus_clk);
+	ret = clk_prepare_enable(i2c_dev->bus_clk);
 	if (ret) {
 		dev_err(&pdev->dev, "Couldn't prepare clock");
 		return ret;
@@ -491,10 +491,9 @@ static int bcm2835_i2c_probe(struct plat
 static int bcm2835_i2c_remove(struct platform_device *pdev)
 {
 	struct bcm2835_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
-	struct clk *bus_clk = devm_clk_get(i2c_dev->dev, "div");
 
-	clk_rate_exclusive_put(bus_clk);
-	clk_disable_unprepare(bus_clk);
+	clk_rate_exclusive_put(i2c_dev->bus_clk);
+	clk_disable_unprepare(i2c_dev->bus_clk);
 
 	free_irq(i2c_dev->irq, i2c_dev);
 	i2c_del_adapter(&i2c_dev->adapter);


