Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849845586AE
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiFWSQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236694AbiFWSPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:15:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA24D828A9;
        Thu, 23 Jun 2022 10:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FD8261DE5;
        Thu, 23 Jun 2022 17:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5128DC3411B;
        Thu, 23 Jun 2022 17:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004921;
        bh=Z/bU1EntVyuSsKMlpIaPPhcqMGerETGyWjEkmgHMzi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhI1IS6dEahi6odbm/u1YkqoLxfIpWrWkL3geFZos5Gi0ghaQNX98MMpdiUzdPtV2
         +Bj4nD9z+6+GZF7w9a5Vms7oOAW96624yh3uVKE3LFIBXHYfQMVISdM3GUHTxRexI2
         fmRWaSKRapLAWUZH/NppeIcq4WzZ9bCwVdY7LBvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Chengguang Xu <cgxu519@mykernel.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 193/234] scsi: pmcraid: Fix missing resource cleanup in error case
Date:   Thu, 23 Jun 2022 18:44:20 +0200
Message-Id: <20220623164348.509856650@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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
index 4e86994e10e8..6e96229c58e0 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4559,7 +4559,7 @@ pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 	return 0;
 
 out_unwind:
-	while (--i > 0)
+	while (--i >= 0)
 		free_irq(pci_irq_vector(pdev, i), &pinstance->hrrq_vector[i]);
 	pci_free_irq_vectors(pdev);
 	return rc;
-- 
2.35.1



