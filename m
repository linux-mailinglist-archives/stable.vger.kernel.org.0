Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBDB4EF426
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348852AbiDAPGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349867AbiDAO6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:58:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1599816BCFB;
        Fri,  1 Apr 2022 07:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4FA560BAF;
        Fri,  1 Apr 2022 14:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4610DC34113;
        Fri,  1 Apr 2022 14:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824324;
        bh=6V1nHrd8TUXwtn53KUZGT9jm7BI/3WXv0EB7DP4s+YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPR8RNh1yCg+04uyNs74IQ2F/AjbFf7adBatziNocS9zDrlIeyXFNyBEbNsygaHU2
         679iQ33J70SJLDymxmpBpDLH+b7hLMh21qiSRIyhxJxwhtqH+7QJhnd02kRo5gLif9
         hEPBgkje6+8OVHpuIjwNaJqIPM0uzjo8DVudtgXlabYb2Iuzx2eXirqs2c7vpMi/TM
         YEYoI7nx7RfjC+lcgy6KCrAqEAuCwZbFKahk/Nl2E9bVRnSzuoSjuk1SPUqfvfdtjr
         gsTnOhjQeS/kpmB52B2myW1UFnGV6xJg/gYyJy/5HYNGSQpwpytHgvr8XSIGJ9kr48
         1l9h0nLbJ0Otg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhou Guanghui <zhouguanghui1@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        joro@8bytes.org, iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 14/37] iommu/arm-smmu-v3: fix event handling soft lockup
Date:   Fri,  1 Apr 2022 10:44:23 -0400
Message-Id: <20220401144446.1954694-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144446.1954694-1-sashal@kernel.org>
References: <20220401144446.1954694-1-sashal@kernel.org>
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
index ef6af714a7e6..02c2fb551f38 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -1708,6 +1708,7 @@ static irqreturn_t arm_smmu_evtq_thread(int irq, void *dev)
 				dev_info(smmu->dev, "\t0x%016llx\n",
 					 (unsigned long long)evt[i]);
 
+			cond_resched();
 		}
 
 		/*
-- 
2.34.1

