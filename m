Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492BA667417
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjALOCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjALOCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:02:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F72825D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:02:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 568D9B81E6F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D962C433D2;
        Thu, 12 Jan 2023 14:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532135;
        bh=pDnMdryvZwl/j64L3ojctuAGhOOqZ5WcWCiObwwRsFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2frCCTC1EpijGXCxuUJKt1+6YfJFnbqMeJOWlq9PstuXC0pC0VbiyT91Hz9+lq0A
         N4mkuZijBJUsJ6BNGXfgCzb7EZ/Jo5L87U/cafP/6bZSU5GhCg5bS/UCE++mRwu/9I
         sAUs6eWTLBGUDApBwDK9v1anuCSTg1YS4zOMMg3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/783] perf/x86/intel/uncore: Fix reference count leak in snr_uncore_mmio_map()
Date:   Thu, 12 Jan 2023 14:46:19 +0100
Message-Id: <20230112135527.066492373@linuxfoundation.org>
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

[ Upstream commit 8ebd16c11c346751b3944d708e6c181ed4746c39 ]

pci_get_device() will increase the reference count for the returned
pci_dev, so snr_uncore_get_mc_dev() will return a pci_dev with its
reference count increased. We need to call pci_dev_put() to decrease the
reference count. Let's add the missing pci_dev_put().

Fixes: ee49532b38dd ("perf/x86/intel/uncore: Add IMC uncore support for Snow Ridge")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20221118063137.121512-4-wangxiongfeng2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index aa5da42ff948..2fd49cd515f5 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -4681,6 +4681,8 @@ static void __snr_uncore_mmio_init_box(struct intel_uncore_box *box,
 
 	addr += box_ctl;
 
+	pci_dev_put(pdev);
+
 	box->io_addr = ioremap(addr, type->mmio_map_size);
 	if (!box->io_addr) {
 		pr_warn("perf uncore: Failed to ioremap for %s.\n", type->name);
-- 
2.35.1



