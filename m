Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75912F1D5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbfE3EQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbfE3DPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:50 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F264524580;
        Thu, 30 May 2019 03:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186150;
        bh=d4nY/VhsQDHC+8KC5BHkFPOCTt/TPbxIy52XXQEdmIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLFOLPeU4hLUlZmFon8jubV69Gnc4BebUybhhHozC405p9HU577idGAhPYLxImtcV
         7sMvoRg3B5bHklFemyj4RKE0kkxn2D/OsEljm1kbYL1TBQymU7TdkucsTrPD2HSgWs
         urjxQhgpsD8FBbloiSK1KexdBp0Uf0Vj0+Qyy9Jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 332/346] regulator: wm831x: Fix notifier mutex lock warning
Date:   Wed, 29 May 2019 20:06:45 -0700
Message-Id: <20190530030557.576059664@linuxfoundation.org>
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

[ Upstream commit 119c4f5085c45b60cb23c5595e45d06135b89518 ]

The mutex for the regulator_dev must be controlled by the caller of
the regulator_notifier_call_chain(), as described in the comment
for that function.

Failure to mutex lock and unlock surrounding the notifier call results
in a kernel WARN_ON_ONCE() which will dump a backtrace for the
regulator_notifier_call_chain() when that function call is first made.
The mutex can be controlled using the regulator_lock/unlock() API.

Fixes: e4ee831f949a ("regulator: Add WM831x DC-DC buck convertor support")
Suggested-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/wm831x-dcdc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 5a5bc4bb08d26..4f5461ad7b629 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -183,9 +183,11 @@ static irqreturn_t wm831x_dcdc_uv_irq(int irq, void *data)
 {
 	struct wm831x_dcdc *dcdc = data;
 
+	regulator_lock(dcdc->regulator);
 	regulator_notifier_call_chain(dcdc->regulator,
 				      REGULATOR_EVENT_UNDER_VOLTAGE,
 				      NULL);
+	regulator_unlock(dcdc->regulator);
 
 	return IRQ_HANDLED;
 }
@@ -194,9 +196,11 @@ static irqreturn_t wm831x_dcdc_oc_irq(int irq, void *data)
 {
 	struct wm831x_dcdc *dcdc = data;
 
+	regulator_lock(dcdc->regulator);
 	regulator_notifier_call_chain(dcdc->regulator,
 				      REGULATOR_EVENT_OVER_CURRENT,
 				      NULL);
+	regulator_unlock(dcdc->regulator);
 
 	return IRQ_HANDLED;
 }
-- 
2.20.1



