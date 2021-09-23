Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F16415689
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbhIWDl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239420AbhIWDky (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BA226103C;
        Thu, 23 Sep 2021 03:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368363;
        bh=tQHIh3nJ8Y0ZE37+c4HeOpbSFERGAlNWddCWVbrEBEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5Rh5tGAQPD6zzRtUqkW4HlqLP8e3Bp9f+crPQMavBWPJIZf3voW4gn//ENa+kwLS
         QJK/3tKZYYesoKRw4tlGESHXiaVgzv0PUwK03PQ0k7Vvdw8fdndacqOTzlpt9Mz5Lv
         eWRVmJiA2Ks53OirVEaW4qfCl84jTOLDz3j4g92E9hCZhm3GeGUgqTkM5WIbAhIlLs
         xwukYCDdklq4V+jKzmm0CIjTLJB/4hmu9zWMlqhJUB8BONHEO99mTqp8aXOQvw6pUy
         kxfwKOfiPVdDKwXbzHadsesOuvDgaQ6snpmt/16CYDr9k9ZgWWhDv5ieIW/keQ4iqx
         SuZO87a4kheYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Li <ashimida@linux.alibaba.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        peterz@infradead.org, maz@kernel.org, pcc@google.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 16/19] arm64: Mark __stack_chk_guard as __ro_after_init
Date:   Wed, 22 Sep 2021 23:38:50 -0400
Message-Id: <20210923033853.1421193-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033853.1421193-1-sashal@kernel.org>
References: <20210923033853.1421193-1-sashal@kernel.org>
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
index 7d7cfa128b71..f61ef46ebff7 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -56,7 +56,7 @@
 
 #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_STACKPROTECTOR_PER_TASK)
 #include <linux/stackprotector.h>
-unsigned long __stack_chk_guard __read_mostly;
+unsigned long __stack_chk_guard __ro_after_init;
 EXPORT_SYMBOL(__stack_chk_guard);
 #endif
 
-- 
2.30.2

