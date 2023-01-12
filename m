Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB599667419
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjALOCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjALOCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:02:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E6A297
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:02:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53E7FB81E6A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9684EC433D2;
        Thu, 12 Jan 2023 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532138;
        bh=UFJISgrawO83DHpFzBsjPmDPirZt+VynwMobDfXIqoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCUTgEj80IzbGyFQjjQpRTJ3D32tiy69bzemjXwzD3PKXQHD/aX9oX1EgKvxXHyns
         RT9C/qFeKVFS3a5zn1c4QuJUYBrv3P1OwcI31Dz9qRZfrcebpl5fmLgMgP6Qr2h8ok
         mw9oSQ47/b7RDhFU5p0rZ2Q6UJBWm3u8EXB0aC4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/783] perf/x86/intel/uncore: Fix reference count leak in __uncore_imc_init_box()
Date:   Thu, 12 Jan 2023 14:46:20 +0100
Message-Id: <20230112135527.107281018@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index fa9289718147..a4c20e37bec2 100644
--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -1274,6 +1274,7 @@ static void tgl_uncore_imc_freerunning_init_box(struct intel_uncore_box *box)
 	/* MCHBAR is disabled */
 	if (!(mch_bar & BIT(0))) {
 		pr_warn("perf uncore: MCHBAR is disabled. Failed to map IMC free-running counters.\n");
+		pci_dev_put(pdev);
 		return;
 	}
 	mch_bar &= ~BIT(0);
@@ -1287,6 +1288,8 @@ static void tgl_uncore_imc_freerunning_init_box(struct intel_uncore_box *box)
 	box->io_addr = ioremap(addr, type->mmio_map_size);
 	if (!box->io_addr)
 		pr_warn("perf uncore: Failed to ioremap for %s.\n", type->name);
+
+	pci_dev_put(pdev);
 }
 
 static struct intel_uncore_ops tgl_uncore_imc_freerunning_ops = {
-- 
2.35.1



