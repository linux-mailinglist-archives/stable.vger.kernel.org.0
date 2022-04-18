Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73D7505974
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344039AbiDROU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344506AbiDROSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:18:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DF047AF5;
        Mon, 18 Apr 2022 06:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E674EB80EEA;
        Mon, 18 Apr 2022 13:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B54BC385A7;
        Mon, 18 Apr 2022 13:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287596;
        bh=2SO/WK+/OcnDbPUELASOfoynAAfaA8Zv+4kTfAUH8VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0fhgC7MQT/uLj8+DN61G/18iTSITXK5S8/VKF+ZstU0V7UOw4RTe6V2bgZq7Pu22
         N6qwiui6BmxW/mThenJ52sqGEnfMKjRbK9zHP38r7nZt7Dl54Aappgi8U4/tCKSXYQ
         Cb0cxzBpc0oA8fqfQfQHvt9ZZDTi9r4TeecSFYqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Guanghui <zhouguanghui1@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 171/218] iommu/arm-smmu-v3: fix event handling soft lockup
Date:   Mon, 18 Apr 2022 14:13:57 +0200
Message-Id: <20220418121205.435740005@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
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
index 48d382008788..db40ce599e97 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -1171,6 +1171,7 @@ static irqreturn_t arm_smmu_evtq_thread(int irq, void *dev)
 				dev_info(smmu->dev, "\t0x%016llx\n",
 					 (unsigned long long)evt[i]);
 
+			cond_resched();
 		}
 
 		/*
-- 
2.35.1



