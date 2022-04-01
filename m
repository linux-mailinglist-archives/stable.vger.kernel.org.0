Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F18A4EF2D7
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349470AbiDAO4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351725AbiDAOtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:49:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFEF2AD5F2;
        Fri,  1 Apr 2022 07:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D74B460A53;
        Fri,  1 Apr 2022 14:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8322C340F2;
        Fri,  1 Apr 2022 14:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823966;
        bh=IXNk+r4y+rvr1qk44p2AZxLKsjerdAqkxh1yBvqdaX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAy8lL6DPaL8aiUx0fLcPgAph/eYQ/2GRrItMZN9r8QNj0AMEtIg2pev+gpmtNP4g
         k2QgsWoOZZ/RyBeNr+1wdfdwcXeeDJI0JBXiGfwpjZtA9ujRjyol4JQNItpoQ4nbF+
         pPzuIzbIZlEhVlu3demUsPS3fgkoloI/L4JfiAFbs+Ha6AdDRh4yaC6tw8ira0lLEh
         pfr0Mcos7CxzX1XfSWhJfGDp9fF/jBSbgpJIBMARWS0UCDGORYICIX7E6WAIjUXpkv
         NFdSqAdlM/blynHHX1MsnZESTQsReJrxcQUL7WmkU5guQYOQoUHATzaWahlPHApfiQ
         Ijz2wkFECv6wQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhou Guanghui <zhouguanghui1@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        joro@8bytes.org, robin.murphy@arm.com, thunder.leizhen@huawei.com,
        jean-philippe@linaro.org, tglx@linutronix.de,
        john.garry@huawei.com, christophe.jaillet@wanadoo.fr,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 33/98] iommu/arm-smmu-v3: fix event handling soft lockup
Date:   Fri,  1 Apr 2022 10:36:37 -0400
Message-Id: <20220401143742.1952163-33-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a388e318f86e..430315135cff 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1552,6 +1552,7 @@ static irqreturn_t arm_smmu_evtq_thread(int irq, void *dev)
 				dev_info(smmu->dev, "\t0x%016llx\n",
 					 (unsigned long long)evt[i]);
 
+			cond_resched();
 		}
 
 		/*
-- 
2.34.1

