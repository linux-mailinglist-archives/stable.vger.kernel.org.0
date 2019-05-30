Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9819B2F1C7
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfE3DPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730497AbfE3DPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:48 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17CA324595;
        Thu, 30 May 2019 03:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186148;
        bh=QQtSQFa9MxCbMXvIROQN59cBbxs72+r/F/Fi9pUI/No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twBiDTEqCD1xqbOuqCf5vF6SKblaL2LiyBEShqKM4t+yixDaXoXGF/L0uujjRCHCo
         5RZV50Sv85eu5Y1JMKeCHgypRIEHwpWIh1G7D2NUbaOesEu1zpuNZCZSBjkEozwsCL
         xGt2+JckZ2JKZl0Ry5vMNoVRJ2I7kneVkjTzRqZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 330/346] regulator: da9063: Fix notifier mutex lock warning
Date:   Wed, 29 May 2019 20:06:43 -0700
Message-Id: <20190530030557.487183461@linuxfoundation.org>
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

[ Upstream commit 29d40b4a5776ec4727c9f0e00a884423dd5e3366 ]

The mutex for the regulator_dev must be controlled by the caller of
the regulator_notifier_call_chain(), as described in the comment
for that function.

Failure to mutex lock and unlock surrounding the notifier call results
in a kernel WARN_ON_ONCE() which will dump a backtrace for the
regulator_notifier_call_chain() when that function call is first made.
The mutex can be controlled using the regulator_lock/unlock() API.

Fixes: 69ca3e58d178 ("regulator: da9063: Add Dialog DA9063 voltage regulators support.")
Suggested-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/da9063-regulator.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 8cbcd2a3eb205..d3ea73ab59209 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -615,9 +615,12 @@ static irqreturn_t da9063_ldo_lim_event(int irq, void *data)
 		if (regl->info->oc_event.reg != DA9063_REG_STATUS_D)
 			continue;
 
-		if (BIT(regl->info->oc_event.lsb) & bits)
+		if (BIT(regl->info->oc_event.lsb) & bits) {
+		        regulator_lock(regl->rdev);
 			regulator_notifier_call_chain(regl->rdev,
 					REGULATOR_EVENT_OVER_CURRENT, NULL);
+		        regulator_unlock(regl->rdev);
+		}
 	}
 
 	return IRQ_HANDLED;
-- 
2.20.1



