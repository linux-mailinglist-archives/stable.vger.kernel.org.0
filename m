Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA82823BB
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 19:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbfHERNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 13:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbfHERNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 13:13:18 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8334208E3;
        Mon,  5 Aug 2019 17:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565025197;
        bh=5ISqReixmpEIQdd6aS7fvFeHnDIsx1DcPbm2MMGxbDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJlKKkHfSHiiGTL8Jy9tpe5e5JC72+LDU8RMHl/g9WEQA/cb+13d6vhOF2YCtRrmB
         P7rtvNaoXAgvpLk4KhdV8KzdwYPyiD19cKEJx6wAL+j3b+kT5H37Vjd0HTIBdbr++y
         FYoJUyi80ZqKTCId4GWrnBUDpoesIly8cwzd3EF8=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Shanker Donthineni <shankerd@codeaurora.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 1/2] arm64: cpufeature: Fix CTR_EL0 field definitions
Date:   Mon,  5 Aug 2019 18:13:07 +0100
Message-Id: <20190805171308.19249-2-will@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190805171308.19249-1-will@kernel.org>
References: <20190805171308.19249-1-will@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit be68a8aaf925aaf35574260bf820bb09d2f9e07f upstream.

Our field definitions for CTR_EL0 suffer from a number of problems:

  - The IDC and DIC fields are missing, which causes us to enable CTR
    trapping on CPUs with either of these returning non-zero values.

  - The ERG is FTR_LOWER_SAFE, whereas it should be treated like CWG as
    FTR_HIGHER_SAFE so that applications can use it to avoid false sharing.

  - [nit] A RES1 field is described as "RAO"

This patch updates the CTR_EL0 field definitions to fix these issues.

Cc: <stable@vger.kernel.org> # 4.4.y only
Cc: Shanker Donthineni <shankerd@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c1eddc07d996..fff0bf2f889e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -126,10 +126,12 @@ static struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
 };
 
 static struct arm64_ftr_bits ftr_ctr[] = {
-	U_ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 31, 1, 1),	/* RAO */
-	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 28, 3, 0),
+	U_ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 31, 1, 1),	/* RES1 */
+	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 30, 1, 0),
+	U_ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, 29, 1, 1),	/* DIC */
+	U_ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, 28, 1, 1),	/* IDC */
 	U_ARM64_FTR_BITS(FTR_STRICT, FTR_HIGHER_SAFE, 24, 4, 0),	/* CWG */
-	U_ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, 20, 4, 0),	/* ERG */
+	U_ARM64_FTR_BITS(FTR_STRICT, FTR_HIGHER_SAFE, 20, 4, 0),	/* ERG */
 	U_ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, 16, 4, 1),	/* DminLine */
 	/*
 	 * Linux can handle differing I-cache policies. Userspace JITs will
-- 
2.11.0

