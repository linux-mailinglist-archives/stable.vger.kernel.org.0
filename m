Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988F8BAAAF
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731775AbfIVT3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392404AbfIVStc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:49:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9608208C2;
        Sun, 22 Sep 2019 18:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178171;
        bh=yXWj2bvR3dpUriiGdOgoiAtmGWjIFSMW48e8OMrrxdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyqXKqssHoFPy0Aef9VShtVJZPIkz4J2MUarPo5C9cGXYzLI01kGubPWb4wzTHTDE
         ZEtSIRoenwP7yZ7WynBNQ1fhb+Fuc3T9ZJOw7RZUYM82xdy2jLsu+mv0JJABj7a+2S
         kNJZnlne34qrDVM0Fbxug5s6d3FctfW6C6E+ruVM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 004/185] regulator: lm363x: Fix off-by-one n_voltages for lm3632 ldo_vpos/ldo_vneg
Date:   Sun, 22 Sep 2019 14:46:22 -0400
Message-Id: <20190922184924.32534-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 1e2cc8c5e0745b545d4974788dc606d678b6e564 ]

According to the datasheet https://www.ti.com/lit/ds/symlink/lm3632a.pdf
Table 20. VPOS Bias Register Field Descriptions VPOS[5:0]
Sets the Positive Display Bias (LDO) Voltage (50 mV per step)
000000: 4 V
000001: 4.05 V
000010: 4.1 V
....................
011101: 5.45 V
011110: 5.5 V (Default)
011111: 5.55 V
....................
100111: 5.95 V
101000: 6 V
Note: Codes 101001 to 111111 map to 6 V

The LM3632_LDO_VSEL_MAX should be 0b101000 (0x28), so the maximum voltage
can match the datasheet.

Fixes: 3a8d1a73a037 ("regulator: add LM363X driver")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20190626132632.32629-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/lm363x-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/lm363x-regulator.c b/drivers/regulator/lm363x-regulator.c
index 60f15a7227607..7e2ea8c76f6ea 100644
--- a/drivers/regulator/lm363x-regulator.c
+++ b/drivers/regulator/lm363x-regulator.c
@@ -30,7 +30,7 @@
 
 /* LM3632 */
 #define LM3632_BOOST_VSEL_MAX		0x26
-#define LM3632_LDO_VSEL_MAX		0x29
+#define LM3632_LDO_VSEL_MAX		0x28
 #define LM3632_VBOOST_MIN		4500000
 #define LM3632_VLDO_MIN			4000000
 
-- 
2.20.1

