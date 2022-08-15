Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7840C593AB8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346391AbiHOUOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242813AbiHOUNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:13:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5900132EF3;
        Mon, 15 Aug 2022 11:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86F70B810C5;
        Mon, 15 Aug 2022 18:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE280C433C1;
        Mon, 15 Aug 2022 18:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589947;
        bh=hFLdWtZlm6m47mimf7VH2hREI4jtWZfe2DLf4xlZbfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oyr1DeKiXKi+f8q6NKgzXKdQJWpBpsjp+cRa8cZffpH2HpAjw0VQacGDYXPBv++fR
         hqqpyHiXj6BYJ6mG/OmYAXY7lWFfQVbolwolnwEBOKmVY64OF9bqSoOyrgmg2t+7Hm
         2V+XlX8juld8ud1xPfnWXDJymRV0L4lxJMYtVKHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.18 0070/1095] RISC-V: Fix SBI PMU calls for RV32
Date:   Mon, 15 Aug 2022 19:51:09 +0200
Message-Id: <20220815180432.414248634@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Atish Patra <atishp@rivosinc.com>

commit 0209b5830bea42dd3ce33ab0397231e67ec3b751 upstream.

Some of the SBI PMU calls does not pass 64bit arguments
correctly and not under RV32 compile time flags. Currently,
this doesn't create any incorrect results as RV64 ignores
any value in the additional register and qemu doesn't support
raw events.

Fix those SBI calls in order to set correct values for RV32.

Fixes: e9991434596f ("RISC-V: Add perf platform driver based on SBI PMU extension")
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220711174632.4186047-4-atishp@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/riscv_pmu_sbi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 3735337a4cfb..bae614c73b14 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -274,8 +274,13 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 		cflags |= SBI_PMU_CFG_FLAG_SET_UINH;
 
 	/* retrieve the available counter index */
+#if defined(CONFIG_32BIT)
+	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase, cmask,
+			cflags, hwc->event_base, hwc->config, hwc->config >> 32);
+#else
 	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase, cmask,
 			cflags, hwc->event_base, hwc->config, 0);
+#endif
 	if (ret.error) {
 		pr_debug("Not able to find a counter for event %lx config %llx\n",
 			hwc->event_base, hwc->config);
@@ -417,8 +422,13 @@ static void pmu_sbi_ctr_start(struct perf_event *event, u64 ival)
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned long flag = SBI_PMU_START_FLAG_SET_INIT_VALUE;
 
+#if defined(CONFIG_32BIT)
 	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, hwc->idx,
 			1, flag, ival, ival >> 32, 0);
+#else
+	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, hwc->idx,
+			1, flag, ival, 0, 0);
+#endif
 	if (ret.error && (ret.error != SBI_ERR_ALREADY_STARTED))
 		pr_err("Starting counter idx %d failed with error %d\n",
 			hwc->idx, sbi_err_map_linux_errno(ret.error));
-- 
2.37.1



