Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0726343A39D
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237849AbhJYUBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 16:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239587AbhJYT5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:57:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 329B461213;
        Mon, 25 Oct 2021 19:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191217;
        bh=TGKDaPZ0fWFU7Q4AYgmuWPMFIyZDVf21hj76SA6G2fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASC4x9FQY2KISjr3dMBzosLGFRW9EGrhzwlEpkqga6XB+EOtcThzASX3H218+4qaN
         7KFvELhlfSuK1lyF58PCzpJ1LTB3slres/2CErXnh91aRiKJwUa30IROEpM1ydyrbf
         6I1KW2D56TmJifRo1g8uFGkpOq5W60GXZF1dn61g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Woody Lin <woodylin@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 154/169] sched/scs: Reset the shadow stack when idle_task_exit
Date:   Mon, 25 Oct 2021 21:15:35 +0200
Message-Id: <20211025191036.972654970@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
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
index 399c37c95392..e165d28cf73b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8495,6 +8495,7 @@ void idle_task_exit(void)
 		finish_arch_post_lock_switch();
 	}
 
+	scs_task_reset(current);
 	/* finish_cpu(), as ran on the BP, will clean up the active_mm state */
 }
 
-- 
2.33.0



