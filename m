Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67103439CD9
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 19:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhJYRG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234889AbhJYREs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:04:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A071861040;
        Mon, 25 Oct 2021 17:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181299;
        bh=dRE1Ae5TjGlhI3JBvWk4OgBBdahe2+wjWm5DJyegv1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Twn5kqjFeJVwe96C+dFnRrQkgZ3mReXNI1urVWowByxkbqe5Q4uK0BZoygXi8cSze
         kOHsKARfWaC57Fi6jHvjco2NM6roA8+0kwoiOE0YSgxeL+EjcWfpQHOvIFUIbaDvd0
         W28WTYzTc82bJ9gERNwSk/sF5bPt4/W7gKTq0HLrMFTuc89SQnfvqNeLg0RoI5sw64
         hD/MX4BaY7BM03S5LVyTmi7XLHl9cLz8OZF+k4Gg7G4mKtwTQKfgDk7FYnmOgzbclw
         ON4gs203dlOm+zAXzWbZPI17VcAv1Y5RLw69DLsEv+H4rCay11Hy+6dhfjHlxo3eon
         QHgdd9N0xjbQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Wei Liu <wei.liu@kernel.org>,
        Sasha Levin <sashal@kernel.org>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/4] hyperv/vmbus: include linux/bitops.h
Date:   Mon, 25 Oct 2021 13:01:32 -0400
Message-Id: <20211025170132.1394887-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170132.1394887-1-sashal@kernel.org>
References: <20211025170132.1394887-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8017c99680fa65e1e8d999df1583de476a187830 ]

On arm64 randconfig builds, hyperv sometimes fails with this
error:

In file included from drivers/hv/hv_trace.c:3:
In file included from drivers/hv/hyperv_vmbus.h:16:
In file included from arch/arm64/include/asm/sync_bitops.h:5:
arch/arm64/include/asm/bitops.h:11:2: error: only <linux/bitops.h> can be included directly
In file included from include/asm-generic/bitops/hweight.h:5:
include/asm-generic/bitops/arch_hweight.h:9:9: error: implicit declaration of function '__sw_hweight32' [-Werror,-Wimplicit-function-declaration]
include/asm-generic/bitops/atomic.h:17:7: error: implicit declaration of function 'BIT_WORD' [-Werror,-Wimplicit-function-declaration]

Include the correct header first.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20211018131929.2260087-1-arnd@kernel.org
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hyperv_vmbus.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 8d7f865c1133..9d3605df1f48 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -26,6 +26,7 @@
 #define _HYPERV_VMBUS_H
 
 #include <linux/list.h>
+#include <linux/bitops.h>
 #include <asm/sync_bitops.h>
 #include <linux/atomic.h>
 #include <linux/hyperv.h>
-- 
2.33.0

