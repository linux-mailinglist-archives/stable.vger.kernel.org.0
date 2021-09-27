Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8932419A5E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbhI0RIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:08:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236220AbhI0RHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:07:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 302576109F;
        Mon, 27 Sep 2021 17:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762357;
        bh=CgYa0ibwVUPKcIRAvu2TBAhiXYzbcgNSV7BAfqaSZ98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2O9QLwotjwhBT+1qZBVW7qgv5UaCK+2tcnwuu86TRIigM7+2JEvJJkDpNlcj5n9/s
         mzOQVvXn7pQUr0jqAtQ8Fs0LpwWgajg0DRoy6RFoY1VlMscvtAZyARAkfKZ3FKa/Lv
         e41cGUIKZuKs3JeR4Pcflo3iMnHP+gZaT/Px5cxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Li <ashimida@linux.alibaba.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 60/68] arm64: Mark __stack_chk_guard as __ro_after_init
Date:   Mon, 27 Sep 2021 19:02:56 +0200
Message-Id: <20210927170222.049602894@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



