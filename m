Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE02549A9E3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323800AbiAYD3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56130 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446008AbiAXVGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:06:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15B2860C60;
        Mon, 24 Jan 2022 21:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DADC340E7;
        Mon, 24 Jan 2022 21:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058358;
        bh=/DgqTbH+xxPRtgjYWV9bVu1oAOUCw0uXfaKZbOLN0uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tb/cMOBS2cLfycTf7I6+zENmeyBFQ3E1+OFzEGZRzvdPBAYU/uAPCKn1zDMnj0Yq
         mWEmbwEz47PPImVHUdO4pFVw4XQgg2JGz2aB7s3Kug67oyTxfZGdwWGd6ACUKzqhXs
         Hcr235m7Yy+wa2MtkCVLok7ZgOUw+isWx+H7wQ/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0231/1039] sched/fair: Fix per-CPU kthread and wakee stacking for asym CPU capacity
Date:   Mon, 24 Jan 2022 19:33:40 +0100
Message-Id: <20220124184133.084799295@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit 014ba44e8184e1acf93e0cbb7089ee847802f8f0 ]

select_idle_sibling() has a special case for tasks woken up by a per-CPU
kthread where the selected CPU is the previous one. For asymmetric CPU
capacity systems, the assumption was that the wakee couldn't have a
bigger utilization during task placement than it used to have during the
last activation. That was not considering uclamp.min which can completely
change between two task activations and as a consequence mandates the
fitness criterion asym_fits_capacity(), even for the exit path described
above.

Fixes: b4c9c9f15649 ("sched/fair: Prefer prev cpu in asymmetric wakeup path")
Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lkml.kernel.org/r/20211129173115.4006346-1-vincent.donnefort@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 97d89516fbea2..f2cf047b25e56 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6400,7 +6400,8 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	if (is_per_cpu_kthread(current) &&
 	    in_task() &&
 	    prev == smp_processor_id() &&
-	    this_rq()->nr_running <= 1) {
+	    this_rq()->nr_running <= 1 &&
+	    asym_fits_capacity(task_util, prev)) {
 		return prev;
 	}
 
-- 
2.34.1



