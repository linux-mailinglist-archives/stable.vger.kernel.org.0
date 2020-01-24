Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00997147C92
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgAXJxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:53:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388207AbgAXJw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:52:59 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9742020718;
        Fri, 24 Jan 2020 09:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859579;
        bh=72QCrR6qXizsAjH+wzmpM16qXkayDUh90kShyfOb1dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzZUh2GdTn9hzWaj43WrGJNrGM2kr57XEeAIbork590PRf85f/qQHnUvFHqZPPEdo
         OK/MVq0oiRW6UWrY3p7XMJ8OCMdre4NDxHMPYt2oUOXdnoArsDXFAfUhbT6feNKrnI
         sQJ2wt9/JZN5T1gQItGDBZEIuNnOFqpYiC+w7p18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        "Andrew F. Davis" <afd@ti.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 148/343] regulator: tps65086: Fix tps65086_ldoa1_ranges for selector 0xB
Date:   Fri, 24 Jan 2020 10:29:26 +0100
Message-Id: <20200124092939.474849677@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 45e96e1546900..5a5e9b5bf4bea 100644
--- a/drivers/regulator/tps65086-regulator.c
+++ b/drivers/regulator/tps65086-regulator.c
@@ -90,8 +90,8 @@ static const struct regulator_linear_range tps65086_buck345_25mv_ranges[] = {
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



