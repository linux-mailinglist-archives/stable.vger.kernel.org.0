Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58D152BA41
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbiERMd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbiERMcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:32:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4B960A8B;
        Wed, 18 May 2022 05:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB0F86164C;
        Wed, 18 May 2022 12:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F600C36AE2;
        Wed, 18 May 2022 12:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876964;
        bh=9RWIWCvzw+luvshpZOAHRIXd41n81v/delU1wx/HP5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgMD9d9CLHUeRbPJrdX5livRw/SLuoZuy+CA4hhgeDhQpxONjLQ0MEH/n6yNuULu1
         o1fHtg7BNpv4xZm8hG2UVle5EGz157P05TJh+81sOOBuK/Y7UjqT2kf7natbH8aS2B
         kibrFJwtOH1leP03l3nGAF4p9nrMayRb7SdWxYe9N5BCS03ktbQk19dWlJvQn3N3bG
         8iIGhqzQ5QHayOkUE2X2w2H+A3gFZVR8eN+BP9tXgiuVRlifp2gKXMkPpH35ZAWCO9
         3ZoxYa+o92PKiqaKVGLMgX3nTfgwgpttJfXHl7enwJw8uFIafJlz1YEr4X6mHi/ro5
         8L9rezlU92tqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shreyas K K <quic_shrekk@quicinc.com>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, corbet@lwn.net, anshuman.khandual@arm.com,
        suzuki.poulose@arm.com, mathieu.poirier@linaro.org,
        james.morse@arm.com, arnd@arndb.de, lcherian@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/13] arm64: Enable repeat tlbi workaround on KRYO4XX gold CPUs
Date:   Wed, 18 May 2022 08:28:43 -0400
Message-Id: <20220518122844.343220-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122844.343220-1-sashal@kernel.org>
References: <20220518122844.343220-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreyas K K <quic_shrekk@quicinc.com>

[ Upstream commit 51f559d66527e238f9a5f82027bff499784d4eac ]

Add KRYO4XX gold/big cores to the list of CPUs that need the
repeat TLBI workaround. Apply this to the affected
KRYO4XX cores (rcpe to rfpe).

The variant and revision bits are implementation defined and are
different from the their Cortex CPU counterparts on which they are
based on, i.e., (r0p0 to r3p0) is equivalent to (rcpe to rfpe).

Signed-off-by: Shreyas K K <quic_shrekk@quicinc.com>
Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
Link: https://lore.kernel.org/r/20220512110134.12179-1-quic_shrekk@quicinc.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst | 3 +++
 arch/arm64/kernel/cpu_errata.c         | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 719510247292..f01eed0ee23a 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -160,6 +160,9 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Kryo4xx Silver  | N/A             | ARM64_ERRATUM_1024718       |
 +----------------+-----------------+-----------------+-----------------------------+
+| Qualcomm Tech. | Kryo4xx Gold    | N/A             | ARM64_ERRATUM_1286807       |
++----------------+-----------------+-----------------+-----------------------------+
+
 +----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | A64FX           | E#010001        | FUJITSU_ERRATUM_010001      |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 533559c7d2b3..ca42d58e8c82 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -220,6 +220,8 @@ static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1286807
 	{
 		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 3, 0),
+		/* Kryo4xx Gold (rcpe to rfpe) => (r0p0 to r3p0) */
+		ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
 	},
 #endif
 	{},
-- 
2.35.1

