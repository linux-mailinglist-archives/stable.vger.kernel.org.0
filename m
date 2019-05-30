Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF742F444
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388176AbfE3Egn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729299AbfE3DM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:57 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69EB923E29;
        Thu, 30 May 2019 03:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185976;
        bh=nQZYqrwWCpdbUbQ16wM+a+UtsLY3q9D6MPb3TEL2vLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kh2u8wnXNLRhp7GKHulHo4K4xXPptJJpKDJtgoHJwXo6NOol3zqiPRkNYD+VZXlT4
         mDrJWa1oPfpvbzuuhrhmqUOOVO6wpzICesSDK10/ILhZVU7CtiCS1og6UsWbs76zMB
         cTacyAcGxmD+zV/qpIxpEAfAwafgC9QyoCWAxdNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 380/405] regulator: ltc3589: Fix notifier mutex lock warning
Date:   Wed, 29 May 2019 20:06:18 -0700
Message-Id: <20190530030559.955927562@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f132da2534ec6599c78c4adcef15340cff2e9dd9 ]

The mutex for the regulator_dev must be controlled by the caller of
the regulator_notifier_call_chain(), as described in the comment
for that function.

Failure to mutex lock and unlock surrounding the notifier call results
in a kernel WARN_ON_ONCE() which will dump a backtrace for the
regulator_notifier_call_chain() when that function call is first made.
The mutex can be controlled using the regulator_lock/unlock() API.

Fixes: 3eb2c7ecb7ea ("regulator: Add LTC3589 support")
Suggested-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ltc3589.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ltc3589.c b/drivers/regulator/ltc3589.c
index 63f724f260ef7..75089b037b723 100644
--- a/drivers/regulator/ltc3589.c
+++ b/drivers/regulator/ltc3589.c
@@ -419,16 +419,22 @@ static irqreturn_t ltc3589_isr(int irq, void *dev_id)
 
 	if (irqstat & LTC3589_IRQSTAT_THERMAL_WARN) {
 		event = REGULATOR_EVENT_OVER_TEMP;
-		for (i = 0; i < LTC3589_NUM_REGULATORS; i++)
+		for (i = 0; i < LTC3589_NUM_REGULATORS; i++) {
+		        regulator_lock(ltc3589->regulators[i]);
 			regulator_notifier_call_chain(ltc3589->regulators[i],
 						      event, NULL);
+		        regulator_unlock(ltc3589->regulators[i]);
+		}
 	}
 
 	if (irqstat & LTC3589_IRQSTAT_UNDERVOLT_WARN) {
 		event = REGULATOR_EVENT_UNDER_VOLTAGE;
-		for (i = 0; i < LTC3589_NUM_REGULATORS; i++)
+		for (i = 0; i < LTC3589_NUM_REGULATORS; i++) {
+		        regulator_lock(ltc3589->regulators[i]);
 			regulator_notifier_call_chain(ltc3589->regulators[i],
 						      event, NULL);
+		        regulator_unlock(ltc3589->regulators[i]);
+		}
 	}
 
 	/* Clear warning condition */
-- 
2.20.1



