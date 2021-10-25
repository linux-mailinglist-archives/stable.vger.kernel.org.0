Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE6243A193
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbhJYTjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236108AbhJYThs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE1F560720;
        Mon, 25 Oct 2021 19:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190465;
        bh=/GoDkD/5lkMsxQRMy/E/WqEGtCHiqbzOFAqRUqTha6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSgCrdAPRbmyF984Fajb0qVDXh+P3vhrStmDWn4OLK/pkJSh5Kyw7zOXZQtBc+z6o
         JVo5bDJ7Q6dlON9/p421nOJxuVL/XhMWKFlfZzB4dBEuwy8vYB1TfnBX113EVcoO8M
         KQt+L4IdXAvH4B6JItofNpeRydQWqNWpx21BzcCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Woody Lin <woodylin@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 83/95] sched/scs: Reset the shadow stack when idle_task_exit
Date:   Mon, 25 Oct 2021 21:15:20 +0200
Message-Id: <20211025191008.846321007@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Woody Lin <woodylin@google.com>

[ Upstream commit 63acd42c0d4942f74710b11c38602fb14dea7320 ]

Commit f1a0a376ca0c ("sched/core: Initialize the idle task with
preemption disabled") removed the init_idle() call from
idle_thread_get(). This was the sole call-path on hotplug that resets
the Shadow Call Stack (scs) Stack Pointer (sp).

Not resetting the scs-sp leads to scs overflow after enough hotplug
cycles. Therefore add an explicit scs_task_reset() to the hotplug code
to make sure the scs-sp does get reset on hotplug.

Fixes: f1a0a376ca0c ("sched/core: Initialize the idle task with preemption disabled")
Signed-off-by: Woody Lin <woodylin@google.com>
[peterz: Changelog]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lore.kernel.org/r/20211012083521.973587-1-woodylin@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6db20a66e8e6..e4551d1736fa 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6677,6 +6677,7 @@ void idle_task_exit(void)
 		finish_arch_post_lock_switch();
 	}
 
+	scs_task_reset(current);
 	/* finish_cpu(), as ran on the BP, will clean up the active_mm state */
 }
 
-- 
2.33.0



