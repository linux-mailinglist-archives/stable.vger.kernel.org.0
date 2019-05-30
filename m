Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72BAE2F48C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbfE3EjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729142AbfE3DMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:39 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85F08244B0;
        Thu, 30 May 2019 03:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185959;
        bh=veMxMigceTlUS8pLalrLar0Xh3MhnseaAOb7bVHQTNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0eOFodjQSLUphLSyU9Z9+/+Huam3ndez+uV+T23L53be9h1pf93kQcfUmVlUh6aH
         oQrmj/s3Wahl7t1YUidqOhk7srRJXHUe97sWAD0Aw4Gg01bKtaFHd/WDCu0Oof6hLx
         yPjFUbEmNkuDCZVMG/HNwqi3Ph3Sj2klG6RyWiPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 378/405] regulator: wm831x isink: Fix notifier mutex lock warning
Date:   Wed, 29 May 2019 20:06:16 -0700
Message-Id: <20190530030559.860216375@linuxfoundation.org>
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

[ Upstream commit f7a621728a6a23bfd2c6ac4d3e42e1303aefde0f ]

The mutex for the regulator_dev must be controlled by the caller of
the regulator_notifier_call_chain(), as described in the comment
for that function.

Failure to mutex lock and unlock surrounding the notifier call results
in a kernel WARN_ON_ONCE() which will dump a backtrace for the
regulator_notifier_call_chain() when that function call is first made.
The mutex can be controlled using the regulator_lock/unlock() API.

Fixes: d4d6b722e780 ("regulator: Add WM831x ISINK support")
Suggested-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/wm831x-isink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 6dd891d7eee3b..11f351191dba9 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -140,9 +140,11 @@ static irqreturn_t wm831x_isink_irq(int irq, void *data)
 {
 	struct wm831x_isink *isink = data;
 
+	regulator_lock(isink->regulator);
 	regulator_notifier_call_chain(isink->regulator,
 				      REGULATOR_EVENT_OVER_CURRENT,
 				      NULL);
+	regulator_unlock(isink->regulator);
 
 	return IRQ_HANDLED;
 }
-- 
2.20.1



