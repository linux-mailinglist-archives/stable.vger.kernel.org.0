Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1852127D81
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfLTOeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:34:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728200AbfLTOen (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:34:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 751E124688;
        Fri, 20 Dec 2019 14:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852483;
        bh=lqaGR2TYC51/762tju8eQFYclxtnGJZuXbyMwTYjnIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2FV82Cl5pW69yAUvQ1R5B0k3J8wF2YTmlSlSc4kBkcWFkJy6I9ZcrXTtjFGTu7xu
         8TesAD73xSoD9el1OHhbpmFwA36s/P0ea8WFxLaTuQBuO6DcPfT8G8FuQGMWG7T0JX
         DdvvWZ7+wDXGNP6mVvPLkNKPsGZazqzPQ5+XHPVU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/34] PM / devfreq: Fix devfreq_notifier_call returning errno
Date:   Fri, 20 Dec 2019 09:34:06 -0500
Message-Id: <20191220143433.9922-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220143433.9922-1-sashal@kernel.org>
References: <20191220143433.9922-1-sashal@kernel.org>
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
index 61fbaa89d7b4f..34e297f28fc2a 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -538,26 +538,28 @@ static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
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

