Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D084F2C0322
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 11:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgKWKVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 05:21:49 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:63006 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbgKWKVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 05:21:47 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606126907; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=ANmJoYuuswtZF1g4TGnjWKvS5jfl6v0C3i9XCSjNnmQ=; b=gxw0bKdyAM3rr6fFWbJAwxhSEJSAkJfkybwQVN8DrYmtCY74g2MkqSJf+EGNtFQgWm3pAugi
 3Bxq/FYA0c/uI8BmTCwIwrq9T7Os8iglHhLJLiLRbRfIxAh6CLd/l0RQv8cnW2DPbsfozZSp
 uxP79tq/r64mpzOhZ+KwEBOyZzM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fbb8d380c9500dc7bad62be (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 23 Nov 2020 10:21:44
 GMT
Sender: saiprakash.ranjan=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3A547C43463; Mon, 23 Nov 2020 10:21:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from blr-ubuntu-253.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: saiprakash.ranjan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 20405C433C6;
        Mon, 23 Nov 2020 10:21:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 20405C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=saiprakash.ranjan@codeaurora.org
From:   Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>
Cc:     coresight@lists.linaro.org, Stephen Boyd <swboyd@chromium.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mao Jinlong <jinlmao@codeaurora.org>, stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Subject: [PATCH] coresight: tmc-etr: Check if page is valid before dma_map_page()
Date:   Mon, 23 Nov 2020 15:51:33 +0530
Message-Id: <20201123102133.18979-1-saiprakash.ranjan@codeaurora.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mao Jinlong <jinlmao@codeaurora.org>

alloc_pages_node() return should be checked before calling
dma_map_page() to make sure that valid page is mapped or
else it can lead to aborts as below:

 Unable to handle kernel paging request at virtual address ffffffc008000000
 Mem abort info:
 <snip>...
 pc : __dma_inv_area+0x40/0x58
 lr : dma_direct_map_page+0xd8/0x1c8

 Call trace:
  __dma_inv_area
  tmc_pages_alloc
  tmc_alloc_data_pages
  tmc_alloc_sg_table
  tmc_init_etr_sg_table
  tmc_alloc_etr_buf
  tmc_enable_etr_sink_sysfs
  tmc_enable_etr_sink
  coresight_enable_path
  coresight_enable
  enable_source_store
  dev_attr_store
  sysfs_kf_write

Fixes: 99443ea19e8b ("coresight: Add generic TMC sg table framework")
Cc: stable@vger.kernel.org
Signed-off-by: Mao Jinlong <jinlmao@codeaurora.org>
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index 525f0ecc129c..a31a4d7ae25e 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -217,6 +217,8 @@ static int tmc_pages_alloc(struct tmc_pages *tmc_pages,
 		} else {
 			page = alloc_pages_node(node,
 						GFP_KERNEL | __GFP_ZERO, 0);
+			if (!page)
+				goto err;
 		}
 		paddr = dma_map_page(real_dev, page, 0, PAGE_SIZE, dir);
 		if (dma_mapping_error(real_dev, paddr))

base-commit: c04e5d7bbf6f92a346d6b36770705e7f034df42d
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

