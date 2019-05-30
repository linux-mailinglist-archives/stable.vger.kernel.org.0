Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6434D2F1DD
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbfE3DPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730481AbfE3DPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:47 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43A2024559;
        Thu, 30 May 2019 03:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186146;
        bh=qFJB82RvWiimfGDlAECHzDLXCltM3UAZiZ/moEzcAxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCWA0poF3QIrl6JSFfDnx3N3G17JSWfn+ManarfsPdkf/mC+Pz5ka6sxNcEA+P6/H
         vYWRShx90sKOJzF57yUObf6wko6sSSIoPM6MDqDywk6YPnwctNh+8jZ1l9ga0FQ2aK
         QKTc23CdXNxCjSby/jjlVNvICUsWX0Xp8ug+w86U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 326/346] regulator: pv88060: Fix notifier mutex lock warning
Date:   Wed, 29 May 2019 20:06:39 -0700
Message-Id: <20190530030557.300172612@linuxfoundation.org>
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
index a9446056435f9..000c34914fe39 100644
--- a/drivers/regulator/pv88060-regulator.c
+++ b/drivers/regulator/pv88060-regulator.c
@@ -276,9 +276,11 @@ static irqreturn_t pv88060_irq_handler(int irq, void *data)
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
 
@@ -293,9 +295,11 @@ static irqreturn_t pv88060_irq_handler(int irq, void *data)
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



