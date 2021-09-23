Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6162A4156B7
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239889AbhIWDnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239545AbhIWDlb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:41:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B149611B0;
        Thu, 23 Sep 2021 03:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368392;
        bh=fC2NkX1EviIeCys10tUEjYV9bnTI81G1KpMDl1p/1bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncjqtB18YVGc8O/C26NJmCm5Zvv3ZyPhj3Dcdd8ep/kU95deW9pON392w70W14oyH
         8PLXnF3Er2TUkXMNKiekH6UZAuX8BbWs13WEqy9MwozGFZZ21FeGOuI0zlfy/arADR
         8Jo22JFYKwCqqhzANsHLz/D1pCdpqkud7rtVMgUFGaYGDN41yL4g7Af4HwYtckBoUk
         3MhDCAnvF1FeN9gBoaYaPLnXVwEjGg5hCIlS+65O8VOVGvByT0jUZXMqxZHOAS3Vak
         Qdhj6kxBb3lSbH1jdhxY5HfDSAYHZm4mnOBYs3RsIqcjLzCn9UKrrCFxc/jczCcGmz
         UbO9Ro0NMrnSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Li <ashimida@linux.alibaba.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        pcc@google.com, peterz@infradead.org, maz@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 12/15] arm64: Mark __stack_chk_guard as __ro_after_init
Date:   Wed, 22 Sep 2021 23:39:26 -0400
Message-Id: <20210923033929.1421446-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033929.1421446-1-sashal@kernel.org>
References: <20210923033929.1421446-1-sashal@kernel.org>
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
index d6a49bb07a5f..1945b8096a06 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -61,7 +61,7 @@
 
 #ifdef CONFIG_STACKPROTECTOR
 #include <linux/stackprotector.h>
-unsigned long __stack_chk_guard __read_mostly;
+unsigned long __stack_chk_guard __ro_after_init;
 EXPORT_SYMBOL(__stack_chk_guard);
 #endif
 
-- 
2.30.2

