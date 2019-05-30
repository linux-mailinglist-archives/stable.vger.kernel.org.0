Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE5F2F488
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfE3EjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:39:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbfE3DMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:53 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D00CA2449A;
        Thu, 30 May 2019 03:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185972;
        bh=bYeRNb566ivJGa6XUw7lhUgJLMTq33R8psS/bZAxKNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAOL0aF/Rz3oeC646nG4xJ8rgzj0oMEGO4YOOQoAnBd4+IkzQAqQChXuNI0Dnb182
         rCjk9Cj5xhHb3mdY++totuDyLNPcSF5YpeDpMVv0roX/NysWLo6ILAbRHbeisjAaax
         87sC4WE1GbA/SibTeDyOPRBHFbeWAUy/WF/ooOu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 383/405] regulator: lp8755: Fix notifier mutex lock warning
Date:   Wed, 29 May 2019 20:06:21 -0700
Message-Id: <20190530030600.104456668@linuxfoundation.org>
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
index 14fd388071349..2e16a6ab491d6 100644
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
 	/* send OCP event to all regulator devices */
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
 
 	/* send OVP event to all regulator devices */
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



