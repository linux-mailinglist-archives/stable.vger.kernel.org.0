Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DD5386B91
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 22:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242607AbhEQUr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 16:47:26 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:52942 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239938AbhEQUr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 16:47:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621284369; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=NiicaBgdBbOIDCQoEoRVW8spc49gj0KTnYAKoXefVXk=; b=Tk6uJlTHUabCUKhMEnd4vwxczWjmCRmokCbgl0yUrNrHebT/C8tgGV+ITs1L/8tS3MA7za/k
 Z2TJv4hXBFULnRQ93u2LcbfKlFXGaXboQu8bDv+CPKONo4V3L5zg4hdxrG4gLRiWuRlXMHC3
 i6bcl3BkF7nQLhIWE70vUeTp7QE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60a2d6101449805ea29f22c9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 17 May 2021 20:46:08
 GMT
Sender: sidgup=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DB77FC43143; Mon, 17 May 2021 20:46:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from sidgup-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sidgup)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 14D7DC43460;
        Mon, 17 May 2021 20:46:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 14D7DC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sidgup@codeaurora.org
From:   Siddharth Gupta <sidgup@codeaurora.org>
To:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org
Cc:     Siddharth Gupta <sidgup@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: [PATCH 2/3] remoteproc: core: Move validate before device add
Date:   Mon, 17 May 2021 13:45:48 -0700
Message-Id: <1621284349-22752-3-git-send-email-sidgup@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621284349-22752-1-git-send-email-sidgup@codeaurora.org>
References: <1621284349-22752-1-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We can validate whether the remoteproc is correctly setup before
calling making the cdev_add and device_add calls. This saves us
the trouble of cleaning up later on.

Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
---
 drivers/remoteproc/remoteproc_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 562355a..45d09bf 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2316,16 +2316,16 @@ int rproc_add(struct rproc *rproc)
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

