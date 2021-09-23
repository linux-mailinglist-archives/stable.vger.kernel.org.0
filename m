Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0634415702
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbhIWDpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239178AbhIWDnf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:43:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 365A161357;
        Thu, 23 Sep 2021 03:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368447;
        bh=ILNT5vUGs2uITvDM8T1+ufsBENVFasIh7Q2M+DkMJYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXA1/DoQmMHN0ruPDoq4ykg+XLHIjfPTwOQa1Td76wZuDxtI6FQzbkQ7yrVfpZk/U
         wWlEOPar0Cse/l3Kbg/Gx8sTHr8hrkKGzBz7U3Lv2Vn3rwpL9eo1NQSgpn+c4SKAYQ
         Lis5xBzl6Bn2TGpKrPk2B1VwDnxaFqqusBaWEOCU/xL6cFXINe/BrIQFf/qadvDIWd
         Ucyz/B3UnN5Ic3xLEmEE7gmJHdE3QLGmYZakjc7Vxaf03sEwut/QfC1rxFvYcnNEM6
         BJ27uQmPyaMOa2vIpYEQqHjqS+8LJvYbUfSVXrII2fDpkOhvIbmlXidEK35ggVVSVW
         w41wYXraWuz1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Li <ashimida@linux.alibaba.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        maz@kernel.org, peterz@infradead.org, pcc@google.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 08/11] arm64: Mark __stack_chk_guard as __ro_after_init
Date:   Wed, 22 Sep 2021 23:40:24 -0400
Message-Id: <20210923034028.1421876-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923034028.1421876-1-sashal@kernel.org>
References: <20210923034028.1421876-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Li <ashimida@linux.alibaba.com>

[ Upstream commit 9fcb2e93f41c07a400885325e7dbdfceba6efaec ]

__stack_chk_guard is setup once while init stage and never changed
after that.

Although the modification of this variable at runtime will usually
cause the kernel to crash (so does the attacker), it should be marked
as __ro_after_init, and it should not affect performance if it is
placed in the ro_after_init section.

Signed-off-by: Dan Li <ashimida@linux.alibaba.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/1631612642-102881-1-git-send-email-ashimida@linux.alibaba.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index e917d119490c..9c62365f8267 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -57,7 +57,7 @@
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 #include <linux/stackprotector.h>
-unsigned long __stack_chk_guard __read_mostly;
+unsigned long __stack_chk_guard __ro_after_init;
 EXPORT_SYMBOL(__stack_chk_guard);
 #endif
 
-- 
2.30.2

