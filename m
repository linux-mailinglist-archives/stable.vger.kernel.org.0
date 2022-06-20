Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E7B551D2A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348592AbiFTNrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348621AbiFTNrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:47:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72BD2E6A4;
        Mon, 20 Jun 2022 06:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ED96B811A0;
        Mon, 20 Jun 2022 13:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5ADC3411B;
        Mon, 20 Jun 2022 13:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730360;
        bh=EwoD3EBUTWMcZKTaDFWmwe7rbaU+vmxyU8ePWDHD1CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDEamVydPj91O2oOhYgy9KJ90PrqdSZniv6LtLb8+7w9PhYkkzTdQcwAExfSyJlDO
         WdMVQ405tsI/kH4gFsA9178NU4U2q3FS5rSO1fNw7c2flLZdUMQaMS7tROq/0yk+qe
         Ehw4XKX7MjyVd0TfECq45pn3zyftgcPvjBwsIqCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Chengguang Xu <cgxu519@mykernel.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/106] scsi: ipr: Fix missing/incorrect resource cleanup in error case
Date:   Mon, 20 Jun 2022 14:50:47 +0200
Message-Id: <20220620124725.219036940@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

[ Upstream commit d64c491911322af1dcada98e5b9ee0d87e8c8fee ]

Fix missing resource cleanup (when '(--i) == 0') for error case in
ipr_alloc_mem() and skip incorrect resource cleanup (when '(--i) == 0') for
error case in ipr_request_other_msi_irqs() because variable i started from
1.

Link: https://lore.kernel.org/r/20220529153456.4183738-4-cgxu519@mykernel.net
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ipr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5d78f7e939a3..56b8a2d6ffe4 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9791,7 +9791,7 @@ static int ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 					GFP_KERNEL);
 
 		if (!ioa_cfg->hrrq[i].host_rrq)  {
-			while (--i > 0)
+			while (--i >= 0)
 				dma_free_coherent(&pdev->dev,
 					sizeof(u32) * ioa_cfg->hrrq[i].size,
 					ioa_cfg->hrrq[i].host_rrq,
@@ -10064,7 +10064,7 @@ static int ipr_request_other_msi_irqs(struct ipr_ioa_cfg *ioa_cfg,
 			ioa_cfg->vectors_info[i].desc,
 			&ioa_cfg->hrrq[i]);
 		if (rc) {
-			while (--i >= 0)
+			while (--i > 0)
 				free_irq(pci_irq_vector(pdev, i),
 					&ioa_cfg->hrrq[i]);
 			return rc;
-- 
2.35.1



