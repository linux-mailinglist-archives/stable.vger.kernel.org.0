Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3D8321706
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhBVMlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:41:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231454AbhBVMjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:39:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01B6B64F0B;
        Mon, 22 Feb 2021 12:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997492;
        bh=dVLQvtbsKCojXjoXcwI0+T5ojVYY+xl9GaZtIR/vDes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RscYSy1G8YoVgC3ki59tLtwJncu5jrJYLKgblpytYnXZBzN+rMcrJ+voXO3tRcobR
         omd6GbASEF+hpmPFTNERs4YzCczKkcTxhCmnPv07PnMHXX32+u3gfm+85ve0ig+WQH
         LFTw513yzv34kCeIyH4d3CToaHEnLG96d5K0THmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@foss.st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/57] i2c: stm32f7: fix configuration of the digital filter
Date:   Mon, 22 Feb 2021 13:36:05 +0100
Message-Id: <20210222121030.706809562@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
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
index 14f60751729e7..9768921a164c0 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -42,6 +42,8 @@
 
 /* STM32F7 I2C control 1 */
 #define STM32F7_I2C_CR1_ANFOFF			BIT(12)
+#define STM32F7_I2C_CR1_DNF_MASK		GENMASK(11, 8)
+#define STM32F7_I2C_CR1_DNF(n)			(((n) & 0xf) << 8)
 #define STM32F7_I2C_CR1_ERRIE			BIT(7)
 #define STM32F7_I2C_CR1_TCIE			BIT(6)
 #define STM32F7_I2C_CR1_STOPIE			BIT(5)
@@ -95,7 +97,7 @@
 #define STM32F7_I2C_MAX_LEN			0xff
 
 #define STM32F7_I2C_DNF_DEFAULT			0
-#define STM32F7_I2C_DNF_MAX			16
+#define STM32F7_I2C_DNF_MAX			15
 
 #define STM32F7_I2C_ANALOG_FILTER_ENABLE	1
 #define STM32F7_I2C_ANALOG_FILTER_DELAY_MIN	50	/* ns */
@@ -543,6 +545,13 @@ static void stm32f7_i2c_hw_config(struct stm32f7_i2c_dev *i2c_dev)
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



