Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8537383383
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241906AbhEQO67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242479AbhEQO45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:56:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B081961463;
        Mon, 17 May 2021 14:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261532;
        bh=BJ35vUEDiBDhd/ZrnPZITVgqqOXwO8jiyXXVd9leTyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZZc7TZpVBDy+W/oj8FCL2+HEOt4EYtV+gqO/frBqPvBvg9GIPm829rkYwKZ2C4Zi
         4l8tdIvfwgImJN8wCo0YJqpnHS6XWdKXmMzK2UmNi78H8tgBNiL3GBEBDeHGWza4Qj
         uM/sad/+cb5O4vgQwSP1lwU/kXXb4F3gf/uC0vFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Wang Nan <wangnan0@huawei.com>, Will Deacon <will@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/141] ARM: 9064/1: hw_breakpoint: Do not directly check the events overflow_handler hook
Date:   Mon, 17 May 2021 16:01:48 +0200
Message-Id: <20210517140244.652010639@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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
index 7021ef0b4e71..b06d9ea07c84 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -883,7 +883,7 @@ static void breakpoint_handler(unsigned long unknown, struct pt_regs *regs)
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



