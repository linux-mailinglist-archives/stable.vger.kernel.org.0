Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7448913A510
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgANKEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:04:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729163AbgANKEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:04:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 811502467C;
        Tue, 14 Jan 2020 10:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996261;
        bh=l8K21f1BSw03G59OGU4gmIVI6A4ckLt+MGapVwDypmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQ5qxqRY29otZ++hw2xy+RN/pqHXXff2mUoNZmdhR3wUCQZen4V+u1Tx1AqfE+Edg
         DVwr4UuBx4jmNzdmfWM9wisbgtEXvpEtpK9WhV7fBOQ9KtyBz8OHtGTesXWLMPwLG/
         PnWyEGgIQ6mgjEns7P8wpZ2XLawOT+NFQxZdo+6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 34/78] can: tcan4x5x: tcan4x5x_can_probe(): get the device out of standby before register access
Date:   Tue, 14 Jan 2020 11:01:08 +0100
Message-Id: <20200114094358.214072795@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

commit 3069ce620daed85e4ef2b0c087dca2509f809470 upstream.

The m_can tries to detect if Non ISO Operation is available while in
standby mode, this function results in the following error:

| tcan4x5x spi2.0 (unnamed net_device) (uninitialized): Failed to init module
| tcan4x5x spi2.0: m_can device registered (irq=84, version=32)
| tcan4x5x spi2.0 can2: TCAN4X5X successfully initialized.

When the tcan device comes out of reset it goes in standby mode. The
m_can driver tries to access the control register but fails due to the
device being in standby mode.

So this patch will put the tcan device in normal mode before the m_can
driver does the initialization.

Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Acked-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/m_can/tcan4x5x.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -445,6 +445,10 @@ static int tcan4x5x_can_probe(struct spi
 
 	tcan4x5x_power_enable(priv->power, 1);
 
+	ret = tcan4x5x_init(mcan_class);
+	if (ret)
+		goto out_power;
+
 	ret = m_can_class_register(mcan_class);
 	if (ret)
 		goto out_power;


