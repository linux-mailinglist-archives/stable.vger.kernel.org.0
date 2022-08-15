Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E503593C98
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344761AbiHOUdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347252AbiHOUbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:31:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099EFA4046;
        Mon, 15 Aug 2022 12:04:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29256612BE;
        Mon, 15 Aug 2022 19:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31130C433D6;
        Mon, 15 Aug 2022 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590262;
        bh=PPKlFE3ND5uq7QSeTU/xSmPJVmUGIqw1ut9sjre9/U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8uJJzgCylHXMs+fhNWBa8Iqed9fKfOt4lAasuUOTqbuPlYbIUZ9jVOVuSkizm0hv
         KaShFFuO5/vzXEUDR6Gw0RXaTB7AHqb7Ksq06FhoD9GgVNW3wdL1K/XP/0DpTrprBH
         2tlPr7C5bBNtUYrhAgseg58Hbl7Fuc2UecnLA2HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0205/1095] arm64: cpufeature: Allow different PMU versions in ID_DFR0_EL1
Date:   Mon, 15 Aug 2022 19:53:24 +0200
Message-Id: <20220815180438.150739474@linuxfoundation.org>
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
index 5357ba7ea3c7..a54f34aa36e0 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -541,7 +541,7 @@ static const struct arm64_ftr_bits ftr_id_pfr2[] = {
 
 static const struct arm64_ftr_bits ftr_id_dfr0[] = {
 	/* [31:28] TraceFilt */
-	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_PERFMON_SHIFT, 4, 0xf),
+	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_DFR0_PERFMON_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_MPROFDBG_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_MMAPTRC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_COPTRC_SHIFT, 4, 0),
-- 
2.35.1



