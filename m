Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CBB6085D0
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiJVHjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiJVHjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:39:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8222A4387;
        Sat, 22 Oct 2022 00:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21F3FB82D9F;
        Sat, 22 Oct 2022 07:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83146C433D7;
        Sat, 22 Oct 2022 07:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424176;
        bh=mGRauISegIPrTXzdB7pt9upnSHpoEpaDkcfpDRK+yts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaKUhQWOqjkb0Q7QLosuaicV8YBBULk/KR/XIqXpHWy72dU4MIX1ME/LMuIV8KWmB
         ktM5c6yXiziWTnaVUbgqrHUQ0K8z0+mIsndJbEyq+GZ2BNYmCbGm/o8sZkCKjrpzuT
         bgsIWmAi/6D2ybZxK3JJBCfIUf2QV8yQV6Rupfao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.19 051/717] RISC-V: Re-enable counter access from userspace
Date:   Sat, 22 Oct 2022 09:18:50 +0200
Message-Id: <20221022072424.147975123@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

commit 5a5294fbe0200d1327f0e089135dad77b45aa2ee upstream.

These counters were part of the ISA when we froze the uABI, removing
them breaks userspace.

Link: https://lore.kernel.org/all/YxEhC%2FmDW1lFt36J@aurel32.net/
Fixes: e9991434596f ("RISC-V: Add perf platform driver based on SBI PMU extension")
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20220928131807.30386-1-palmer@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/riscv_pmu_sbi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -639,8 +639,11 @@ static int pmu_sbi_starting_cpu(unsigned
 	struct riscv_pmu *pmu = hlist_entry_safe(node, struct riscv_pmu, node);
 	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
 
-	/* Enable the access for TIME csr only from the user mode now */
-	csr_write(CSR_SCOUNTEREN, 0x2);
+	/*
+	 * Enable the access for CYCLE, TIME, and INSTRET CSRs from userspace,
+	 * as is necessary to maintain uABI compatibility.
+	 */
+	csr_write(CSR_SCOUNTEREN, 0x7);
 
 	/* Stop all the counters so that they can be enabled from perf */
 	pmu_sbi_stop_all(pmu);


