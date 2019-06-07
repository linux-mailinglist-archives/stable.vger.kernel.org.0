Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D5839015
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbfFGPst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbfFGPss (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:48:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9E0D20657;
        Fri,  7 Jun 2019 15:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922528;
        bh=8E41xG5V2jNOThd7gcCaz3MJfQ+y/Mx6tzLdEWFnsi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Dj6Ae3P39KsjT8uCFMuCfV0Jzlyc53Kw5UtvyE8e5y5h6nN1ohW3t7ZvbcQQBHX0
         Qsko0kkBwby1PQXZBx1HqQowaZ4o+mG+IBGzW/ZuYayB46XJ23YqHGclXK4v5Zh9RG
         KFQ48sd5QrhwNgTyHUJWzrbZC4UQB2ckm6iGqmdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Okamoto Satoru <okamoto.satoru@socionext.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.1 45/85] i2c: synquacer: fix synquacer_i2c_doxfer() return value
Date:   Fri,  7 Jun 2019 17:39:30 +0200
Message-Id: <20190607153854.643228293@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahisa Kojima <masahisa.kojima@linaro.org>

commit ff9378904d9d7a3fcb8406604e089e535e357b1d upstream.

master_xfer should return the number of messages successfully
processed.

Fixes: 0d676a6c4390 ("i2c: add support for Socionext SynQuacer I2C controller")
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Okamoto Satoru <okamoto.satoru@socionext.com>
Signed-off-by: Masahisa Kojima <masahisa.kojima@linaro.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-synquacer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-synquacer.c
+++ b/drivers/i2c/busses/i2c-synquacer.c
@@ -351,7 +351,7 @@ static int synquacer_i2c_doxfer(struct s
 	/* wait 2 clock periods to ensure the stop has been through the bus */
 	udelay(DIV_ROUND_UP(2 * 1000, i2c->speed_khz));
 
-	return 0;
+	return ret;
 }
 
 static irqreturn_t synquacer_i2c_isr(int irq, void *dev_id)


