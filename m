Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918D32EBC2
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbfE3DPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730515AbfE3DPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:52 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2FE82449A;
        Thu, 30 May 2019 03:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186151;
        bh=XWqNgIXj0gFjXO0IWTN6NzSbtv1BqPtmHedwpCd+Uig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNkRdPRHHvDUuRaCk1cap5iOZRMs4uM21nDchNSkOdI5T6PW0/jjxmIHo9O3LiU44
         AWyt+fmCZRghVzL+/rRjRuEjWXzYqdRPl+U5DFzh128X3W3wVICftgc2Ldss6//H1O
         VNlL8B+6NJDXvOvNBJyU0kkCho0mGt11NxNWjQ6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 335/346] regulator: da9055: Fix notifier mutex lock warning
Date:   Wed, 29 May 2019 20:06:48 -0700
Message-Id: <20190530030557.717068359@linuxfoundation.org>
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

[ Upstream commit 5e6afb3832bedf420dd8e4c5b32ed85117c5087d ]

The mutex for the regulator_dev must be controlled by the caller of
the regulator_notifier_call_chain(), as described in the comment
for that function.

Failure to mutex lock and unlock surrounding the notifier call results
in a kernel WARN_ON_ONCE() which will dump a backtrace for the
regulator_notifier_call_chain() when that function call is first made.
The mutex can be controlled using the regulator_lock/unlock() API.

Fixes: f6130be652d0 ("regulator: DA9055 regulator driver")
Suggested-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/da9055-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 588c3d2445cf3..acba42d5b57d4 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -515,8 +515,10 @@ static irqreturn_t da9055_ldo5_6_oc_irq(int irq, void *data)
 {
 	struct da9055_regulator *regulator = data;
 
+	regulator_lock(regulator->rdev);
 	regulator_notifier_call_chain(regulator->rdev,
 				      REGULATOR_EVENT_OVER_CURRENT, NULL);
+	regulator_unlock(regulator->rdev);
 
 	return IRQ_HANDLED;
 }
-- 
2.20.1



