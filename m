Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5282426C8ED
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 21:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgIPTAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 15:00:15 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:62532 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbgIPS76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 14:59:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600282797; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=SSqTKliitikyhS2Hm4khYk3MaXTZpP0INBcLPuNG4D4=; b=HT0CY1vZMJxh7/SXdk5NhQ6Kdyp4hBZwTJ8MS4EOEwYJzOfyUwf0IIBZqzYiQRHs7RiNWoiM
 y/wwb5i6/xT8A3rvsIVoZD+0jLHGfTOKvfvU5/TOh2cMU2tNNgncTLoEUUXFkwlBgefX4mtg
 g821qp4Fn2fDuKtFIABwC2axUvk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f62266d9a5950f997bf30f5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Sep 2020 14:51:25
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EB37DC433F1; Wed, 16 Sep 2020 14:51:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from blr-ubuntu-253.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sibis)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5492BC433CA;
        Wed, 16 Sep 2020 14:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5492BC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sibis@codeaurora.org
From:   Sibi Sankar <sibis@codeaurora.org>
To:     bjorn.andersson@linaro.org, mathieu.poirier@linaro.org
Cc:     agross@kernel.org, linux-arm-msm@vger.zkernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ohad@wizery.com, rishabhb@codeaurora.org,
        Sibi Sankar <sibis@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH v2] remoteproc: Fixup coredump debugfs disable request
Date:   Wed, 16 Sep 2020 20:21:00 +0530
Message-Id: <20200916145100.15872-1-sibis@codeaurora.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the discrepancy observed between accepted input and read back value
while disabling remoteproc coredump through the coredump debugfs entry.

Fixes: 3afdc59e4390 ("remoteproc: Add coredump debugfs entry")
Cc: stable@vger.kernel.org
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
---

V2:
 * Fixup commit message [Bjorn].

 drivers/remoteproc/remoteproc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_debugfs.c b/drivers/remoteproc/remoteproc_debugfs.c
index 2e3b3e22e1d0..7ca823f6aa63 100644
--- a/drivers/remoteproc/remoteproc_debugfs.c
+++ b/drivers/remoteproc/remoteproc_debugfs.c
@@ -94,7 +94,7 @@ static ssize_t rproc_coredump_write(struct file *filp,
 		goto out;
 	}
 
-	if (!strncmp(buf, "disable", count)) {
+	if (!strncmp(buf, "disabled", count)) {
 		rproc->dump_conf = RPROC_COREDUMP_DISABLED;
 	} else if (!strncmp(buf, "inline", count)) {
 		rproc->dump_conf = RPROC_COREDUMP_INLINE;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

