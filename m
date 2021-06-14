Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0133A709D
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 22:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbhFNUnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 16:43:09 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:23223 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbhFNUnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 16:43:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623703262; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=R7TbuX6Gr1kzjFExPi9WDbyMQjBoR0r8zwO/Sfgfzj0=; b=VwUY1beohJPea5dEDlPZ3MHox8H1wXTK96PaE8ZS2PYzcp/0K+arwpXi1UviAdNqYQ/NLZwE
 B9eNgcIZ0JMmRiILQoIKbjuxnndIQZVUnejI0+ZMAisa+vr0P7qUvJRMc/ex9JbzaGjvQI8D
 fP0OEKmuhHsZvSc9AsZvC6KYEGU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60c7bedaabfd22a3dc97ca36 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 14 Jun 2021 20:40:58
 GMT
Sender: sidgup=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4F71DC43143; Mon, 14 Jun 2021 20:40:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from sidgup-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sidgup)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 68206C433F1;
        Mon, 14 Jun 2021 20:40:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 68206C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sidgup@codeaurora.org
From:   Siddharth Gupta <sidgup@codeaurora.org>
To:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org
Cc:     Siddharth Gupta <sidgup@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: [PATCH v2 3/4] remoteproc: core: Fix cdev remove and rproc del
Date:   Mon, 14 Jun 2021 13:40:43 -0700
Message-Id: <1623703244-26814-4-git-send-email-sidgup@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623703244-26814-1-git-send-email-sidgup@codeaurora.org>
References: <1623703244-26814-1-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The rproc_char_device_remove() call currently unmaps the cdev
region instead of simply deleting the cdev that was added as a
part of the rproc_char_device_add() call. This change fixes that
behaviour, and also fixes the order in which device_del() and
cdev_del() need to be called.

Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
---
 0000-cover-letter.patch.backup       | 26 ++++++++++++++++++++++++++
 drivers/remoteproc/remoteproc_cdev.c |  2 +-
 drivers/remoteproc/remoteproc_core.c |  2 +-
 3 files changed, 28 insertions(+), 2 deletions(-)
 create mode 100644 0000-cover-letter.patch.backup

diff --git a/0000-cover-letter.patch.backup b/0000-cover-letter.patch.backup
new file mode 100644
index 0000000..837bcdb
--- /dev/null
+++ b/0000-cover-letter.patch.backup
@@ -0,0 +1,26 @@
+From 78fcb27d574d2f7b06e37b77b257f98858a88d9d Mon Sep 17 00:00:00 2001
+From: Siddharth Gupta <sidgup@codeaurora.org>
+Date: Mon, 17 May 2021 13:33:25 -0700
+Subject: [PATCH 0/3] remoteproc: core: Fixes for rproc cdev and add
+To: bjorn.andersson@linaro.org,ohad@wizery.com,linux-remoteproc@vger.kernel.org
+Cc: linux-kernel@vger.kernel.org,linux-arm-msm@vger.kernel.org,linux-arm-kernel@lists.infradead.org,psodagud@codeaurora.org,stable@vger.kernel.org
+
+This patch series contains stability fixes and error handling for remoteproc.
+
+The changes included in this series do the following:
+Patch 1: Fixes the creation of the rproc character device.
+Patch 2: Validates rproc as the first step of rproc_add().
+Patch 3: Adds error handling in rproc_add().
+
+Siddharth Gupta (3):
+  remoteproc: core: Move cdev add before device add
+  remoteproc: core: Move validate before device add
+  remoteproc: core: Cleanup device in case of failure
+
+ drivers/remoteproc/remoteproc_core.c | 25 +++++++++++++++++--------
+ 1 file changed, 17 insertions(+), 8 deletions(-)
+
+-- 
+Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
+a Linux Foundation Collaborative Project
+
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

