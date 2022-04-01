Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B814EF552
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350596AbiDAPNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350559AbiDAPAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:00:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D0C12FFB5;
        Fri,  1 Apr 2022 07:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 280C5B8250F;
        Fri,  1 Apr 2022 14:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026B4C3410F;
        Fri,  1 Apr 2022 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824477;
        bh=PNEkahcZfmgG8tWyj2fK4EfexFqtwPrWBUAyhqjmF3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=An/rUQEd4TEcIP7Rs75Cw2Cpm3Hv0zJKCr4ejWF7Ix1Uk/cB6KSK//suM1Hf8mIAj
         iUQwR3xh/RV+Y/n/qRi3o/ROD4pJSVpDvYLvPZtjAjDKzEWjGOMavboIWZZFm5G7rf
         sJ3jbF6Z9wo6FbYk2uvoQcpCy4uH8KnvFntVdxgENUzJjeO4rpAkmFTytP607P6iOJ
         YlNBGxxyxF5ex/5NN/lXgfAurdKRXg0kUL2qTtdYkGnSE4NLQQFcBAl6az533ApkxU
         GBhAiM4e7O45Ed7Z2RTYPcVWSWsLr2VlzQiJn31/wDf/SINQjlyw0PnRbjy+tKPyW0
         KkeFOzu/Q4S2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhou Guanghui <zhouguanghui1@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        joro@8bytes.org, iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.14 09/22] iommu/arm-smmu-v3: fix event handling soft lockup
Date:   Fri,  1 Apr 2022 10:47:16 -0400
Message-Id: <20220401144729.1955554-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144729.1955554-1-sashal@kernel.org>
References: <20220401144729.1955554-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Guanghui <zhouguanghui1@huawei.com>

[ Upstream commit 30de2b541af98179780054836b48825fcfba4408 ]

During event processing, events are read from the event queue one
by one until the queue is empty.If the master device continuously
requests address access at the same time and the SMMU generates
events, the cyclic processing of the event takes a long time and
softlockup warnings may be reported.

arm-smmu-v3 arm-smmu-v3.34.auto: event 0x0a received:
arm-smmu-v3 arm-smmu-v3.34.auto: 	0x00007f220000280a
arm-smmu-v3 arm-smmu-v3.34.auto: 	0x000010000000007e
arm-smmu-v3 arm-smmu-v3.34.auto: 	0x00000000034e8670
watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [irq/268-arm-smm:247]
Call trace:
 _dev_info+0x7c/0xa0
 arm_smmu_evtq_thread+0x1c0/0x230
 irq_thread_fn+0x30/0x80
 irq_thread+0x128/0x210
 kthread+0x134/0x138
 ret_from_fork+0x10/0x1c
Kernel panic - not syncing: softlockup: hung tasks

Fix this by calling cond_resched() after the event information is
printed.

Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
Link: https://lore.kernel.org/r/20220119070754.26528-1-zhouguanghui1@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm-smmu-v3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 29feafa8007f..878087b9ddfe 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -1210,6 +1210,7 @@ static irqreturn_t arm_smmu_evtq_thread(int irq, void *dev)
 				dev_info(smmu->dev, "\t0x%016llx\n",
 					 (unsigned long long)evt[i]);
 
+			cond_resched();
 		}
 
 		/*
-- 
2.34.1

