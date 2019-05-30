Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A612F1DB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbfE3DPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730486AbfE3DPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:48 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CBEA24580;
        Thu, 30 May 2019 03:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186147;
        bh=JgN37LjgXSRNCtPU8BWPOAtUz0V1fcZPJhyRBE7O2SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhvCFePpJU5oTFqoUMEHrPgyPm+pMODU34gjNZsmxgxrvaZfzA1hNZm0HVt5NYAYC
         DBcSNiXMTaUBV2R1lYNrQi7jIrykCr3PUecScuqLjBn1uCmp45nqLQPTlZBdTSsbp+
         Ze9DPC/X506iSlHi4UwsrNy3cl/2oo4/4PbS4uKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 329/346] regulator: da9211: Fix notifier mutex lock warning
Date:   Wed, 29 May 2019 20:06:42 -0700
Message-Id: <20190530030557.441567212@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 65378de3359d30ebce44762d8b8027f372b5b1c4 ]

The mutex for the regulator_dev must be controlled by the caller of
the regulator_notifier_call_chain(), as described in the comment
for that function.

Failure to mutex lock and unlock surrounding the notifier call results
in a kernel WARN_ON_ONCE() which will dump a backtrace for the
regulator_notifier_call_chain() when that function call is first made.
The mutex can be controlled using the regulator_lock/unlock() API.

Fixes: 1028a37daa14 ("regulator: da9211: new regulator driver")
Suggested-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/da9211-regulator.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index 109ee12d43626..4d7fe4819c1ce 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -322,8 +322,10 @@ static irqreturn_t da9211_irq_handler(int irq, void *data)
 		goto error_i2c;
 
 	if (reg_val & DA9211_E_OV_CURR_A) {
+	        regulator_lock(chip->rdev[0]);
 		regulator_notifier_call_chain(chip->rdev[0],
 			REGULATOR_EVENT_OVER_CURRENT, NULL);
+	        regulator_unlock(chip->rdev[0]);
 
 		err = regmap_write(chip->regmap, DA9211_REG_EVENT_B,
 			DA9211_E_OV_CURR_A);
@@ -334,8 +336,10 @@ static irqreturn_t da9211_irq_handler(int irq, void *data)
 	}
 
 	if (reg_val & DA9211_E_OV_CURR_B) {
+	        regulator_lock(chip->rdev[1]);
 		regulator_notifier_call_chain(chip->rdev[1],
 			REGULATOR_EVENT_OVER_CURRENT, NULL);
+	        regulator_unlock(chip->rdev[1]);
 
 		err = regmap_write(chip->regmap, DA9211_REG_EVENT_B,
 			DA9211_E_OV_CURR_B);
-- 
2.20.1



