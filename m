Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AC71C15F0
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgEANgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730853AbgEANgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:36:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DD132173E;
        Fri,  1 May 2020 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340190;
        bh=kT2ssjy/cji7MP5tBA4BbKIZOxWc02oDr3+Bg7R6hiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pocFwyInZzx5KavArH/hy1aWGy39UU5i4IMpuqZ2GxuV9QLoSxXSgQ7l+ugQAuOOu
         vVir0O02R+lHhzxQmsbuwbq0G57xqk7RUPvKqNJlFqdhs1iW6jWU77DOvLX+0wItax
         mK9FqQkKcJRJw26KCZAcq3zZo7nVuNUHxTultpoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 4.19 12/46] i2c: altera: use proper variable to hold errno
Date:   Fri,  1 May 2020 15:22:37 +0200
Message-Id: <20200501131503.107772756@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit edb2c9dd3948738ef030c32b948543e84f4d3f81 upstream.

device_property_read_u32() returns errno or 0, so we should use the
integer variable 'ret' and not the u32 'val' to hold the retval.

Fixes: 0560ad576268 ("i2c: altera: Add Altera I2C Controller driver")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-altera.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/i2c/busses/i2c-altera.c
+++ b/drivers/i2c/busses/i2c-altera.c
@@ -395,7 +395,6 @@ static int altr_i2c_probe(struct platfor
 	struct altr_i2c_dev *idev = NULL;
 	struct resource *res;
 	int irq, ret;
-	u32 val;
 
 	idev = devm_kzalloc(&pdev->dev, sizeof(*idev), GFP_KERNEL);
 	if (!idev)
@@ -422,17 +421,17 @@ static int altr_i2c_probe(struct platfor
 	init_completion(&idev->msg_complete);
 	spin_lock_init(&idev->lock);
 
-	val = device_property_read_u32(idev->dev, "fifo-size",
+	ret = device_property_read_u32(idev->dev, "fifo-size",
 				       &idev->fifo_size);
-	if (val) {
+	if (ret) {
 		dev_err(&pdev->dev, "FIFO size set to default of %d\n",
 			ALTR_I2C_DFLT_FIFO_SZ);
 		idev->fifo_size = ALTR_I2C_DFLT_FIFO_SZ;
 	}
 
-	val = device_property_read_u32(idev->dev, "clock-frequency",
+	ret = device_property_read_u32(idev->dev, "clock-frequency",
 				       &idev->bus_clk_rate);
-	if (val) {
+	if (ret) {
 		dev_err(&pdev->dev, "Default to 100kHz\n");
 		idev->bus_clk_rate = 100000;	/* default clock rate */
 	}


