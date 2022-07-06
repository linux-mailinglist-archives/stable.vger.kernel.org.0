Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713FB568D2B
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbiGFPbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbiGFPbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:31:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B6324F32;
        Wed,  6 Jul 2022 08:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BE8361FE4;
        Wed,  6 Jul 2022 15:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7764C385A2;
        Wed,  6 Jul 2022 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121470;
        bh=FTub9thA/XFO0HIXNb1G0/Bw07j1NqKpudxVT0lkUAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+umth7GvC6YR5L8Y6axWMXXPEtlfEzeSeDk1IHW93o/K6WmrfKHvkYGYvgueBVU5
         1rZpnUlYloYFn16Y+Y8QufDUzoXhfrANZW7CrZ2MZpjLdSG5W4dZ4dfnF3qCw9gegI
         9C0bGBr+C3IbI4wr0m4OQBANJlFLGnCATw2IKXh2qRNJm/SzCoIg78nbSIKuFXodKv
         NuplPYzTCjJkQHhUbIHHqlbI/KQXUDXipo6XxflzSTsGhjiPCQICJ70Lb4RZk8AJKT
         I6qnWwefTVrnXiCUoWBTB8s+rVqUi0OnCydLB+2vTJOa65fY81sbvZz1AjLmdg08ha
         sjJq5n8sqI99g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 10/22] scsi: hisi_sas: Limit max hw sectors for v3 HW
Date:   Wed,  6 Jul 2022 11:30:28 -0400
Message-Id: <20220706153041.1597639-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153041.1597639-1-sashal@kernel.org>
References: <20220706153041.1597639-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit fce54ed027577517df1e74b7d54dc2b1bd536887 ]

If the controller is behind an IOMMU then the IOMMU IOVA caching range can
affect performance, as discussed in [0].

Limit the max HW sectors to not exceed this limit. We need to hardcode the
value until a proper DMA mapping API is available.

[0] https://lore.kernel.org/linux-iommu/20210129092120.1482-1-thunder.leizhen@huawei.com/

Link: https://lore.kernel.org/r/1655988119-223714-1-git-send-email-john.garry@huawei.com
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 7d819fc0395e..eb86afb21aab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2782,6 +2782,7 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 	struct device *dev = hisi_hba->dev;
 	int ret = sas_slave_configure(sdev);
+	unsigned int max_sectors;
 
 	if (ret)
 		return ret;
@@ -2799,6 +2800,12 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 		}
 	}
 
+	/* Set according to IOMMU IOVA caching limit */
+	max_sectors = min_t(size_t, queue_max_hw_sectors(sdev->request_queue),
+			    (PAGE_SIZE * 32) >> SECTOR_SHIFT);
+
+	blk_queue_max_hw_sectors(sdev->request_queue, max_sectors);
+
 	return 0;
 }
 
-- 
2.35.1

