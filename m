Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB896B4577
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjCJOeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbjCJOdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D50459E7A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:33:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF733B822AD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DACC4339B;
        Fri, 10 Mar 2023 14:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458813;
        bh=bdU/Wa50LSVZUhcPBQnK7Qb+VtAytfM3tdUtw7hb2GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbPhQ+/STiBiabhbMj6n/UYCz3J4XLeN3SOMx+i9R6S+tJUKiDf8XAH6zTsGc7G4X
         dneP0FEjI9qHJmrwmY2mKO65tDKp+0Qibxrsn15GVj5bi1ydpA6z6kqacCC+YcfDH1
         esuI92clg807AC6j8M3A/Mw5rsPQHChaCj+0R+lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Jason Yan <yanaijie@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/357] scsi: aic94xx: Add missing check for dma_map_single()
Date:   Fri, 10 Mar 2023 14:36:52 +0100
Message-Id: <20230310133740.084351769@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index f923ed019d4a1..593b167ceefee 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -50,6 +50,9 @@ static int asd_map_scatterlist(struct sas_task *task,
 		dma_addr_t dma = dma_map_single(&asd_ha->pcidev->dev, p,
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



