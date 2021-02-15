Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F1531BE30
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 17:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhBOQCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 11:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231948AbhBOPtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:49:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77F3764EBE;
        Mon, 15 Feb 2021 15:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403316;
        bh=pZ7TnNK5FWqXQ/Iyb7sLO3lT8Uu4DIWCxjevEDk4xhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLd5ro6b1+FHpf95w3dSMBxwVk+w5fZhUEdxl1ulNNE3L/IdR1V0ErHjf4yN8A7jL
         ZVh4keHWsTAoQTUOpY4aFTfyIvbIf0jCAqzwiuP0D73EuET5LF5qydGmcjHGxmN60o
         TI2UOe6xRd4trrPowfpLT5v5i6r9G1RoCGrQtpjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@foss.st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/104] i2c: stm32f7: fix configuration of the digital filter
Date:   Mon, 15 Feb 2021 16:27:35 +0100
Message-Id: <20210215152722.097073003@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit 3d6a3d3a2a7a3a60a824e7c04e95fd50dec57812 ]

The digital filter related computation are present in the driver
however the programming of the filter within the IP is missing.
The maximum value for the DNF is wrong and should be 15 instead of 16.

Fixes: aeb068c57214 ("i2c: i2c-stm32f7: add driver")

Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-stm32f7.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-stm32f7.c b/drivers/i2c/busses/i2c-stm32f7.c
index f41f51a176a1d..6747353345475 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -57,6 +57,8 @@
 #define STM32F7_I2C_CR1_RXDMAEN			BIT(15)
 #define STM32F7_I2C_CR1_TXDMAEN			BIT(14)
 #define STM32F7_I2C_CR1_ANFOFF			BIT(12)
+#define STM32F7_I2C_CR1_DNF_MASK		GENMASK(11, 8)
+#define STM32F7_I2C_CR1_DNF(n)			(((n) & 0xf) << 8)
 #define STM32F7_I2C_CR1_ERRIE			BIT(7)
 #define STM32F7_I2C_CR1_TCIE			BIT(6)
 #define STM32F7_I2C_CR1_STOPIE			BIT(5)
@@ -160,7 +162,7 @@ enum {
 };
 
 #define STM32F7_I2C_DNF_DEFAULT			0
-#define STM32F7_I2C_DNF_MAX			16
+#define STM32F7_I2C_DNF_MAX			15
 
 #define STM32F7_I2C_ANALOG_FILTER_ENABLE	1
 #define STM32F7_I2C_ANALOG_FILTER_DELAY_MIN	50	/* ns */
@@ -725,6 +727,13 @@ static void stm32f7_i2c_hw_config(struct stm32f7_i2c_dev *i2c_dev)
 	else
 		stm32f7_i2c_set_bits(i2c_dev->base + STM32F7_I2C_CR1,
 				     STM32F7_I2C_CR1_ANFOFF);
+
+	/* Program the Digital Filter */
+	stm32f7_i2c_clr_bits(i2c_dev->base + STM32F7_I2C_CR1,
+			     STM32F7_I2C_CR1_DNF_MASK);
+	stm32f7_i2c_set_bits(i2c_dev->base + STM32F7_I2C_CR1,
+			     STM32F7_I2C_CR1_DNF(i2c_dev->setup.dnf));
+
 	stm32f7_i2c_set_bits(i2c_dev->base + STM32F7_I2C_CR1,
 			     STM32F7_I2C_CR1_PE);
 }
-- 
2.27.0



