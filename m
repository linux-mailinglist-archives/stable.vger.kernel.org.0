Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FA2386BA3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 22:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244437AbhEQUsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 16:48:00 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:60290 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244386AbhEQUr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 16:47:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621284403; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=OCZ7uak29LEl8jJmUhLI4AIqfTsr8cXO52ZSocwTCrQ=; b=nwEVGz3QfqxEYwNsPnfta4lzQ7vGsO4Ya3uNMHRFlhLmmZHDUzSWoVhBkZdhSZh42O+BTv2m
 gUEdQJiHzxa2k2IAPO5K6yTFWF6RLSfunS0wIxNo24/qqdAVt2MO91gLoGXpSVSfQ6k8iA9m
 szKmLTPQvpzUzsUmzMc6ohv+WHE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60a2d61160c53c8c9dec21ef (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 17 May 2021 20:46:09
 GMT
Sender: sidgup=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DF8EBC433D3; Mon, 17 May 2021 20:46:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from sidgup-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sidgup)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AC5E3C433D3;
        Mon, 17 May 2021 20:46:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AC5E3C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sidgup@codeaurora.org
From:   Siddharth Gupta <sidgup@codeaurora.org>
To:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org
Cc:     Siddharth Gupta <sidgup@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: [PATCH 3/3] remoteproc: core: Cleanup device in case of failure
Date:   Mon, 17 May 2021 13:45:49 -0700
Message-Id: <1621284349-22752-4-git-send-email-sidgup@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621284349-22752-1-git-send-email-sidgup@codeaurora.org>
References: <1621284349-22752-1-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a failure occurs in rproc_add() it returns an error, but does
not cleanup after itself. This change adds the failure path in such
cases.

Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
---
 drivers/remoteproc/remoteproc_core.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 45d09bf..6f5fa81 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2326,8 +2326,10 @@ int rproc_add(struct rproc *rproc)
 		return ret;
 
 	ret = device_add(dev);
-	if (ret < 0)
-		return ret;
+	if (ret < 0) {
+		put_device(dev);
+		goto rproc_remove_cdev;
+	}
 
 	dev_info(dev, "%s is available\n", rproc->name);
 
@@ -2338,7 +2340,7 @@ int rproc_add(struct rproc *rproc)
 	if (rproc->auto_boot) {
 		ret = rproc_trigger_auto_boot(rproc);
 		if (ret < 0)
-			return ret;
+			goto rproc_remove_dev;
 	}
 
 	/* expose to rproc_get_by_phandle users */
@@ -2347,6 +2349,13 @@ int rproc_add(struct rproc *rproc)
 	mutex_unlock(&rproc_list_mutex);
 
 	return 0;
+
+rproc_remove_dev:
+	rproc_delete_debug_dir(rproc);
+	device_del(dev);
+rproc_remove_cdev:
+	rproc_char_device_remove(rproc);
+	return ret;
 }
 EXPORT_SYMBOL(rproc_add);
 
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

