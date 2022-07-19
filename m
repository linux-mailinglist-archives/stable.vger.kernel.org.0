Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B531579CE5
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242092AbiGSMpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238568AbiGSMnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:43:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FBF54C9E;
        Tue, 19 Jul 2022 05:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4188861772;
        Tue, 19 Jul 2022 12:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330E8C341C6;
        Tue, 19 Jul 2022 12:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233016;
        bh=ftRCXwc4371VseYpxVHNBx88Hlwn+pfvaap8UhlLLAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCXD63i1slASWQYDX5IaGbB/Di3eFqKxpqU5r4Tvv0jnypgxWH1k6pKl+REJr3xTY
         ifySHH6KzLzrTVfoT5s8YwRa6o+t2mD6AS5L9qVrViSx0MK3RKBMscOYKiGdFkCRVN
         hYu/BgjN63sFhmaMOly9Zlw5iZJTFYvoejTqpIN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/167] scsi: hisi_sas: Limit max hw sectors for v3 HW
Date:   Tue, 19 Jul 2022 13:54:12 +0200
Message-Id: <20220719114708.176498383@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 1f5e0688c0c8..15c7451fb30f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2758,6 +2758,7 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 	struct device *dev = hisi_hba->dev;
 	int ret = sas_slave_configure(sdev);
+	unsigned int max_sectors;
 
 	if (ret)
 		return ret;
@@ -2775,6 +2776,12 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
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



