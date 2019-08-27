Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249A99E009
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731344AbfH0H74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731338AbfH0H74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:59:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D01A21872;
        Tue, 27 Aug 2019 07:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892795;
        bh=Kup2fMWsYgPa/EosD4IW5uLR75BGpTzJR+7KHe6KxzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8BQ2g+CY1FZQgS0r8CVU52qsZCREqSMjHgCTNcv5yR8tLZTLGYNvLdlcsfuBHTCw
         djsJ0FfNI1g+BHQ5zIC7Yemu5IXCgcpV8aoAhcjMp318kUpw8gOL70/aDIFpxj9Ojw
         AczM2xV+MmMGO+Ll7Qb+4BqM1i3PNKxXlC9jitEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 007/162] regulator: axp20x: fix DCDCA and DCDCD for AXP806
Date:   Tue, 27 Aug 2019 09:48:55 +0200
Message-Id: <20190827072738.508800335@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



