Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60971334AE
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgAGU5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:57:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbgAGU5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:57:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9A0A208C4;
        Tue,  7 Jan 2020 20:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430662;
        bh=Au5h0Tbs2NnhpnJuhUryAGEuji9LYS1kPhAyQd/+xDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHdigWnOyvgKUemLzCPfZFY9AKCteaIk+UDgcEN4PR/E8M8eI4BcIhX+5iyQshL6B
         tIp/6LKVSoZ5nz417yxuj1aqgmiC7+E6jGnZJJHa21yI8r7lkDgTrMctPLi+lOlNBI
         IR0lUnt24J1ZalvqEg+shPrdIX+aWLAMetd1C22I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/191] PM / devfreq: Fix devfreq_notifier_call returning errno
Date:   Tue,  7 Jan 2020 21:52:16 +0100
Message-Id: <20200107205333.875490264@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3a1484e7a3ae..e5c2afdc7b7f 100644
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



