Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8644B8C99F
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfHNCkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727254AbfHNCLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6803B2085A;
        Wed, 14 Aug 2019 02:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748671;
        bh=tXCXrScC8OHVXgT7BSG6vP4u7EQ7ruRY0gw5lPejnmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qU2UmqKpaOYpQhUnR3QjYVbiS7DVb6LFQ6U0N1V+kjMvdvWLry6hVhwmXq13EXW4H
         OsbO05+Qem0uqhsKk1HYQV9vZLqup0C9pYemWL4gEujLyCKDVrB0M6bFzU75DeR7nt
         RjToUgxjdbu/ZZM/L3xBpnkS1VK62kRjxk7zrTFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 012/123] regulator: axp20x: fix DCDC5 and DCDC6 for AXP803
Date:   Tue, 13 Aug 2019 22:08:56 -0400
Message-Id: <20190814021047.14828-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 8f46e22b5ac692b48d04bb722547ca17b66dda02 ]

Refactoring of axp20x driver introduced a bug in AXP803's DCDC6
regulator definition. AXP803_DCDC6_1120mV_STEPS was obtained by
subtracting 0x47 and 0x33. This should be 0x14 (hex) and not 14
(dec).

Refactoring also carried over a bug in DCDC5 regulator definition.
Number of possible voltages must be for 1 bigger than maximum valid
voltage index, because 0 is also valid and it means lowest voltage.

Fixes: 1dbe0ccb0631 ("regulator: axp20x-regulator: add support for AXP803")
Fixes: db4a555f7c4c ("regulator: axp20x: use defines for masks")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20190713090717.347-3-jernej.skrabec@siol.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/axp20x-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index c951568994a11..989506bd90b19 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -174,14 +174,14 @@
 #define AXP803_DCDC5_1140mV_STEPS	35
 #define AXP803_DCDC5_1140mV_END		\
 	(AXP803_DCDC5_1140mV_START + AXP803_DCDC5_1140mV_STEPS)
-#define AXP803_DCDC5_NUM_VOLTAGES	68
+#define AXP803_DCDC5_NUM_VOLTAGES	69
 
 #define AXP803_DCDC6_600mV_START	0x00
 #define AXP803_DCDC6_600mV_STEPS	50
 #define AXP803_DCDC6_600mV_END		\
 	(AXP803_DCDC6_600mV_START + AXP803_DCDC6_600mV_STEPS)
 #define AXP803_DCDC6_1120mV_START	0x33
-#define AXP803_DCDC6_1120mV_STEPS	14
+#define AXP803_DCDC6_1120mV_STEPS	20
 #define AXP803_DCDC6_1120mV_END		\
 	(AXP803_DCDC6_1120mV_START + AXP803_DCDC6_1120mV_STEPS)
 #define AXP803_DCDC6_NUM_VOLTAGES	72
-- 
2.20.1

