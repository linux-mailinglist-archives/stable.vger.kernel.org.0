Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C8C553CAB
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355067AbiFUU4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355089AbiFUU4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:56:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587DF31521;
        Tue, 21 Jun 2022 13:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFA2861874;
        Tue, 21 Jun 2022 20:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A66AC3411C;
        Tue, 21 Jun 2022 20:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844589;
        bh=MLsaPkWl4pwEb56jRphAPhW21owYM+eoMh1VETT6uFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgwC5tEmVdGWRBDptbYYAMAgIFGdS/TZWUjxnoo4GjPJbi16+ujK5MxVXhxX5HCDY
         /33ihcNcFU27nWBZZ1uyGSJKXlph7fsBqzPyulgMlOdCL8kP7WyzgJhJ0KlfH/Co1l
         qFm2DtcIASblXsPLhTxvOpnR/3Sh7cPTWE113qbQV34GK2SUIhp+1jDccm4HM/dE74
         Qw2sSQ4de2S9lM90r8rxJ9RrVQm0E4YVFMkTCjr692ubV3YPkyepspTNWyIyOfX77y
         S6wYncEBBLkw7V76i1t16qHhbcTWqoG8ck+Pq0LMr5/DjckiDF1raVbA35AHhQdu/t
         JAjWK0ZHRlH8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 07/22] nvme-pci: add trouble shooting steps for timeouts
Date:   Tue, 21 Jun 2022 16:49:13 -0400
Message-Id: <20220621204928.249907-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621204928.249907-1-sashal@kernel.org>
References: <20220621204928.249907-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 4641a8e6e145f595059e695f0f8dbbe608134086 ]

Many users have encountered IO timeouts with a CSTS value of 0xffffffff,
which indicates a failure to read the register. While there are various
potential causes for this observation, faulty NVMe APST has been the
culprit quite frequently. Add the recommended troubleshooting steps in
the error output when this condition occurs.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 37e05c83786d..a4393c5ca8db 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1334,6 +1334,14 @@ static void nvme_warn_reset(struct nvme_dev *dev, u32 csts)
 		dev_warn(dev->ctrl.device,
 			 "controller is down; will reset: CSTS=0x%x, PCI_STATUS read failed (%d)\n",
 			 csts, result);
+
+	if (csts != ~0)
+		return;
+
+	dev_warn(dev->ctrl.device,
+		 "Does your device have a faulty power saving mode enabled?\n");
+	dev_warn(dev->ctrl.device,
+		 "Try \"nvme_core.default_ps_max_latency_us=0 pcie_aspm=off\" and report a bug\n");
 }
 
 static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
-- 
2.35.1

