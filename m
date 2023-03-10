Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9BC6B40EB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjCJNrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjCJNrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:47:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9F528E7D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:47:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C641617B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1C9C433D2;
        Fri, 10 Mar 2023 13:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456053;
        bh=AHH8+V25j04dYhHbB6RZNyhY6wrLnlvtMgRictoQFyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFAM0tLHvKbVAxlc+/g81xKN4EoXdmPyfnBO8CuOCTng4gYHulu7L4NAqk+qzk7Zt
         /K1K8OLZ2yoPnOYO5YwEZFrjCI2BDKZy62SmdPU2hoay+UM+eCwyu7SI6mMZwtPmEz
         C+GKOeOGuhneQh8kYcSbIHx4+Bzt9hOpbYnvW00k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Jason Yan <yanaijie@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 063/193] scsi: aic94xx: Add missing check for dma_map_single()
Date:   Fri, 10 Mar 2023 14:37:25 +0100
Message-Id: <20230310133713.130983965@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 32fe45274edb5926abc0fac7263d9f889d02d9cf ]

Add check for dma_map_single() and return error if it fails in order to
avoid invalid DMA address.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Link: https://lore.kernel.org/r/20230128110832.6792-1-jiasheng@iscas.ac.cn
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic94xx/aic94xx_task.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index cdd4ab683be98..4de4bbca1f925 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -68,6 +68,9 @@ static int asd_map_scatterlist(struct sas_task *task,
 		dma_addr_t dma = pci_map_single(asd_ha->pcidev, p,
 						task->total_xfer_len,
 						task->data_dir);
+		if (dma_mapping_error(&asd_ha->pcidev->dev, dma))
+			return -ENOMEM;
+
 		sg_arr[0].bus_addr = cpu_to_le64((u64)dma);
 		sg_arr[0].size = cpu_to_le32(task->total_xfer_len);
 		sg_arr[0].flags |= ASD_SG_EL_LIST_EOL;
-- 
2.39.2



