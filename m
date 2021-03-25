Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02337348F3C
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhCYL0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhCYLZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54FD761A35;
        Thu, 25 Mar 2021 11:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671554;
        bh=Mm3ZFQ2BMZXi56HpLke80635/E7qUUP52zUhZntN/0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1gFMBn5MyHSb5PTB+2Pq71jJzdvB1SNK69wy6/3KrLPzVww09Rf3kfCHOapCKm8X
         UTorLDmtbEqW1aZzRaiPc0b0k8wvUyIMestUPnumqJet1PqjVuV1eyummBV9j5ujgF
         DrBflZGcDAoz889WedCHDiy2Umu8KrbtfMraKUkYJEJWQp6cDp+rKZN2WX6J6XUdZO
         2uf+zUSGqyZtRHFyz4ozFbWOvYA0nEs0ykXMmuWgLr3zCNwgNbfX+rFgNqZcGy6IFH
         JsK3YPmw7y6HV/FAqRVtr67zxTwxNIwLILSIL6+o/5Y7lTh1tRgrY9A9W28yKgSB5N
         /pRzxEdR2NcUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 42/44] signal: don't allow sending any signals to PF_IO_WORKER threads
Date:   Thu, 25 Mar 2021 07:24:57 -0400
Message-Id: <20210325112459.1926846-42-sashal@kernel.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 5be28c8f85ce99ed2d329d2ad8bdd18ea19473a5 ]

They don't take signals individually, and even if they share signals with
the parent task, don't allow them to be delivered through the worker
thread. Linux does allow this kind of behavior for regular threads, but
it's really a compatability thing that we need not care about for the IO
threads.

Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 5ad8566534e7..55526b941011 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -833,6 +833,9 @@ static int check_kill_permission(int sig, struct kernel_siginfo *info,
 
 	if (!valid_signal(sig))
 		return -EINVAL;
+	/* PF_IO_WORKER threads don't take any signals */
+	if (t->flags & PF_IO_WORKER)
+		return -ESRCH;
 
 	if (!si_fromuser(info))
 		return 0;
-- 
2.30.1

