Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2D928B8AC
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390358AbgJLNyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389744AbgJLNpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B9FE222C8;
        Mon, 12 Oct 2020 13:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510301;
        bh=4yqm3u7dHPwx1jhFIJHj4Viy3hldLcsnKvyL4rvwAKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veoBqIYyS7ibut0blbZCoUobO79ThaZefhZdHrxqXdHMvglqk69P9I/VxPj4JLm6V
         k3bjwj38mJXJDHGs7w4TTG3/eHN1pOmQmCa57FCOFJkjDB81e/YDWSkH6fifYcEgrt
         /8+vbcRjAXhApK49cUWBGrmudfBDnEW7sN08IH+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.8 040/124] i2c: owl: Clear NACK and BUS error bits
Date:   Mon, 12 Oct 2020 15:30:44 +0200
Message-Id: <20201012133148.793675088@linuxfoundation.org>
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
@@ -176,6 +176,9 @@ static irqreturn_t owl_i2c_interrupt(int
 	fifostat = readl(i2c_dev->base + OWL_I2C_REG_FIFOSTAT);
 	if (fifostat & OWL_I2C_FIFOSTAT_RNB) {
 		i2c_dev->err = -ENXIO;
+		/* Clear NACK error bit by writing "1" */
+		owl_i2c_update_reg(i2c_dev->base + OWL_I2C_REG_FIFOSTAT,
+				   OWL_I2C_FIFOSTAT_RNB, true);
 		goto stop;
 	}
 
@@ -183,6 +186,9 @@ static irqreturn_t owl_i2c_interrupt(int
 	stat = readl(i2c_dev->base + OWL_I2C_REG_STAT);
 	if (stat & OWL_I2C_STAT_BEB) {
 		i2c_dev->err = -EIO;
+		/* Clear BUS error bit by writing "1" */
+		owl_i2c_update_reg(i2c_dev->base + OWL_I2C_REG_STAT,
+				   OWL_I2C_STAT_BEB, true);
 		goto stop;
 	}
 


