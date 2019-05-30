Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5D2F472
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbfE3Eia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729192AbfE3DMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:44 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 026F023D14;
        Thu, 30 May 2019 03:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185964;
        bh=3J/n2st4d0hAJO8pcuzz+mcSFPyLHPTw3OKbxpL8evk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRgSIvFiSMvFp/+1SHR9nQlfU/riaPioyhNG6Gz54FiXpOPaPo26PpR4gD8nqymKJ
         1IFzACQvr+i5J/fqgO5Hb/45Y/HCA/hMSrXX4KyXxCW0lM0LJqO7EEGH8RIoQicwZ5
         7WD1uNJFjAsWKEyT1FCzsFeWerslrWwbAkJ21U1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 381/405] regulator: pv88060: Fix notifier mutex lock warning
Date:   Wed, 29 May 2019 20:06:19 -0700
Message-Id: <20190530030600.002461339@linuxfoundation.org>
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

[ Upstream commit f58213637206e190453e3bd91f98f535566290a3 ]

The mutex for the regulator_dev must be controlled by the caller of
the regulator_notifier_call_chain(), as described in the comment
for that function.

Failure to mutex lock and unlock surrounding the notifier call results
in a kernel WARN_ON_ONCE() which will dump a backtrace for the
regulator_notifier_call_chain() when that function call is first made.
The mutex can be controlled using the regulator_lock/unlock() API.

Fixes: f307a7e9b7af ("regulator: pv88060: new regulator driver")
Suggested-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pv88060-regulator.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/pv88060-regulator.c b/drivers/regulator/pv88060-regulator.c
index 1600f98218912..810816e9df5d5 100644
--- a/drivers/regulator/pv88060-regulator.c
+++ b/drivers/regulator/pv88060-regulator.c
@@ -244,9 +244,11 @@ static irqreturn_t pv88060_irq_handler(int irq, void *data)
 	if (reg_val & PV88060_E_VDD_FLT) {
 		for (i = 0; i < PV88060_MAX_REGULATORS; i++) {
 			if (chip->rdev[i] != NULL) {
+				regulator_lock(chip->rdev[i]);
 				regulator_notifier_call_chain(chip->rdev[i],
 					REGULATOR_EVENT_UNDER_VOLTAGE,
 					NULL);
+				regulator_unlock(chip->rdev[i]);
 			}
 		}
 
@@ -261,9 +263,11 @@ static irqreturn_t pv88060_irq_handler(int irq, void *data)
 	if (reg_val & PV88060_E_OVER_TEMP) {
 		for (i = 0; i < PV88060_MAX_REGULATORS; i++) {
 			if (chip->rdev[i] != NULL) {
+				regulator_lock(chip->rdev[i]);
 				regulator_notifier_call_chain(chip->rdev[i],
 					REGULATOR_EVENT_OVER_TEMP,
 					NULL);
+				regulator_unlock(chip->rdev[i]);
 			}
 		}
 
-- 
2.20.1



