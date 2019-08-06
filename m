Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33BD883C8D
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfHFVeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:34:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbfHFVeI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:34:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5084B217D7;
        Tue,  6 Aug 2019 21:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127247;
        bh=1dnYI/3MT890Qsd/tNhEdkKwlKhwvfGuHH4UYCwVyWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlFvwqll7qCvgevWuJ7iUlOzZhZcnx0sRwDa41DD5hlPkemInjXqqLZ9sY6UExdg9
         ag8Qr+rMW8pi8GYrodVBpJtGchNC/kZ76vgLe52PBqZywx1to7ExukdSb32mJ2KzDC
         KMbP/a7Mpt/f1TQVznxyN59TR/0lgF+K3NBGWSDw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Brauner <christian@brauner.io>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 27/59] exit: make setting exit_state consistent
Date:   Tue,  6 Aug 2019 17:32:47 -0400
Message-Id: <20190806213319.19203-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian@brauner.io>

[ Upstream commit 30b692d3b390c6fe78a5064be0c4bbd44a41be59 ]

Since commit b191d6491be6 ("pidfd: fix a poll race when setting exit_state")
we unconditionally set exit_state to EXIT_ZOMBIE before calling into
do_notify_parent(). This was done to eliminate a race when querying
exit_state in do_notify_pidfd().
Back then we decided to do the absolute minimal thing to fix this and
not touch the rest of the exit_notify() function where exit_state is
set.
Since this fix has not caused any issues change the setting of
exit_state to EXIT_DEAD in the autoreap case to account for the fact hat
exit_state is set to EXIT_ZOMBIE unconditionally. This fix was planned
but also explicitly requested in [1] and makes the whole code more
consistent.

/* References */
[1]: https://lore.kernel.org/lkml/CAHk-=wigcxGFR2szue4wavJtH5cYTTeNES=toUBVGsmX0rzX+g@mail.gmail.com

Signed-off-by: Christian Brauner <christian@brauner.io>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/exit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index a75b6a7f458a7..0922e84ba6c1f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -733,9 +733,10 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 		autoreap = true;
 	}
 
-	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
-	if (tsk->exit_state == EXIT_DEAD)
+	if (autoreap) {
+		tsk->exit_state = EXIT_DEAD;
 		list_add(&tsk->ptrace_entry, &dead);
+	}
 
 	/* mt-exec, de_thread() is waiting for group leader */
 	if (unlikely(tsk->signal->notify_count < 0))
-- 
2.20.1

