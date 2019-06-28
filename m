Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E8159A0E
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 14:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfF1MKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 08:10:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50168 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbfF1MKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 08:10:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 310D3606E1; Fri, 28 Jun 2019 12:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561723811;
        bh=IM0ROSdcJWhLOg7FCXzXiT+dphADA/BQMxzLdqyE4gI=;
        h=From:To:Cc:Subject:Date:From;
        b=Ribzsnv2aF/9i/B7bXu+14xOkRG10YQkY/ldJhblqja/UFtmbf8PxWaFppHZ59Muu
         ATWN4CBESNwU/qixtNHpbm0mMNQgeOBrNIQNag/O8jGXvYq5XcXRnimbDN8mcanOI6
         LDveRWrq/0h9TYl82ETex+srUu6BRznEy1+wfUCQ=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from srichara-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sricharan@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AB0066070D;
        Fri, 28 Jun 2019 12:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561723810;
        bh=IM0ROSdcJWhLOg7FCXzXiT+dphADA/BQMxzLdqyE4gI=;
        h=From:To:Cc:Subject:Date:From;
        b=D3YzX8aS3Ume7ylmpcOIg+TFPBPZGvS0u0pfcfUXLozP0OADlZ8tV4oiMaTs3S/HU
         Na4/YK31FQW/aElURBQk5puXU5CP797RLEMb+5kHlf2f+EKnUnkb3+QkVyYazjT9Cn
         0K+e05vjGcXa1ypvY9OUeapTSy/E/0LCds1QPcCY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AB0066070D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=sricharan@codeaurora.org
From:   Sricharan R <sricharan@codeaurora.org>
To:     agross@kernel.org, david.brown@linaro.org,
        dan.j.williams@intel.com, vkoul@kernel.org,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.kandagatla@linaro.org
Cc:     stable@vger.kernel.org, sricharan@codeaurora.org
Subject: [PATCH] dmaengine: qcom: bam_dma: Fix completed descriptors count
Date:   Fri, 28 Jun 2019 17:39:46 +0530
Message-Id: <1561723786-22500-1-git-send-email-sricharan@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

One space is left unused in circular FIFO to differentiate
'full' and 'empty' cases. So take that in to account while
counting for the descriptors completed.

Fixes the issue reported here,
	https://lkml.org/lkml/2019/6/18/669

Cc: stable@vger.kernel.org
Reported-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Sricharan R <sricharan@codeaurora.org>
---
 drivers/dma/qcom/bam_dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 4b43844..8e90a40 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -799,6 +799,9 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 		/* Number of bytes available to read */
 		avail = CIRC_CNT(offset, bchan->head, MAX_DESCRIPTORS + 1);
 
+		if (offset < bchan->head)
+			avail--;
+
 		list_for_each_entry_safe(async_desc, tmp,
 					 &bchan->desc_list, desc_node) {
 			/* Not enough data to read */
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

