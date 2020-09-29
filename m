Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17D127C82F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbgI2L7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730646AbgI2LlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D2BC206E5;
        Tue, 29 Sep 2020 11:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379679;
        bh=B4eCsjTh7FS/YdlI5c5j/x8bYTrYRym5ms+rocYMK+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2YocDN7oAZg8HCFrieaoMSZwMLH8ryIn24wuiGGci5nZju2dMzeS2ZiaMySkbfhA
         n/rX/C8GVWTXGfue5nahxxJGt/oZh2jzkJF5FcntPR4tvCKcWJktBdChdptTX4+SpA
         myq7ii/AolVmv7nrGiSU5377DTUOIHNoPxETxey4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 270/388] arm64/cpufeature: Drop TraceFilt feature exposure from ID_DFR0 register
Date:   Tue, 29 Sep 2020 13:00:01 +0200
Message-Id: <20200929110023.531554804@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 1ed1b90a0594c8c9d31e8bb8be25a2b37717dc9e ]

ID_DFR0 based TraceFilt feature should not be exposed to guests. Hence lets
drop it.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/1589881254-10082-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 1df57ffc9314d..f2ec845404149 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -319,7 +319,7 @@ static const struct arm64_ftr_bits ftr_id_pfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_dfr0[] = {
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 28, 4, 0),
+	/* [31:28] TraceFilt */
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 24, 4, 0xf),	/* PerfMon */
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 20, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 16, 4, 0),
-- 
2.25.1



