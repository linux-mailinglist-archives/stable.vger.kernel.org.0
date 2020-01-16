Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8583713EEA0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395118AbgAPSKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:10:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404925AbgAPRiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:38:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1D58246EE;
        Thu, 16 Jan 2020 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196280;
        bh=7IGcudvzXEpt+hk/Z3DkyNKFSX6fqqcIDRtIJn8TYrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9Wu9DK3WNxz0lpZGQ0Krk5W07K067BXzjWgzb7qfUqDG0Gi8BTD0f4tAvlebKyBH
         NNtwchfF3u1f4KarRR5PyWJAFMhIldjyg97k0Jrnas4IoojA6InnbLuY/GFqDG6ZL1
         0Ed+zZlX6tIfTBk4oz4c9ucN1mCLIN+sEB8BQdhw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, "Andrew F . Davis" <afd@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 100/251] regulator: tps65086: Fix tps65086_ldoa1_ranges for selector 0xB
Date:   Thu, 16 Jan 2020 12:34:09 -0500
Message-Id: <20200116173641.22137-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit e69b394703e032e56a140172440ec4f9890b536d ]

selector 0xB (1011) should be 2.6V rather than 2.7V, fit ix.

Table 5-4. LDOA1 Output Voltage Options
VID Bits VOUT VID Bits VOUT VID Bits VOUT VID Bits VOUT
0000     1.35 0100     1.8  1000     2.3  1100     2.85
0001     1.5  0101     1.9  1001     2.4  1101     3.0
0010     1.6  0110     2.0  1010     2.5  1110     3.3
0011     1.7  0111     2.1  1011     2.6  1111     Not Used

Fixes: d2a2e729a666 ("regulator: tps65086: Add regulator driver for the TPS65086 PMIC")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Andrew F. Davis <afd@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps65086-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps65086-regulator.c b/drivers/regulator/tps65086-regulator.c
index 6dbf3cf3951e..12d26261394f 100644
--- a/drivers/regulator/tps65086-regulator.c
+++ b/drivers/regulator/tps65086-regulator.c
@@ -89,8 +89,8 @@ static const struct regulator_linear_range tps65086_buck345_25mv_ranges[] = {
 static const struct regulator_linear_range tps65086_ldoa1_ranges[] = {
 	REGULATOR_LINEAR_RANGE(1350000, 0x0, 0x0, 0),
 	REGULATOR_LINEAR_RANGE(1500000, 0x1, 0x7, 100000),
-	REGULATOR_LINEAR_RANGE(2300000, 0x8, 0xA, 100000),
-	REGULATOR_LINEAR_RANGE(2700000, 0xB, 0xD, 150000),
+	REGULATOR_LINEAR_RANGE(2300000, 0x8, 0xB, 100000),
+	REGULATOR_LINEAR_RANGE(2850000, 0xC, 0xD, 150000),
 	REGULATOR_LINEAR_RANGE(3300000, 0xE, 0xE, 0),
 };
 
-- 
2.20.1

