Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DE7348F9D
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhCYL2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:28:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231296AbhCYL0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B818261A32;
        Thu, 25 Mar 2021 11:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671608;
        bh=sHPB1BgOfR+6+Sqv4errnJauM6CnffGtvyEOvgEw1fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQnDvECb4ZAuqvyDUfmq0vp3IKJU8rAOygmNEArBfgXvkMToNa11XwJbwJsxy+kXb
         MHmIO0Ma9sgRHMdsiS5wmlynT3prrJ4iFf+YH6o3jVyXMnaeb6tdOJrMToPr2KLHbl
         aCa8g42mCimRoaFQx0ZscI+NPzV6d0GkmfZPaesLX7jK2ViLGje0+EydrNf4tASbc9
         vEqErOSTYByNIJ5yxJyxFXfTdCAq/pbtrFSsVtUcl1/liApN27pM3518IGsX+hffQ8
         lCKDR9vH59tXYpWlOE+KKnChaB3xKWXYsQNC4JQCY2gPOlwBQ7DY4mAFlxhC7h9cN0
         LIWy7jOvfWBtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 38/39] signal: don't allow STOP on PF_IO_WORKER threads
Date:   Thu, 25 Mar 2021 07:25:57 -0400
Message-Id: <20210325112558.1927423-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
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
index 18ed1f853439..1d901a789812 100644
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

