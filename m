Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124E68C99E
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfHNCLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbfHNCLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 732F020843;
        Wed, 14 Aug 2019 02:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748670;
        bh=MaduVF6iNpXvWde2fkiZMZmprgBmsNqK0M2M43kp2M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZbvEJtCTpDhzo4wj4iQXlAE8OaXO6UWFM8I2KAsVdXtNB8LMsTXG1QJZVEYDRShJ
         ksoXAcEQi/eN7EP9Q4yOALMZm2MC6HjY3RDn2xAyte+hkD8OFb51q/ulJEuyvEILF9
         Gk4++ThwPxKDSVC8+IjX1yO7Ai2Roku8uv1lf7VM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 011/123] regulator: axp20x: fix DCDCA and DCDCD for AXP806
Date:   Tue, 13 Aug 2019 22:08:55 -0400
Message-Id: <20190814021047.14828-11-sashal@kernel.org>
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

[ Upstream commit 1ef55fed9219963359a7b3bc7edca8517c6e45ac ]

Refactoring of the driver introduced bugs in AXP806's DCDCA and DCDCD
regulator definitions.

In DCDCA case, AXP806_DCDCA_1120mV_STEPS was obtained by subtracting
0x47 and 0x33. This should be 0x14 (hex) and not 14 (dec).

In DCDCD case, axp806_dcdcd_ranges[] contains two ranges with same
start and end macros, which is clearly wrong. Second range starts at
1.6V so it should use AXP806_DCDCD_1600mV_[START|END] macros. They are
already defined but unused.

Fixes: db4a555f7c4c ("regulator: axp20x: use defines for masks")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20190713090717.347-2-jernej.skrabec@siol.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/axp20x-regulator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index 152053361862d..c951568994a11 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -240,7 +240,7 @@
 #define AXP806_DCDCA_600mV_END		\
 	(AXP806_DCDCA_600mV_START + AXP806_DCDCA_600mV_STEPS)
 #define AXP806_DCDCA_1120mV_START	0x33
-#define AXP806_DCDCA_1120mV_STEPS	14
+#define AXP806_DCDCA_1120mV_STEPS	20
 #define AXP806_DCDCA_1120mV_END		\
 	(AXP806_DCDCA_1120mV_START + AXP806_DCDCA_1120mV_STEPS)
 #define AXP806_DCDCA_NUM_VOLTAGES	72
@@ -774,8 +774,8 @@ static const struct regulator_linear_range axp806_dcdcd_ranges[] = {
 			       AXP806_DCDCD_600mV_END,
 			       20000),
 	REGULATOR_LINEAR_RANGE(1600000,
-			       AXP806_DCDCD_600mV_START,
-			       AXP806_DCDCD_600mV_END,
+			       AXP806_DCDCD_1600mV_START,
+			       AXP806_DCDCD_1600mV_END,
 			       100000),
 };
 
-- 
2.20.1

