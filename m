Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0480404C79
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343753AbhIIL5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244530AbhIILyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:54:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DBCD6139F;
        Thu,  9 Sep 2021 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187897;
        bh=AfyNKaF0xtWhgKji+tagvSCdhOnS9R1W6yf+rMj9Wis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPupzZHUzG9M5hd0m4dc6VbcR/hcvigNFPhABImd5L77r0Y/EzKDAA2fOafVvskJJ
         1UdUlDT7n1nK7UnmKBNxNsRatPwMRGflYAHwObTSdGyrZhBejM3e2hTWoCQklxSyHl
         WJS7FEeFxyvIHEo5B2bwyLSZzQ3nNB3HiI62N/EB9nrris2ifikExBKRl4Hr4dmqjf
         Ck8q/lNuBrz3l5ErdzOPYQgIjxOX8PcakgkWPvAbjHOsLR2lWogpfG53ZP7XfVfXww
         5kWqol6LTrBgVMucL3pqle2rtsOzyu9h2SM7cUY7qrqQ2ccyb/LiaaKuwry5pwqGT4
         CSCPBV+71PluQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 177/252] kselftest/arm64: mte: Fix misleading output when skipping tests
Date:   Thu,  9 Sep 2021 07:39:51 -0400
Message-Id: <20210909114106.141462-177-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 83e5dcbece4ea67ec3ad94b897e2844184802fd7 ]

When skipping the tests due to a lack of system support for MTE we
currently print a message saying FAIL which makes it look like the test
failed even though the test did actually report KSFT_SKIP, creating some
confusion. Change the error message to say SKIP instead so things are
clearer.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210819172902.56211-1-broonie@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/mte/mte_common_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/mte/mte_common_util.c b/tools/testing/selftests/arm64/mte/mte_common_util.c
index f50ac31920d1..0328a1e08f65 100644
--- a/tools/testing/selftests/arm64/mte/mte_common_util.c
+++ b/tools/testing/selftests/arm64/mte/mte_common_util.c
@@ -298,7 +298,7 @@ int mte_default_setup(void)
 	int ret;
 
 	if (!(hwcaps2 & HWCAP2_MTE)) {
-		ksft_print_msg("FAIL: MTE features unavailable\n");
+		ksft_print_msg("SKIP: MTE features unavailable\n");
 		return KSFT_SKIP;
 	}
 	/* Get current mte mode */
-- 
2.30.2

