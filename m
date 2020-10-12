Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1743828B71E
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388898AbgJLNkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731318AbgJLNjD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:39:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F63120678;
        Mon, 12 Oct 2020 13:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509942;
        bh=c3FF0dtBNxenNhYRG9lbq4FRJg05wTXpy+HDvjExw4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcPe+9bEYsltDSfQ8xpnqueyqoVQGCpjbtx2LvC92KVe5YJthAK6SkPz/dWb/uIJb
         73w6hAvhW2M1MEG1SDKHBdpczPg3RG4v/9hJvxXYEz2iq1Xtq9fDWHfoXiiKwJ5R6E
         Yyq7mRIC/JBkeg0iLic/k7iCaQTOspot/mJdjmjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 4.19 24/49] i2c: owl: Clear NACK and BUS error bits
Date:   Mon, 12 Oct 2020 15:27:10 +0200
Message-Id: <20201012132630.577881416@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>

commit f5b3f433641c543ebe5171285a42aa6adcdb2d22 upstream.

When the NACK and BUS error bits are set by the hardware, the driver is
responsible for clearing them by writing "1" into the corresponding
status registers.

Hence perform the necessary operations in owl_i2c_interrupt().

Fixes: d211e62af466 ("i2c: Add Actions Semiconductor Owl family S900 I2C driver")
Reported-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-owl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/i2c/busses/i2c-owl.c
+++ b/drivers/i2c/busses/i2c-owl.c
@@ -179,6 +179,9 @@ static irqreturn_t owl_i2c_interrupt(int
 	fifostat = readl(i2c_dev->base + OWL_I2C_REG_FIFOSTAT);
 	if (fifostat & OWL_I2C_FIFOSTAT_RNB) {
 		i2c_dev->err = -ENXIO;
+		/* Clear NACK error bit by writing "1" */
+		owl_i2c_update_reg(i2c_dev->base + OWL_I2C_REG_FIFOSTAT,
+				   OWL_I2C_FIFOSTAT_RNB, true);
 		goto stop;
 	}
 
@@ -186,6 +189,9 @@ static irqreturn_t owl_i2c_interrupt(int
 	stat = readl(i2c_dev->base + OWL_I2C_REG_STAT);
 	if (stat & OWL_I2C_STAT_BEB) {
 		i2c_dev->err = -EIO;
+		/* Clear BUS error bit by writing "1" */
+		owl_i2c_update_reg(i2c_dev->base + OWL_I2C_REG_STAT,
+				   OWL_I2C_STAT_BEB, true);
 		goto stop;
 	}
 


