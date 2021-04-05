Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BDF353F7A
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239163AbhDEJMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239144AbhDEJMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D81B61398;
        Mon,  5 Apr 2021 09:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613932;
        bh=5lkXy9QAJUzflm//ImAiJZsaODEjkF9zLcTFNlU8a1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4FqHtNKzj1bZlpkBpmBf3487EttmGFhU8yktDICBvlGto4WIqdkP/ZEzCRB0ngKZ
         6xq/qBgXR6UlzlVNw0EJji9fV6h6wsKEfx/RmMsIPLeAq3SkGEYgVr/fLEI575ZkVM
         8LaOg8NnDRC1V0GUWZczE9h6XXQzMXdfXlo7lgbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 020/152] kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing
Date:   Mon,  5 Apr 2021 10:52:49 +0200
Message-Id: <20210405085034.898718602@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 15b2219facadec583c24523eed40fa45865f859f ]

Don't send fake signals to PF_IO_WORKER threads, they don't accept
signals. Just treat them like kthreads in this regard, all they need
is a wakeup as no forced kernel/user transition is needed.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/freezer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index dc520f01f99d..1a2d57d1327c 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -134,7 +134,7 @@ bool freeze_task(struct task_struct *p)
 		return false;
 	}
 
-	if (!(p->flags & PF_KTHREAD))
+	if (!(p->flags & (PF_KTHREAD | PF_IO_WORKER)))
 		fake_signal_wake_up(p);
 	else
 		wake_up_state(p, TASK_INTERRUPTIBLE);
-- 
2.30.1



