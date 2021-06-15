Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601043A8921
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 21:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhFOTGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 15:06:15 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:27609 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbhFOTGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 15:06:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623783848; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=s4MbUn0A7BsUXdZ1lWtEQK9g1U4XtYOuBoPX4WRDNVI=; b=Wr0R6MtlKBkswT+mfMferJ18/yFrM4xIVwHfUjMG2UdJHmQVyHRdckM9hoBqxwa8Q2YadIsD
 0ftu1XRO8v59LsejyWyclHlDDVXKkqYpeqLLX2mifLAvnvRdfuMICR4UcYT8oIfwtP8t0eOF
 cUQVB0b6vYq8HMjxbtdK/a9sAjM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60c8f99ce570c05619ff2e66 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 19:03:56
 GMT
Sender: sidgup=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 15703C43217; Tue, 15 Jun 2021 19:03:55 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from sidgup-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sidgup)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ECCB1C433F1;
        Tue, 15 Jun 2021 19:03:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ECCB1C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sidgup@codeaurora.org
From:   Siddharth Gupta <sidgup@codeaurora.org>
To:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org
Cc:     Siddharth Gupta <sidgup@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: [PATCH v4 2/4] remoteproc: core: Move validate before device add
Date:   Tue, 15 Jun 2021 12:03:42 -0700
Message-Id: <1623783824-13395-3-git-send-email-sidgup@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623783824-13395-1-git-send-email-sidgup@codeaurora.org>
References: <1623783824-13395-1-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We can validate whether the remoteproc is correctly setup before
making the cdev_add and device_add calls. This saves us the
trouble of cleaning up later on.

Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: stable@vger.kernel.org
---
 drivers/remoteproc/remoteproc_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 9ad8c5f..b65fce3 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2333,16 +2333,16 @@ int rproc_add(struct rproc *rproc)
 	struct device *dev = &rproc->dev;
 	int ret;
 
-	/* add char device for this remoteproc */
-	ret = rproc_char_device_add(rproc);
+	ret = rproc_validate(rproc);
 	if (ret < 0)
 		return ret;
 
-	ret = device_add(dev);
+	/* add char device for this remoteproc */
+	ret = rproc_char_device_add(rproc);
 	if (ret < 0)
 		return ret;
 
-	ret = rproc_validate(rproc);
+	ret = device_add(dev);
 	if (ret < 0)
 		return ret;
 
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

