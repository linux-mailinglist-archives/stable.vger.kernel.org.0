Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89ED179946
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 20:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgCDTsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 14:48:10 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:42426 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729936AbgCDTsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 14:48:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583351286; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=fq51DeGJ3Z3tN3afJtV3Ja5oRakP0D/eaYT2hqFUj/k=; b=clD1xlCumUIDvaV4RIgG+4/Kbyq3tYXa1BZKb1kTBLRm7K9eEhwT8pyDlXYMucYms8P2o0nf
 qoWH8H3UETeej39V1OXfCKBUIVZOoL6IYcjd5rmTMCltHQburF+UWJVokzrQtqRo72DzILVq
 HZlmUFDGX17YJCNXcDkgO/T3470=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6005eb.7f08f190b148-smtp-out-n01;
 Wed, 04 Mar 2020 19:47:55 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D36EFC447A2; Wed,  4 Mar 2020 19:47:55 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from blr-ubuntu-87.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sibis)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E622FC4479D;
        Wed,  4 Mar 2020 19:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E622FC4479D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=sibis@codeaurora.org
From:   Sibi Sankar <sibis@codeaurora.org>
To:     bjorn.andersson@linaro.org, mathieu.poirier@linaro.org,
        jeffrey.l.hugo@gmail.com, luca@z3ntu.xyz
Cc:     agross@kernel.org, ohad@wizery.com, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sibi Sankar <sibis@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH v4 3/3] remoteproc: qcom_q6v5_mss: Reload the mba region on coredump
Date:   Thu,  5 Mar 2020 01:17:29 +0530
Message-Id: <20200304194729.27979-4-sibis@codeaurora.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200304194729.27979-1-sibis@codeaurora.org>
References: <20200304194729.27979-1-sibis@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On secure devices after a wdog/fatal interrupt, the mba region has to be
refreshed in order to prevent the following errors during mba load.

Err Logs:
remoteproc remoteproc2: stopped remote processor 4080000.remoteproc
qcom-q6v5-mss 4080000.remoteproc: PBL returned unexpected status -284031232
qcom-q6v5-mss 4080000.remoteproc: PBL returned unexpected status -284031232
....
qcom-q6v5-mss 4080000.remoteproc: PBL returned unexpected status -284031232
qcom-q6v5-mss 4080000.remoteproc: MBA booted, loading mpss

Fixes: 7dd8ade24dc2a ("remoteproc: qcom: q6v5-mss: Add custom dump function for modem")
Cc: stable@vger.kernel.org
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index b8a922181de8a..d7667418a62f4 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1042,6 +1042,23 @@ static void q6v5_mba_reclaim(struct q6v5 *qproc)
 	}
 }
 
+static int q6v5_reload_mba(struct rproc *rproc)
+{
+	struct q6v5 *qproc = rproc->priv;
+	const struct firmware *fw;
+	int ret;
+
+	ret = request_firmware(&fw, rproc->firmware, qproc->dev);
+	if (ret < 0)
+		return ret;
+
+	q6v5_load(rproc, fw);
+	ret = q6v5_mba_load(qproc);
+	release_firmware(fw);
+
+	return ret;
+}
+
 static int q6v5_mpss_load(struct q6v5 *qproc)
 {
 	const struct elf32_phdr *phdrs;
@@ -1221,7 +1238,7 @@ static void qcom_q6v5_dump_segment(struct rproc *rproc,
 
 	/* Unlock mba before copying segments */
 	if (!qproc->dump_mba_loaded) {
-		ret = q6v5_mba_load(qproc);
+		ret = q6v5_reload_mba(rproc);
 		if (!ret) {
 			/* Reset ownership back to Linux to copy segments */
 			ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
