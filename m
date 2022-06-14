Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B639B54A650
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354107AbiFNCYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354530AbiFNCXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:23:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2053E40900;
        Mon, 13 Jun 2022 19:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1C5A60F1C;
        Tue, 14 Jun 2022 02:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E138C34114;
        Tue, 14 Jun 2022 02:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172633;
        bh=6rhygkd6Oy5L/KrV0UrhH/iU7JA+Qqh+u3r+bK1jBU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/1WQZutNzhdToCSdSyiEIswUeHUojuFOnrchEnrQPwAifIeDg4AUXjt5glvnU+gL
         AhUafI4aTO7lbu8maqUlWJQXJRAmGpW22SzW7+E3q3E2EwUxn8rZKFEBk2LKeo6I8E
         ktO29jJC/iVLqfhIgrHdH7zWDNiWVKbFVt8w0ez3F4+uaT1vRrlYPeuiHkEKZZgqN+
         P1kUYlQGaSB8YTzVrpPzw22U3LScLJlkJzyQMr+vKC1zR8CzGBG91adz7OGf95lqPT
         pylCaG3jWpvSnX7w0Dd/wLXPMbEHJIokC05q5k2T+0bb4KbpgDZhBfWPK3StCWAOLM
         +nHpDDqk/+oNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/14] scsi: ipr: Fix missing/incorrect resource cleanup in error case
Date:   Mon, 13 Jun 2022 22:10:14 -0400
Message-Id: <20220614021019.1100929-9-sashal@kernel.org>
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
index b172f0a02083..99b37e19feca 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9788,7 +9788,7 @@ static int ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 					GFP_KERNEL);
 
 		if (!ioa_cfg->hrrq[i].host_rrq)  {
-			while (--i > 0)
+			while (--i >= 0)
 				dma_free_coherent(&pdev->dev,
 					sizeof(u32) * ioa_cfg->hrrq[i].size,
 					ioa_cfg->hrrq[i].host_rrq,
@@ -10060,7 +10060,7 @@ static int ipr_request_other_msi_irqs(struct ipr_ioa_cfg *ioa_cfg,
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

