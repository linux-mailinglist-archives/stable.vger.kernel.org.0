Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD04E43F49
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390272AbfFMP4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731523AbfFMIvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2250120851;
        Thu, 13 Jun 2019 08:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415874;
        bh=egVTssJezJuO5TTf/IN4qmOTXmAMMqK8Ii9LVI6I2sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwSiMmYZU0yT7dPqo1RMEWuysB3pn0qqn/Eenre/Rc0xDudMUYsqP8m5+SHjvsh+i
         e4TKa/JJvETu0J1WNnr4m3J5VVdmy6GWj/P0YljKovx7JqITpYnHx/c/MuhqB7eRUM
         7eQ8SZFCOXathOk4qiG8D7oHxOiDmDzTI4Gw+qMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagan Teki <jagan@amarulasolutions.com>,
        Rob Herring <robh@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 128/155] Input: goodix - add GT5663 CTP support
Date:   Thu, 13 Jun 2019 10:34:00 +0200
Message-Id: <20190613075659.968440813@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a5f50c501321249d67611353dde6d68d48c5b959 ]

GT5663 is capacitive touch controller with customized smart
wakeup gestures.

Add support for it by adding compatible and supported chip data.

The chip data on GT5663 is similar to GT1151, like
- config data register has 0x8050 address
- config data register max len is 240
- config data checksum has 16-bit

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/input/touchscreen/goodix.txt | 1 +
 drivers/input/touchscreen/goodix.c                             | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/input/touchscreen/goodix.txt b/Documentation/devicetree/bindings/input/touchscreen/goodix.txt
index 8cf0b4d38a7e..109cc0cebaa2 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/goodix.txt
+++ b/Documentation/devicetree/bindings/input/touchscreen/goodix.txt
@@ -3,6 +3,7 @@ Device tree bindings for Goodix GT9xx series touchscreen controller
 Required properties:
 
  - compatible		: Should be "goodix,gt1151"
+				 or "goodix,gt5663"
 				 or "goodix,gt5688"
 				 or "goodix,gt911"
 				 or "goodix,gt9110"
diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index f57d82220a88..dd029e689903 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -216,6 +216,7 @@ static const struct goodix_chip_data *goodix_get_chip_data(u16 id)
 {
 	switch (id) {
 	case 1151:
+	case 5663:
 	case 5688:
 		return &gt1x_chip_data;
 
@@ -945,6 +946,7 @@ MODULE_DEVICE_TABLE(acpi, goodix_acpi_match);
 #ifdef CONFIG_OF
 static const struct of_device_id goodix_of_match[] = {
 	{ .compatible = "goodix,gt1151" },
+	{ .compatible = "goodix,gt5663" },
 	{ .compatible = "goodix,gt5688" },
 	{ .compatible = "goodix,gt911" },
 	{ .compatible = "goodix,gt9110" },
-- 
2.20.1



