Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A7AEA0E5
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfJ3Pzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728641AbfJ3Pzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:55:39 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 626D8217F9;
        Wed, 30 Oct 2019 15:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450939;
        bh=JDr0T7LlkJ8UHSj7zH/ZxVkHytUH/XKb4qVDCm8HdCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZodgQtSqxjgGbj9Jsw3LWC81uaj7aEUUD3bTV8znDy++J5tR4Czv9sEkEVFZOQak
         QjsbOaQ4OWGyOjSRT9NgjfkTvle9fPfJ0WTaciku/JZ8haFobmMikdQaJAT2rcqlt5
         rySdFBH/kkKYGcPlNkRp+r0rgPRKzcV/Mx+s0CAc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabrice Gasnier <fabrice.gasnier@st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@st.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 32/38] i2c: stm32f7: fix first byte to send in slave mode
Date:   Wed, 30 Oct 2019 11:54:00 -0400
Message-Id: <20191030155406.10109-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

[ Upstream commit 02e64276c6dbcc4c5f39844f33d18180832a58f3 ]

The slave-interface documentation [1] states "the bus driver should
transmit the first byte" upon I2C_SLAVE_READ_REQUESTED slave event:
- 'val': backend returns first byte to be sent
The driver currently ignores the 1st byte to send on this event.

[1] https://www.kernel.org/doc/Documentation/i2c/slave-interface

Fixes: 60d609f30de2 ("i2c: i2c-stm32f7: Add slave support")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-stm32f7.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-stm32f7.c b/drivers/i2c/busses/i2c-stm32f7.c
index ac9c9486b834c..48521bc8a4d23 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1177,6 +1177,8 @@ static void stm32f7_i2c_slave_start(struct stm32f7_i2c_dev *i2c_dev)
 			STM32F7_I2C_CR1_TXIE;
 		stm32f7_i2c_set_bits(base + STM32F7_I2C_CR1, mask);
 
+		/* Write 1st data byte */
+		writel_relaxed(value, base + STM32F7_I2C_TXDR);
 	} else {
 		/* Notify i2c slave that new write transfer is starting */
 		i2c_slave_event(slave, I2C_SLAVE_WRITE_REQUESTED, &value);
-- 
2.20.1

