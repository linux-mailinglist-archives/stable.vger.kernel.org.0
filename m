Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA50254A55B
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353767AbiFNCRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353623AbiFNCQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:16:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533DE3E0F4;
        Mon, 13 Jun 2022 19:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8FA6B8169E;
        Tue, 14 Jun 2022 02:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E9EC3411B;
        Tue, 14 Jun 2022 02:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172570;
        bh=nP9i1+rEQjQRHfrlgE3xHFNg4YpgFbPf5Seq91ii+60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8FfRMo8rXtl5SyYEZ0yK8K2kvd/zI1nhVbSzUbU3xCaTt7VWsE0QXW98QePKrlfY
         fd9HQUDtBWI0Pas4VJppG/B5QoxNe9VV2uxeFM0iM5nIRXJkx1e+Ee/qYvjtn5938R
         RlF5cAZe1gLw0dZrO0bz4nRc+u4kBBh/qfiY7ouyNgA8vrlaabsl5jleTgXcC+Te4g
         dkzN+VVF6CEU+cIFbZ01TtAuxVuxbBF+xPoCUVcdKeCsv3kQrLOHIbFQqu7MsPXNhz
         0GupukNZJmG5KtX5uBsVv/wYhL7DBoNrb+MCaM+lNjRHGKxlY/8Mh3sIQh05HuH/qQ
         6ezq94R9qxg1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/23] scsi: pmcraid: Fix missing resource cleanup in error case
Date:   Mon, 13 Jun 2022 22:08:53 -0400
Message-Id: <20220614020900.1100401-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020900.1100401-1-sashal@kernel.org>
References: <20220614020900.1100401-1-sashal@kernel.org>
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
index 398d2af60832..f95a970db8fd 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4532,7 +4532,7 @@ pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 	return 0;
 
 out_unwind:
-	while (--i > 0)
+	while (--i >= 0)
 		free_irq(pci_irq_vector(pdev, i), &pinstance->hrrq_vector[i]);
 	pci_free_irq_vectors(pdev);
 	return rc;
-- 
2.35.1

