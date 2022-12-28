Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5422965786A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbiL1Ou2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiL1OuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:50:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C6311A36
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E0B61544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8CDC433EF;
        Wed, 28 Dec 2022 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239014;
        bh=J/wsoV+dYZdd7ozc0KjL4fhK/Q1P4JJF9tENRhqZxwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6ns7BzwvpyfqsuwRsS0O5bm2E+5X9ThMBQ+skM+9uA1f9tpf+NnvrbnixJUuV73D
         GI4ZSpN5xKinJ+6geOq7cUZjZd1jdj5qwyRdH42VbK8xyMJY9WCe8Is6HyVuRzdmq/
         JvfaqPd2Yf58MgZaljVhVNtqib5/a1/m5GJjgIhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/731] perf/x86/intel/uncore: Fix reference count leak in __uncore_imc_init_box()
Date:   Wed, 28 Dec 2022 15:33:23 +0100
Message-Id: <20221228144259.333168167@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 17b8d847b92d815d1638f0de154654081d66b281 ]

pci_get_device() will increase the reference count for the returned
pci_dev, so tgl_uncore_get_mc_dev() will return a pci_dev with its
reference count increased. We need to call pci_dev_put() to decrease the
reference count before exiting from __uncore_imc_init_box(). Add
pci_dev_put() for both normal and error path.

Fixes: fdb64822443e ("perf/x86: Add Intel Tiger Lake uncore support")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20221118063137.121512-5-wangxiongfeng2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/uncore_snb.c b/arch/x86/events/intel/uncore_snb.c
index dc3ae55f79e0..912fb3821a6b 100644
--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -1423,6 +1423,7 @@ static void tgl_uncore_imc_freerunning_init_box(struct intel_uncore_box *box)
 	/* MCHBAR is disabled */
 	if (!(mch_bar & BIT(0))) {
 		pr_warn("perf uncore: MCHBAR is disabled. Failed to map IMC free-running counters.\n");
+		pci_dev_put(pdev);
 		return;
 	}
 	mch_bar &= ~BIT(0);
@@ -1436,6 +1437,8 @@ static void tgl_uncore_imc_freerunning_init_box(struct intel_uncore_box *box)
 	box->io_addr = ioremap(addr, type->mmio_map_size);
 	if (!box->io_addr)
 		pr_warn("perf uncore: Failed to ioremap for %s.\n", type->name);
+
+	pci_dev_put(pdev);
 }
 
 static struct intel_uncore_ops tgl_uncore_imc_freerunning_ops = {
-- 
2.35.1



