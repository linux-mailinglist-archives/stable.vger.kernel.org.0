Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6203C55D1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346687AbhGLIMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353942AbhGLIDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0359361D1F;
        Mon, 12 Jul 2021 07:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076739;
        bh=Xrfpi+7SF1c+hZ63W/OIRKOyZivlmR25Y3nJY5WsHIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdo4O3VsYDUk6sRF7SYsZoYTf8X0jytfyH3A7ZjGeZ8VWl6f7XFnTa5eaPPdCJspg
         Tmz9nzN/CU/7G1vZwsm603uwjg/pwecD4YzIa8GQkxD1S82b54/yhqbbzbwtBnaP+1
         MIw2nUOFenZAGP++IlzGy+ndMUS+HDjN5mV5/Rik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Hillf Danton <hdanton@sina.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 773/800] kfence: unconditionally use unbound work queue
Date:   Mon, 12 Jul 2021 08:13:16 +0200
Message-Id: <20210712061049.088265047@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit ff06e45d3aace3f93d23956c1e655224f363ebe2 ]

Unconditionally use unbound work queue, and not just if wq_power_efficient
is true.  Because if the system is idle, KFENCE may wait, and by being run
on the unbound work queue, we permit the scheduler to make better
scheduling decisions and not require pinning KFENCE to the same CPU upon
waking up.

Link: https://lkml.kernel.org/r/20210521111630.472579-1-elver@google.com
Fixes: 36f0b35d0894 ("kfence: use power-efficient work queue to run delayed work")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Hillf Danton <hdanton@sina.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kfence/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 4d21ac44d5d3..d7666ace9d2e 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -636,7 +636,7 @@ static void toggle_allocation_gate(struct work_struct *work)
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
 #endif
-	queue_delayed_work(system_power_efficient_wq, &kfence_timer,
+	queue_delayed_work(system_unbound_wq, &kfence_timer,
 			   msecs_to_jiffies(kfence_sample_interval));
 }
 static DECLARE_DELAYED_WORK(kfence_timer, toggle_allocation_gate);
@@ -666,7 +666,7 @@ void __init kfence_init(void)
 	}
 
 	WRITE_ONCE(kfence_enabled, true);
-	queue_delayed_work(system_power_efficient_wq, &kfence_timer, 0);
+	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
 	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
 		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
 		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
-- 
2.30.2



