Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE61B2884E6
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 10:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732458AbgJIIIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 04:08:25 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:57356 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732479AbgJIIIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 04:08:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602230903; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=75E1HKPsei40eEw+eHRkIo0miSo6IqCWxY6d9GK39LU=; b=GSVqwRnfQqjHzJGhmjRYTQxhSNcTBza5E5CIM5fCa39ZdjUvi5Eq01XKGNf0JmZ23OK3/KWI
 5uTAcbLiXcfPed4aXG/SO2AC5oqtpFctGbNjINItc8GnVQsVfsKWajEKXoWVcjwTH6Ce2uEq
 NJil5TVx7uSPtudCulRIQlJfNhA=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f801a6daad2c3cd1c5149e3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 09 Oct 2020 08:08:13
 GMT
Sender: ipkumar=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 95EBEC43382; Fri,  9 Oct 2020 08:08:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from ipkumar-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: ipkumar)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8FF1BC43382;
        Fri,  9 Oct 2020 08:08:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8FF1BC43382
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=ipkumar@codeaurora.org
From:   Praveenkumar I <ipkumar@codeaurora.org>
To:     miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sivaprak@codeaurora.org, peter.ujfalusi@ti.com,
        boris.brezillon@collabora.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, kathirav@codeaurora.org,
        Praveenkumar I <ipkumar@codeaurora.org>
Subject: [PATCH] mtd: rawnand: qcom: Fix DMA sync on FLASH_STATUS register read
Date:   Fri,  9 Oct 2020 13:37:52 +0530
Message-Id: <1602230872-25616-1-git-send-email-ipkumar@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After each codeword NAND_FLASH_STATUS is read for possible operational
failures. But there is no DMA sync for CPU operation before reading it
and this leads to incorrect or older copy of DMA buffer in reg_read_buf.

This patch adds the DMA sync on reg_read_buf for CPU before reading it.

Fixes: 5bc36b2bf6e2 ("mtd: rawnand: qcom: check for operation errors in case of raw read")
Signed-off-by: Praveenkumar I <ipkumar@codeaurora.org>
---
 drivers/mtd/nand/raw/qcom_nandc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index bd7a7251429b..5bb85f1ba84c 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -1570,6 +1570,8 @@ static int check_flash_errors(struct qcom_nand_host *host, int cw_cnt)
 	struct qcom_nand_controller *nandc = get_qcom_nand_controller(chip);
 	int i;
 
+	nandc_read_buffer_sync(nandc, true);
+
 	for (i = 0; i < cw_cnt; i++) {
 		u32 flash = le32_to_cpu(nandc->reg_read_buf[i]);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

