Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C2F3D765F
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbhG0N2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236970AbhG0NUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF8A661A6E;
        Tue, 27 Jul 2021 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392017;
        bh=As6bvw8NATi8NkV1UwYAGMDuPYyWxXWl8+Dt7lXldyM=;
        h=From:To:Cc:Subject:Date:From;
        b=CEBbXmfi/1SQLD+YeEdZqVtZl1/90k3UKCUXfM4BW7Nm4mjIuCt9MVb9uS4Ow9ICN
         iQFejrD+jFQKIibVseAsZCAECbezE9rY0gV6xWNq4Gx75LV/mFAgrSdxizVMZd6LqP
         mXnTihnDoWDiY6F4VBUra99sBSLCDEE0jdUQ/TGVQn3g9Rvuv6TCSUG0zYdQRzSaD4
         lSQfDzvZfD8Qgsr/HUFnBIQpxlJpG2jUaAOLTw8ZkDblkO5cdC2xW/F3UoVtYMO6os
         qk2MqUmL3k5K9rxJ/YYG8I1XdRuepcDddJSUJQs2HDWyWHAWmkztCAoGU02SENyNnz
         LeTY39qUD320Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 1/6] regulator: rt5033: Fix n_voltages settings for BUCK and LDO
Date:   Tue, 27 Jul 2021 09:20:10 -0400
Message-Id: <20210727132015.835651-1-sashal@kernel.org>
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
index 1b63fc2f42d1..52d53d134f72 100644
--- a/include/linux/mfd/rt5033-private.h
+++ b/include/linux/mfd/rt5033-private.h
@@ -203,13 +203,13 @@ enum rt5033_reg {
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

