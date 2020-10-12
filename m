Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54ED328B896
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgJLNyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:54:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389751AbgJLNpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE8E7222E7;
        Mon, 12 Oct 2020 13:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510296;
        bh=Fucqm5kCTOJqF97SiN85RcuXiui8/JSqJeatcBtmsxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTANp1IvH4UF9E9gc24uGlFk5TQToVy6OHujoehyW6XV9huBWBlfxeF3WRlqfliJ3
         RGqsuGvMQmFb9knCQLiK836ug5WcX+VYyZ/NV9N/AuPGeFTKolUZnSOS3qC8COR6wd
         WufdxUaGh7d+cFKm7LX4dbxlfmzyNwHitxLuKokw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.8 038/124] i2c: meson: keep peripheral clock enabled
Date:   Mon, 12 Oct 2020 15:30:42 +0200
Message-Id: <20201012133148.691247743@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

commit 79e137b1540165f788394658442284d55a858984 upstream.

SCL rate appears to be different than what is expected. For example,
We get 164kHz on i2c3 of the vim3 when 400kHz is expected. This is
partially due to the peripheral clock being disabled when the clock is
set.

Let's keep the peripheral clock on after probe to fix the problem. This
does not affect the SCL output which is still gated when i2c is idle.

Fixes: 09af1c2fa490 ("i2c: meson: set clock divider in probe instead of setting it for each transfer")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-meson.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/i2c/busses/i2c-meson.c
+++ b/drivers/i2c/busses/i2c-meson.c
@@ -370,16 +370,12 @@ static int meson_i2c_xfer_messages(struc
 	struct meson_i2c *i2c = adap->algo_data;
 	int i, ret = 0;
 
-	clk_enable(i2c->clk);
-
 	for (i = 0; i < num; i++) {
 		ret = meson_i2c_xfer_msg(i2c, msgs + i, i == num - 1, atomic);
 		if (ret)
 			break;
 	}
 
-	clk_disable(i2c->clk);
-
 	return ret ?: i;
 }
 
@@ -448,7 +444,7 @@ static int meson_i2c_probe(struct platfo
 		return ret;
 	}
 
-	ret = clk_prepare(i2c->clk);
+	ret = clk_prepare_enable(i2c->clk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't prepare clock\n");
 		return ret;
@@ -470,7 +466,7 @@ static int meson_i2c_probe(struct platfo
 
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret < 0) {
-		clk_unprepare(i2c->clk);
+		clk_disable_unprepare(i2c->clk);
 		return ret;
 	}
 
@@ -488,7 +484,7 @@ static int meson_i2c_remove(struct platf
 	struct meson_i2c *i2c = platform_get_drvdata(pdev);
 
 	i2c_del_adapter(&i2c->adap);
-	clk_unprepare(i2c->clk);
+	clk_disable_unprepare(i2c->clk);
 
 	return 0;
 }


