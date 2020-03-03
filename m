Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF6417812A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387882AbgCCSBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387871AbgCCSA6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:00:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E1E920728;
        Tue,  3 Mar 2020 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258457;
        bh=j/cTGtyx0i2W8prlaQJxrHhlNQJqNPuJz2rSwBTjyBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmrvZTKOZj9U55NLQGLQrhosanzkHPwOxWN6GAUUJIOlgyYYCcsjGHI84HepumxTy
         Byelepg53pcDWJwgEMUJCdToMtC4wv4rHY3voEXLj15pLGfJqtVoCFXMWf0cvcuES+
         DNM0wPfW6BrjPIAIZNOZqLMI6B7wKpqYdoRxxzvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 4.19 55/87] i2c: altera: Fix potential integer overflow
Date:   Tue,  3 Mar 2020 18:43:46 +0100
Message-Id: <20200303174355.303363758@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 54498e8070e19e74498a72c7331348143e7e1f8c upstream.

Factor out 100 from the equation and do 32-bit arithmetic (3 * clk_mhz / 10)
instead of 64-bit.

Notice that clk_mhz is MHz, so the multiplication will never wrap 32 bits
and there is no need for div_u64().

Addresses-Coverity: 1458369 ("Unintentional integer overflow")
Fixes: 0560ad576268 ("i2c: altera: Add Altera I2C Controller driver")
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-altera.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-altera.c
+++ b/drivers/i2c/busses/i2c-altera.c
@@ -182,7 +182,7 @@ static void altr_i2c_init(struct altr_i2
 	/* SCL Low Time */
 	writel(t_low, idev->base + ALTR_I2C_SCL_LOW);
 	/* SDA Hold Time, 300ns */
-	writel(div_u64(300 * clk_mhz, 1000), idev->base + ALTR_I2C_SDA_HOLD);
+	writel(3 * clk_mhz / 10, idev->base + ALTR_I2C_SDA_HOLD);
 
 	/* Mask all master interrupt bits */
 	altr_i2c_int_enable(idev, ALTR_I2C_ALL_IRQ, false);


