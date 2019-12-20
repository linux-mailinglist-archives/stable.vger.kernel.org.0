Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313E2127CCC
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfLTOaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:30:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727605AbfLTOaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BCFE24687;
        Fri, 20 Dec 2019 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852217;
        bh=zdMqTVdWiFklwDj62ab5EaoEDUMdQ2R6DyxmKDe3V5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1zZkGpcp1nhKcbd/DZtI8zrZ7z1dQ+1i7JoUM4pzYxz6I3dM7RmgNpdqJNI/fRtx
         e9fPbXFyPc29SO6DMQXgG2ph54VqqtPpbnwkhiA+SvwxHECvIpWfaB+zvVGlv+1/BG
         6WS0SNmkoE9a1xlosh93ElKFfX6UtDPaIjrm0n3k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/52] PM / devfreq: Fix devfreq_notifier_call returning errno
Date:   Fri, 20 Dec 2019 09:29:18 -0500
Message-Id: <20191220142954.9500-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit e876e710ede23f670494331e062d643928e4142a ]

Notifier callbacks shouldn't return negative errno but one of the
NOTIFY_OK/DONE/BAD values.

The OPP core will ignore return values from notifiers but returning a
value that matches NOTIFY_STOP_MASK will stop the notification chain.

Fix by always returning NOTIFY_OK.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 3a1484e7a3ae9..e5c2afdc7b7f0 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -551,26 +551,28 @@ static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
 				 void *devp)
 {
 	struct devfreq *devfreq = container_of(nb, struct devfreq, nb);
-	int ret;
+	int err = -EINVAL;
 
 	mutex_lock(&devfreq->lock);
 
 	devfreq->scaling_min_freq = find_available_min_freq(devfreq);
-	if (!devfreq->scaling_min_freq) {
-		mutex_unlock(&devfreq->lock);
-		return -EINVAL;
-	}
+	if (!devfreq->scaling_min_freq)
+		goto out;
 
 	devfreq->scaling_max_freq = find_available_max_freq(devfreq);
-	if (!devfreq->scaling_max_freq) {
-		mutex_unlock(&devfreq->lock);
-		return -EINVAL;
-	}
+	if (!devfreq->scaling_max_freq)
+		goto out;
+
+	err = update_devfreq(devfreq);
 
-	ret = update_devfreq(devfreq);
+out:
 	mutex_unlock(&devfreq->lock);
+	if (err)
+		dev_err(devfreq->dev.parent,
+			"failed to update frequency from OPP notifier (%d)\n",
+			err);
 
-	return ret;
+	return NOTIFY_OK;
 }
 
 /**
-- 
2.20.1

