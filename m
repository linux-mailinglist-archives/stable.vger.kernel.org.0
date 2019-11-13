Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71BA9FA094
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfKMBvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:51:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbfKMBvG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B1DF222D3;
        Wed, 13 Nov 2019 01:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609866;
        bh=S3t5Cafj8u2c9Tf3AxCsWdFvcbncy3FrspDvoheR4uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/Pz5lqE88rQpI6s1juo+V04B/88N2Gpwg5qkexxMoTJV/SmST+U/HJ9YvyTAOFKz
         dt+lERh5rsjZ5qpzQ/BxqQnhvh2EtKH2n8i3ozsgq/16ujticRto9YulZ3DSAypm43
         B6GIfVSUVwWPKjADKtd2PpherTNAubblV2ft9TYo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Donnefort <vincent.donnefort@arm.com>,
        John Einar Reitan <john.reitan@arm.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 031/209] PM / devfreq: stopping the governor before device_unregister()
Date:   Tue, 12 Nov 2019 20:47:27 -0500
Message-Id: <20191113015025.9685-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit 2f061fd0c2d852e32e03a903fccd810663c5c31e ]

device_release() is freeing the resources before calling the device
specific release callback which is, in the case of devfreq, stopping
the governor.

It is a problem as some governors are using the device resources. e.g.
simpleondemand which is using the devfreq deferrable monitoring work. If it
is not stopped before the resources are freed, it might lead to a use after
free.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Reviewed-by: John Einar Reitan <john.reitan@arm.com>
[cw00.choi: Fix merge conflict]
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 8e21bedc74c38..bcd2279106760 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -578,10 +578,6 @@ static void devfreq_dev_release(struct device *dev)
 	list_del(&devfreq->node);
 	mutex_unlock(&devfreq_list_lock);
 
-	if (devfreq->governor)
-		devfreq->governor->event_handler(devfreq,
-						 DEVFREQ_GOV_STOP, NULL);
-
 	if (devfreq->profile->exit)
 		devfreq->profile->exit(devfreq->dev.parent);
 
@@ -717,7 +713,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 err_init:
 	mutex_unlock(&devfreq_list_lock);
 
-	device_unregister(&devfreq->dev);
+	devfreq_remove_device(devfreq);
 	devfreq = NULL;
 err_dev:
 	if (devfreq)
@@ -738,6 +734,9 @@ int devfreq_remove_device(struct devfreq *devfreq)
 	if (!devfreq)
 		return -EINVAL;
 
+	if (devfreq->governor)
+		devfreq->governor->event_handler(devfreq,
+						 DEVFREQ_GOV_STOP, NULL);
 	device_unregister(&devfreq->dev);
 
 	return 0;
-- 
2.20.1

