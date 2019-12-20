Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E938127DD6
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfLTOgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:36:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbfLTOeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:34:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C53582468A;
        Fri, 20 Dec 2019 14:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852485;
        bh=gnJZRlgJ/CeVAJBsrZW+w07CQEeA1dGWRqEb9Mh6Uuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJG4we+09fASlW5b05g9fnQIBQkLn4A/6Njvrw3hWfOTGBWFM74MuRfULiH0zTWNg
         S14cyW9R8V0WEnh2/YxBsCRPUTyMzSLad7OewN4Tt/tY25d0JFPqGk3uwcgM1vW9hY
         NvTlytzM+mkQE6lLsvibKgRN4QnUM0/tTcG5ceaA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/34] PM / devfreq: Don't fail devfreq_dev_release if not in list
Date:   Fri, 20 Dec 2019 09:34:08 -0500
Message-Id: <20191220143433.9922-9-sashal@kernel.org>
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

[ Upstream commit 42a6b25e67df6ee6675e8d1eaf18065bd73328ba ]

Right now devfreq_dev_release will print a warning and abort the rest of
the cleanup if the devfreq instance is not part of the global
devfreq_list. But this is a valid scenario, for example it can happen if
the governor can't be found or on any other init error that happens
after device_register.

Initialize devfreq->node to an empty list head in devfreq_add_device so
that list_del becomes a safe noop inside devfreq_dev_release and we can
continue the rest of the cleanup.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index a47e76a62287f..69bbb1e9ab23d 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -575,11 +575,6 @@ static void devfreq_dev_release(struct device *dev)
 	struct devfreq *devfreq = to_devfreq(dev);
 
 	mutex_lock(&devfreq_list_lock);
-	if (IS_ERR(find_device_devfreq(devfreq->dev.parent))) {
-		mutex_unlock(&devfreq_list_lock);
-		dev_warn(&devfreq->dev, "releasing devfreq which doesn't exist\n");
-		return;
-	}
 	list_del(&devfreq->node);
 	mutex_unlock(&devfreq_list_lock);
 
@@ -634,6 +629,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	devfreq->dev.parent = dev;
 	devfreq->dev.class = devfreq_class;
 	devfreq->dev.release = devfreq_dev_release;
+	INIT_LIST_HEAD(&devfreq->node);
 	devfreq->profile = profile;
 	strncpy(devfreq->governor_name, governor_name, DEVFREQ_NAME_LEN);
 	devfreq->previous_freq = profile->initial_freq;
-- 
2.20.1

