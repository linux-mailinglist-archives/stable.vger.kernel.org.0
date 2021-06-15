Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D4D3A892A
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 21:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhFOTGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 15:06:40 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:22820 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbhFOTGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 15:06:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623783873; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=eKY402JPghQTP8i/7xNa0odQHantb7kPAjB6HNOLT7s=; b=ZzYZnDvqOkO2p13FbzCU3LaHp5cAeVXsWoyZol/nbfa1HFZ9Yn3yaD/T6HkKT/tDoykYYAJj
 3FDrdLHSNwJup+v1yMbttH94bbvSBV4YVekVR/r+6nMeT1o9ytPCS26KxZRiuCpvE5VvAHVY
 gVE0AbYMShgejw1hLUbwbLCi+UQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60c8f9a2f726fa418839d884 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 19:04:02
 GMT
Sender: sidgup=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8DBE9C433D3; Tue, 15 Jun 2021 19:04:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from sidgup-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sidgup)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 903F6C4323A;
        Tue, 15 Jun 2021 19:03:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 903F6C4323A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sidgup@codeaurora.org
From:   Siddharth Gupta <sidgup@codeaurora.org>
To:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org
Cc:     Siddharth Gupta <sidgup@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: [PATCH v4 3/4] remoteproc: core: Fix cdev remove and rproc del
Date:   Tue, 15 Jun 2021 12:03:43 -0700
Message-Id: <1623783824-13395-4-git-send-email-sidgup@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623783824-13395-1-git-send-email-sidgup@codeaurora.org>
References: <1623783824-13395-1-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The rproc_char_device_remove() call currently unmaps the cdev
region instead of simply deleting the cdev that was added as a
part of the rproc_char_device_add() call. This change fixes that
behaviour, and also fixes the order in which device_del() and
cdev_del() need to be called.

Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
Cc: stable@vger.kernel.org
---
 drivers/remoteproc/remoteproc_cdev.c | 2 +-
 drivers/remoteproc/remoteproc_core.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_cdev.c b/drivers/remoteproc/remoteproc_cdev.c
index 0b8a84c..4ad98b0 100644
--- a/drivers/remoteproc/remoteproc_cdev.c
+++ b/drivers/remoteproc/remoteproc_cdev.c
@@ -124,7 +124,7 @@ int rproc_char_device_add(struct rproc *rproc)
 
 void rproc_char_device_remove(struct rproc *rproc)
 {
-	__unregister_chrdev(MAJOR(rproc->dev.devt), rproc->index, 1, "remoteproc");
+	cdev_del(&rproc->cdev);
 }
 
 void __init rproc_init_cdev(void)
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index b65fce3..b874280 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2619,7 +2619,6 @@ int rproc_del(struct rproc *rproc)
 	mutex_unlock(&rproc->lock);
 
 	rproc_delete_debug_dir(rproc);
-	rproc_char_device_remove(rproc);
 
 	/* the rproc is downref'ed as soon as it's removed from the klist */
 	mutex_lock(&rproc_list_mutex);
@@ -2630,6 +2629,7 @@ int rproc_del(struct rproc *rproc)
 	synchronize_rcu();
 
 	device_del(&rproc->dev);
+	rproc_char_device_remove(rproc);
 
 	return 0;
 }
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

