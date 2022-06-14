Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C229954A6E4
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354684AbiFNCZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354716AbiFNCXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:23:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BF540933;
        Mon, 13 Jun 2022 19:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4148B80AC1;
        Tue, 14 Jun 2022 02:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE113C3411E;
        Tue, 14 Jun 2022 02:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172634;
        bh=WXzatfo1Gdzn71E2kMuzfXun5GozS4HNJ2f2i7o2MU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGeQYonL61Phkqid0Y0rXyqxM3psHCsN370t7NwcwnVkWaIlx+SwPzxz1zsQoMdJC
         v0ZwzLjcKL3yLlc3LmKj6+3rHrXnKoadjVPbroBWcbI3nIe7zwJJxgBKqNAZvRUlT0
         Pc1K+m85b6rVsxPUd7qTbrG6oP3w/wndh6eEaswd9EefdZJTDq+OINosy/qV2Ql9wD
         laJMx7jL4xeLQNsM1+j7RcSzYSdjaAm3mooKrL2iKebAmV/STdFQEgBz4jBDf2f5RV
         6ohjHFQ9rHTnUaX/uVsyiVmvbjQDIdm2WJAN/fThNZKtnnQe14XP731d/A8YdJNhxy
         EaClvJDA5PKLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/14] scsi: pmcraid: Fix missing resource cleanup in error case
Date:   Mon, 13 Jun 2022 22:10:15 -0400
Message-Id: <20220614021019.1100929-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614021019.1100929-1-sashal@kernel.org>
References: <20220614021019.1100929-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

[ Upstream commit ec1e8adcbdf661c57c395bca342945f4f815add7 ]

Fix missing resource cleanup (when '(--i) == 0') for error case in
pmcraid_register_interrupt_handler().

Link: https://lore.kernel.org/r/20220529153456.4183738-6-cgxu519@mykernel.net
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index b4d6cd8cd1ad..d27ae937ff68 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4601,7 +4601,7 @@ pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 	return 0;
 
 out_unwind:
-	while (--i > 0)
+	while (--i >= 0)
 		free_irq(pci_irq_vector(pdev, i), &pinstance->hrrq_vector[i]);
 	pci_free_irq_vectors(pdev);
 	return rc;
-- 
2.35.1

