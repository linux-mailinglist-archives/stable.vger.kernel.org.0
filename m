Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE11390DB
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbfFGPzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731293AbfFGPpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:45:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3A0C2147A;
        Fri,  7 Jun 2019 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922346;
        bh=noMDM0+G7fvAYTkP+qTa1fHN6gTn8pJOT/sFJUBXcqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlLsq4TeJOAmaLUvo8r6Ymw7jSOAgAJWOc3Ab6Dh2Cb1544r/FxbDrGVrVAtTAKTM
         OyyjRscfDVwk6e3BrgSEelCntoSSvLXNO9M9d2neO6gp/GPYXZcAPkL5UvcaIBwJKe
         gJ4ZhpvfdiAFZrpra0mAkvxS7lETjiYaY9xO8ATc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Okamoto Satoru <okamoto.satoru@socionext.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 4.19 37/73] i2c: synquacer: fix synquacer_i2c_doxfer() return value
Date:   Fri,  7 Jun 2019 17:39:24 +0200
Message-Id: <20190607153853.262623656@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
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
@@ -356,7 +356,7 @@ static int synquacer_i2c_doxfer(struct s
 	/* wait 2 clock periods to ensure the stop has been through the bus */
 	udelay(DIV_ROUND_UP(2 * 1000, i2c->speed_khz));
 
-	return 0;
+	return ret;
 }
 
 static irqreturn_t synquacer_i2c_isr(int irq, void *dev_id)


