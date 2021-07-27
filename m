Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD553D766A
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbhG0N22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236943AbhG0NU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30DAD61ADF;
        Tue, 27 Jul 2021 13:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392003;
        bh=tJ1D1zFs0Ylz1KRKABjtoasSqKI0FcM1HowOtKwSuPE=;
        h=From:To:Cc:Subject:Date:From;
        b=LWjUNZz3WYqW/qa5Gj8BjAYU2vfqT5sz13uNAPF4oLifqErU8KHGPnEbHjWnPZZk3
         Zpw/AlOnDUo7u2fsfNBicAD00IKzd75KOsuMdrC+RRGw8rUPKp0p6XmHN4uqiGgLkL
         p6Uzr7qyrNVMbxdE6EabCpgSJiXxeYWopEUu8ls09IBKA24cCwGvBFaJ0JgATNwxQ3
         ff7Cw/js+JRbNjBR7a3ImInYY3fsZ4Sb8lGjyIiON3AJuC/ElfGepU8RDfZA1a/6/Z
         heV8CNjrEfSFg5NiOyOUa7HBWlrd5swTIlIVaCScFpO03qG5ToVdFyb+RCmdH1Ro01
         s5X8wLImgi/BQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 1/9] regulator: rt5033: Fix n_voltages settings for BUCK and LDO
Date:   Tue, 27 Jul 2021 09:19:53 -0400
Message-Id: <20210727132002.835130-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 6549c46af8551b346bcc0b9043f93848319acd5c ]

For linear regulators, the n_voltages should be (max - min) / step + 1.

Buck voltage from 1v to 3V, per step 100mV, and vout mask is 0x1f.
If value is from 20 to 31, the voltage will all be fixed to 3V.
And LDO also, just vout range is different from 1.2v to 3v, step is the
same. If value is from 18 to 31, the voltage will also be fixed to 3v.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/20210627080418.1718127-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/rt5033-private.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mfd/rt5033-private.h b/include/linux/mfd/rt5033-private.h
index f812105c538c..f2271bfb3273 100644
--- a/include/linux/mfd/rt5033-private.h
+++ b/include/linux/mfd/rt5033-private.h
@@ -200,13 +200,13 @@ enum rt5033_reg {
 #define RT5033_REGULATOR_BUCK_VOLTAGE_MIN		1000000U
 #define RT5033_REGULATOR_BUCK_VOLTAGE_MAX		3000000U
 #define RT5033_REGULATOR_BUCK_VOLTAGE_STEP		100000U
-#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP_NUM		32
+#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP_NUM		21
 
 /* RT5033 regulator LDO output voltage uV */
 #define RT5033_REGULATOR_LDO_VOLTAGE_MIN		1200000U
 #define RT5033_REGULATOR_LDO_VOLTAGE_MAX		3000000U
 #define RT5033_REGULATOR_LDO_VOLTAGE_STEP		100000U
-#define RT5033_REGULATOR_LDO_VOLTAGE_STEP_NUM		32
+#define RT5033_REGULATOR_LDO_VOLTAGE_STEP_NUM		19
 
 /* RT5033 regulator SAFE LDO output voltage uV */
 #define RT5033_REGULATOR_SAFE_LDO_VOLTAGE		4900000U
-- 
2.30.2

