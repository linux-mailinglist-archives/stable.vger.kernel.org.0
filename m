Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC64348F41
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhCYL0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhCYLZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79D6561A3A;
        Thu, 25 Mar 2021 11:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671555;
        bh=MbeWw4oWC2p3Gafd3OBzJSSDSyVlQMJTbqPQjbSF3rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8C4mQ8D52uJl4Q1Wbigtwp0MNMGg7tivDey09gJDhDNWCM4kPmMfAc1DvI/1MFKn
         9exPLcOztptfric4Yjxsjexd8X/eh1ElaQCDjKgF6S2Hc3rEezQ89ZQJMJpOPS4TMx
         9n+s4/o2OIE2CX/L0xU2IkneTg73AloY4WnrJap+oj8M7dXRkWhBJzpA9n9IaL7ZSI
         rUethOk0mOpwuSEjWPC89QSqYA0a1y4N/AXl2ObsiE+9Lu1mo2bwNsvm40InJ8mlkv
         kNXaP0NOIuoMIyi5rKMQCEUfovTplvPATYEHALPMFoIO69V2EB4yF3Hs+gYnbWWBoB
         VdMsRawCEWhVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 43/44] signal: don't allow STOP on PF_IO_WORKER threads
Date:   Thu, 25 Mar 2021 07:24:58 -0400
Message-Id: <20210325112459.1926846-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 4db4b1a0d1779dc159f7b87feb97030ec0b12597 ]

Just like we don't allow normal signals to IO threads, don't deliver a
STOP to a task that has PF_IO_WORKER set. The IO threads don't take
signals in general, and have no means of flushing out a stop either.

Longer term, we may want to look into allowing stop of these threads,
as it relates to eg process freezing. For now, this prevents a spin
issue if a SIGSTOP is delivered to the parent task.

Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 55526b941011..00a3840f6037 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
 			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
 	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
 
-	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
+	if (unlikely(fatal_signal_pending(task) ||
+		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
 		return false;
 
 	if (mask & JOBCTL_STOP_SIGMASK)
-- 
2.30.1

