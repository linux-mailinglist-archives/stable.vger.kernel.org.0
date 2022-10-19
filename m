Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73101603C20
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiJSInl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiJSIm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:42:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75A57B78A;
        Wed, 19 Oct 2022 01:40:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76085CE20F0;
        Wed, 19 Oct 2022 08:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B56DC433D7;
        Wed, 19 Oct 2022 08:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168799;
        bh=TZQmwUKjFwQPzZOwmCSzDveGHxx/GcI5wz6rikE8fwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJCsbt6+3OilC9R3C7CDNUbdslBBG9tANbqpu3yUfXpVDYaNwipjrHE1ddy9uW7SF
         8fuVDZPJ4oQPKkgslS/Kh5rAMDj7TUYvZK0eROaYbNuziVJ4qxEbLWd20S1UsS217j
         QbDG28tJdHcCrbhfUE+8CLWtw8NQ8TfdAWxJF+a8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.0 057/862] RISC-V: Re-enable counter access from userspace
Date:   Wed, 19 Oct 2022 10:22:24 +0200
Message-Id: <20221019083252.507436677@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -645,8 +645,11 @@ static int pmu_sbi_starting_cpu(unsigned
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


