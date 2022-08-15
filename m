Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F46A593AF4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiHOUNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346363AbiHOULP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:11:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C3F31373;
        Mon, 15 Aug 2022 11:57:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C8F460A71;
        Mon, 15 Aug 2022 18:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068E6C433C1;
        Mon, 15 Aug 2022 18:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589857;
        bh=tMbRNLEwJhzBn3I2NtkHXpA8he1iH1lPv6QR3bX1QbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ke0btZn/ca66Ownbl3i4AXFvJjcvxFenmxyFsprPYeJTEELnF2C2CFFmac9qwvSg7
         /9cS9yuFRL3ASECkQS90TcHdAGP1iNAwKf4nHjymdk201MNE+ZLBA7+9pGhVEeVrJT
         CICbQPur37iF0iDyThQnwWoTsA2jfV621SqZQHNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@rivosinc.com>, Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.18 0071/1095] RISC-V: Update user page mapping only once during start
Date:   Mon, 15 Aug 2022 19:51:10 +0200
Message-Id: <20220815180432.452222140@linuxfoundation.org>
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

commit 133a6d1fe7d7ad8393af025c4dde379c0616661f upstream.

Currently, riscv_pmu_event_set_period updates the userpage mapping.
However, the caller of riscv_pmu_event_set_period should update
the userpage mapping because the counter can not be updated/started
from set_period function in counter overflow path.

Invoke the perf_event_update_userpage at the caller so that it
doesn't get invoked twice during counter start path.

Fixes: f5bfa23f576f ("RISC-V: Add a perf core library for pmu drivers")
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220711174632.4186047-3-atishp@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/riscv_pmu.c     |    1 -
 drivers/perf/riscv_pmu_sbi.c |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/perf/riscv_pmu.c
+++ b/drivers/perf/riscv_pmu.c
@@ -170,7 +170,6 @@ int riscv_pmu_event_set_period(struct pe
 		left = (max_period >> 1);
 
 	local64_set(&hwc->prev_count, (u64)-left);
-	perf_event_update_userpage(event);
 
 	return overflow;
 }
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -542,6 +542,7 @@ static inline void pmu_sbi_start_overflo
 			sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, idx, 1,
 				  flag, init_val, 0, 0);
 #endif
+			perf_event_update_userpage(event);
 		}
 		ctr_ovf_mask = ctr_ovf_mask >> 1;
 		idx++;


