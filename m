Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C4654A41B
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351471AbiFNCGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351477AbiFNCGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:06:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFB834642;
        Mon, 13 Jun 2022 19:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26B1D60AD8;
        Tue, 14 Jun 2022 02:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A208EC3411B;
        Tue, 14 Jun 2022 02:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172331;
        bh=jnvaKL2ylP9hoy1It4rGwhTXwZO5J+36jAw+FL5Cfcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfXrG8prc4whURDuR0cSAFapFOeym1LXHXVBarRz6gcuqlOSOsAdTorXyfRUjuYyc
         fHqcd3oiub1aZAgYbNe+MXGP/65g6l3PAxqpXhtIfFeoE8d+ixIvITLvi3gjl/579e
         weJaZAcpDboRW7o0GkAwBhDYiyiGEucz49GiUHc5B0g+VNtoqi2fQwArldK02OHTf6
         RRcipPk3CwRyWqGUzUjuo1LS5QdKaXrU4crOawfL+AuPY/i4atdhgvM1SMP7m/GJW7
         Hxb8FAk+kCG6L2WhoobHc1wZ3F0NFG/fnnweWSUOqiU5lQ6XgqzA3IUDN1jusRwPiT
         OF05TPRk/ZGeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 29/47] scsi: pmcraid: Fix missing resource cleanup in error case
Date:   Mon, 13 Jun 2022 22:04:22 -0400
Message-Id: <20220614020441.1098348-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
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
index fd674ed1febe..6d94837c9049 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4031,7 +4031,7 @@ pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 	return 0;
 
 out_unwind:
-	while (--i > 0)
+	while (--i >= 0)
 		free_irq(pci_irq_vector(pdev, i), &pinstance->hrrq_vector[i]);
 	pci_free_irq_vectors(pdev);
 	return rc;
-- 
2.35.1

