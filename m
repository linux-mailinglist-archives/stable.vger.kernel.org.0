Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7775752AC
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 18:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbiGNQWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 12:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238119AbiGNQWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 12:22:40 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B13D362A47
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 09:22:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C28B71D13;
        Thu, 14 Jul 2022 09:22:38 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.174])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B1433F70D;
        Thu, 14 Jul 2022 09:22:37 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Sumit Gupta <sumitg@nvidia.com>
Subject: [stable:PATCH v4.9.323] arm64: entry: Restore tramp_map_kernel ISB
Date:   Thu, 14 Jul 2022 17:22:25 +0100
Message-Id: <20220714162225.280073-1-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Summit reports that the BHB backports for v4.9 prevent vulnerable
platforms from booting when CONFIG_RANDOMIZE_BASE is enabled.

This is because the trampoline code takes a translation fault when
accessing the data page, because the TTBR write hasn't been completed
by an ISB before the access is made.

Upstream has a complex erratum workaround for QCOM_FALKOR_E1003 in
this area, which removes the ISB when the workaround has been applied.
v4.9 lacks this workaround, but should still have the ISB.

Restore the barrier.

Fixes: aee10c2dd013 ("arm64: entry: Add macro for reading symbol addresses from the trampoline")
Reported-by: Sumit Gupta <sumitg@nvidia.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
---
This only applies to the v4.9 backport, as v4.14 has the QCOM_FALKOR_E1003
workaround.

 arch/arm64/kernel/entry.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 1f79abb1e5dd..4551c0f35fc4 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -964,6 +964,7 @@ __ni_sys_trace:
 	b	.
 2:
 	tramp_map_kernel	x30
+	isb
 	tramp_data_read_var	x30, vectors
 	prfm	plil1strm, [x30, #(1b - \vector_start)]
 	msr	vbar_el1, x30
-- 
2.30.2

