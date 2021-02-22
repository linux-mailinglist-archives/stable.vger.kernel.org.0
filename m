Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B514132163F
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhBVMT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:19:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230434AbhBVMRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:17:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94B9B64F13;
        Mon, 22 Feb 2021 12:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996197;
        bh=W8Iy6YrF3A+u0xq4e5/2i4uzGfnVsC3uU6cmDFI8KcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZWekke1sh5EXhuR0mH+gZWXrY/rG+onUctlaZbRf0dqySxuJRM/mlOci948ETSVQ
         HFoUOmj+6dd4WC3e+os8WeK8MoLu3Dd0QXUjLnCbvFxim+Qz0UAnIitIdtmmbVPIXA
         /PwFpoCp6HR+fZvE5npRaHQL5hyRVLTLTWCnVk8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@foss.st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/50] i2c: stm32f7: fix configuration of the digital filter
Date:   Mon, 22 Feb 2021 13:13:16 +0100
Message-Id: <20210222121024.896291023@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
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
index eb7e533b0dd47..6feafebf85feb 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -49,6 +49,8 @@
 #define STM32F7_I2C_CR1_RXDMAEN			BIT(15)
 #define STM32F7_I2C_CR1_TXDMAEN			BIT(14)
 #define STM32F7_I2C_CR1_ANFOFF			BIT(12)
+#define STM32F7_I2C_CR1_DNF_MASK		GENMASK(11, 8)
+#define STM32F7_I2C_CR1_DNF(n)			(((n) & 0xf) << 8)
 #define STM32F7_I2C_CR1_ERRIE			BIT(7)
 #define STM32F7_I2C_CR1_TCIE			BIT(6)
 #define STM32F7_I2C_CR1_STOPIE			BIT(5)
@@ -147,7 +149,7 @@
 #define STM32F7_I2C_MAX_SLAVE			0x2
 
 #define STM32F7_I2C_DNF_DEFAULT			0
-#define STM32F7_I2C_DNF_MAX			16
+#define STM32F7_I2C_DNF_MAX			15
 
 #define STM32F7_I2C_ANALOG_FILTER_ENABLE	1
 #define STM32F7_I2C_ANALOG_FILTER_DELAY_MIN	50	/* ns */
@@ -645,6 +647,13 @@ static void stm32f7_i2c_hw_config(struct stm32f7_i2c_dev *i2c_dev)
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



