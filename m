Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 252352F1E1
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbfE3EQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbfE3DPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:47 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16C0523D83;
        Thu, 30 May 2019 03:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186147;
        bh=TETZA24t7uL7Mp8Hggm+NyLlfjgX4EOyMnQP1rEwnSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TL0P6c61oc5RIpaLc5J002fmsc8Rbfo+dQlip33gV1BjFMM75N1rKKeDWosmPENMg
         EO3aIYWUlRvTkAeFzKTBgih/appKaEg6z5hgftG/0ommd+Rp4xnOPAN4fhSRn61Gth
         4xoIguBlMP9A7JgPOt0Hn6WUgXUYRokLtiOkDsTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 328/346] regulator: lp8755: Fix notifier mutex lock warning
Date:   Wed, 29 May 2019 20:06:41 -0700
Message-Id: <20190530030557.392734958@linuxfoundation.org>
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

[ Upstream commit 89b2758c192c35068b07766a6830433bfbdc1f44 ]

The mutex for the regulator_dev must be controlled by the caller of
the regulator_notifier_call_chain(), as described in the comment
for that function.

Failure to mutex lock and unlock surrounding the notifier call results
in a kernel WARN_ON_ONCE() which will dump a backtrace for the
regulator_notifier_call_chain() when that function call is first made.
The mutex can be controlled using the regulator_lock/unlock() API.

Fixes: b59320cc5a5e ("regulator: lp8755: new driver for LP8755")
Suggested-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/lp8755.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
index 244822bb63cd6..d82d3077f3b82 100644
--- a/drivers/regulator/lp8755.c
+++ b/drivers/regulator/lp8755.c
@@ -372,10 +372,13 @@ static irqreturn_t lp8755_irq_handler(int irq, void *data)
 	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
 		if ((flag0 & (0x4 << icnt))
 		    && (pchip->irqmask & (0x04 << icnt))
-		    && (pchip->rdev[icnt] != NULL))
+		    && (pchip->rdev[icnt] != NULL)) {
+			regulator_lock(pchip->rdev[icnt]);
 			regulator_notifier_call_chain(pchip->rdev[icnt],
 						      LP8755_EVENT_PWR_FAULT,
 						      NULL);
+			regulator_unlock(pchip->rdev[icnt]);
+		}
 
 	/* read flag1 register */
 	ret = lp8755_read(pchip, 0x0E, &flag1);
@@ -389,18 +392,24 @@ static irqreturn_t lp8755_irq_handler(int irq, void *data)
 	/* send OCP event to all regualtor devices */
 	if ((flag1 & 0x01) && (pchip->irqmask & 0x01))
 		for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
-			if (pchip->rdev[icnt] != NULL)
+			if (pchip->rdev[icnt] != NULL) {
+				regulator_lock(pchip->rdev[icnt]);
 				regulator_notifier_call_chain(pchip->rdev[icnt],
 							      LP8755_EVENT_OCP,
 							      NULL);
+				regulator_unlock(pchip->rdev[icnt]);
+			}
 
 	/* send OVP event to all regualtor devices */
 	if ((flag1 & 0x02) && (pchip->irqmask & 0x02))
 		for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
-			if (pchip->rdev[icnt] != NULL)
+			if (pchip->rdev[icnt] != NULL) {
+				regulator_lock(pchip->rdev[icnt]);
 				regulator_notifier_call_chain(pchip->rdev[icnt],
 							      LP8755_EVENT_OVP,
 							      NULL);
+				regulator_unlock(pchip->rdev[icnt]);
+			}
 	return IRQ_HANDLED;
 
 err_i2c:
-- 
2.20.1



