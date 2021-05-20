Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AA138A9A5
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbhETLFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238210AbhETLB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DE6561D0F;
        Thu, 20 May 2021 10:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505036;
        bh=Mi2KtEz4PPUxtbCTXUfEY7jGyDAc7Vp0qP13vekl+RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+gCIy+/98dk+iXZIxN0HII2RMTIJx8pIPYleYn8bgXFLIO+WKh+qbKFTTQUuyn+Y
         CBHKF/+q9YoLG5tfctPOyDgUETch8Tz9W/+6eG62lu7anNaLvlDL3rfzxGdaeul4iV
         ioddnzVi5VFpRkXUjZv2FdAGqZAohRHGQ/RV2G3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Wang Nan <wangnan0@huawei.com>, Will Deacon <will@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 194/240] ARM: 9064/1: hw_breakpoint: Do not directly check the events overflow_handler hook
Date:   Thu, 20 May 2021 11:23:06 +0200
Message-Id: <20210520092115.177668376@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit a506bd5756290821a4314f502b4bafc2afcf5260 ]

The commit 1879445dfa7b ("perf/core: Set event's default
::overflow_handler()") set a default event->overflow_handler in
perf_event_alloc(), and replace the check event->overflow_handler with
is_default_overflow_handler(), but one is missing.

Currently, the bp->overflow_handler can not be NULL. As a result,
enable_single_step() is always not invoked.

Comments from Zhen Lei:

 https://patchwork.kernel.org/project/linux-arm-kernel/patch/20210207105934.2001-1-thunder.leizhen@huawei.com/

Fixes: 1879445dfa7b ("perf/core: Set event's default ::overflow_handler()")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Wang Nan <wangnan0@huawei.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/hw_breakpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index 671dbc28e5d4..59e04e2d9d9d 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -891,7 +891,7 @@ static void breakpoint_handler(unsigned long unknown, struct pt_regs *regs)
 			info->trigger = addr;
 			pr_debug("breakpoint fired: address = 0x%x\n", addr);
 			perf_bp_event(bp, regs);
-			if (!bp->overflow_handler)
+			if (is_default_overflow_handler(bp))
 				enable_single_step(bp, addr);
 			goto unlock;
 		}
-- 
2.30.2



