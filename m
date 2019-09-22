Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF09BBA74A
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394830AbfIVS51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394818AbfIVS50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:57:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D58F72186A;
        Sun, 22 Sep 2019 18:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178645;
        bh=7dFsxG1YLl3GjuYFLgokzQIzvV40LA4esZrNSpI38To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eD6CtK+MFtGtPfNhAddJ4VgKRwuJIKNsBdF92VQuGY7fOAi6WJ90l9ovLwAo80Dng
         2qxaIxsYxRzSV5dTTub+2FKOl9bY1Zp94gDkiIe55yyEhxxDVdPZsz03GV/X7fiOkf
         9bTzVfmfycMO/irWUegcJDF3IUT0rnobDlHbhyuY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 02/89] regulator: lm363x: Fix off-by-one n_voltages for lm3632 ldo_vpos/ldo_vneg
Date:   Sun, 22 Sep 2019 14:55:50 -0400
Message-Id: <20190922185717.3412-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
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
index ce5f7d9ad475f..30f576a5daf18 100644
--- a/drivers/regulator/lm363x-regulator.c
+++ b/drivers/regulator/lm363x-regulator.c
@@ -33,7 +33,7 @@
 
 /* LM3632 */
 #define LM3632_BOOST_VSEL_MAX		0x26
-#define LM3632_LDO_VSEL_MAX		0x29
+#define LM3632_LDO_VSEL_MAX		0x28
 #define LM3632_VBOOST_MIN		4500000
 #define LM3632_VLDO_MIN			4000000
 
-- 
2.20.1

