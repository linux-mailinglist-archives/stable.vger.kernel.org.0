Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604C859A1D7
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351042AbiHSQC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351415AbiHSQBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:01:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C56647C8;
        Fri, 19 Aug 2022 08:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12C4461767;
        Fri, 19 Aug 2022 15:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5B1C433D6;
        Fri, 19 Aug 2022 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924382;
        bh=kFCMjgGG9L4dx69d+8a8KmsN8u+ngZyXC7hm+vH0Gk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8iMhUpXnVY2wbcGaOw9BhkZEoue0gF3Z8riKIbQjPZs65jGxrgtgSZKL//n2P/kp
         VHhJSoKbstqHJnTdqJOq+cgYpULmCYaNDWqcxLsCU3wxJQr+rfVxsyjYAV6oZ9aqjO
         fFAPRVB43dZz0C0OTxCV21UHwJkhVOjmlQv9ZP8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/545] arm64: cpufeature: Allow different PMU versions in ID_DFR0_EL1
Date:   Fri, 19 Aug 2022 17:38:12 +0200
Message-Id: <20220819153834.755575719@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

[ Upstream commit 506506cad3947b942425b119ffa2b06715d5d804 ]

Commit b20d1ba3cf4b ("arm64: cpufeature: allow for version discrepancy in
PMU implementations") made it possible to run Linux on a machine with PMUs
with different versions without tainting the kernel. The patch relaxed the
restriction only for the ID_AA64DFR0_EL1.PMUVer field, and missed doing the
same for ID_DFR0_EL1.PerfMon , which also reports the PMU version, but for
the AArch32 state.

For example, with Linux running on two clusters with different PMU
versions, the kernel is tainted when bringing up secondaries with the
following message:

[    0.097027] smp: Bringing up secondary CPUs ...
[..]
[    0.142805] Detected PIPT I-cache on CPU4
[    0.142805] CPU features: SANITY CHECK: Unexpected variation in SYS_ID_DFR0_EL1. Boot CPU: 0x00000004011088, CPU4: 0x00000005011088
[    0.143555] CPU features: Unsupported CPU feature variation detected.
[    0.143702] GICv3: CPU4: found redistributor 10000 region 0:0x000000002f180000
[    0.143702] GICv3: CPU4: using allocated LPI pending table @0x00000008800d0000
[    0.144888] CPU4: Booted secondary processor 0x0000010000 [0x410fd0f0]

The boot CPU implements FEAT_PMUv3p1 (ID_DFR0_EL1.PerfMon, bits 27:24, is
0b0100), but CPU4, part of the other cluster, implements FEAT_PMUv3p4
(ID_DFR0_EL1.PerfMon = 0b0101).

Treat the PerfMon field as FTR_NONSTRICT and FTR_EXACT to pass the sanity
check and to match how PMUVer is treated for the 64bit ID register.

Fixes: b20d1ba3cf4b ("arm64: cpufeature: allow for version discrepancy in PMU implementations")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Link: https://lore.kernel.org/r/20220617111332.203061-1-alexandru.elisei@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c9108ed40645..4087e2d1f39e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -508,7 +508,7 @@ static const struct arm64_ftr_bits ftr_id_pfr2[] = {
 
 static const struct arm64_ftr_bits ftr_id_dfr0[] = {
 	/* [31:28] TraceFilt */
-	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_PERFMON_SHIFT, 4, 0xf),
+	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_DFR0_PERFMON_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_MPROFDBG_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_MMAPTRC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_COPTRC_SHIFT, 4, 0),
-- 
2.35.1



