Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6144EF0D2
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348020AbiDAOhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347401AbiDAOcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:32:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109BF1EA5F4;
        Fri,  1 Apr 2022 07:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6BBCB8240E;
        Fri,  1 Apr 2022 14:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2048C36AE5;
        Fri,  1 Apr 2022 14:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823324;
        bh=ztBeVF9WB83uKZD3kNmhGZbstigJErovXUlgTqCNbBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N32vJlpUZM1U33gexbg3wJllv+Q6KhX0MH2LZLSuz3H2N90md4muYd0CCd/wRmvVy
         /nLgFBv5UjYYSz2M5WAr9Xt3qSSSbq3jD4OrQVo3f+Ei63so+17tROKfl7AiQtgEPl
         TIR9LDuhhXnPKqtyy6Y4tW4Q1m2DerB2gr5GLlul2kZx8lHsS3LQ3B13Gt6/hVGiPZ
         vemEXNauqRLX8Zu8OGzaUak5OKkSb40C7GOkeGQClEB/SI6pIuyoHpqwfSmLkGLWhE
         PyUuK16/Fv0oObrY2YQeOD5iiesYU9j8EziOOy9cPy6x5pjGrqB3I/3qrED1ZBhubk
         mMMNWR49QXLdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhou Guanghui <zhouguanghui1@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        joro@8bytes.org, robin.murphy@arm.com, thunder.leizhen@huawei.com,
        jgg@ziepe.ca, jean-philippe@linaro.org, tglx@linutronix.de,
        christophe.jaillet@wanadoo.fr,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.17 057/149] iommu/arm-smmu-v3: fix event handling soft lockup
Date:   Fri,  1 Apr 2022 10:24:04 -0400
Message-Id: <20220401142536.1948161-57-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
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
index 6dc6d8b6b368..f60381cdf1c4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1558,6 +1558,7 @@ static irqreturn_t arm_smmu_evtq_thread(int irq, void *dev)
 				dev_info(smmu->dev, "\t0x%016llx\n",
 					 (unsigned long long)evt[i]);
 
+			cond_resched();
 		}
 
 		/*
-- 
2.34.1

