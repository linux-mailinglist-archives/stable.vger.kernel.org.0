Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8711E330192
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhCGN6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231537AbhCGN6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:58:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA77C65100;
        Sun,  7 Mar 2021 13:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125483;
        bh=cpUNuJh8DZ8gVzkLCPsLY72g8GnTW8V/qoJBz6CEgdg=;
        h=From:To:Cc:Subject:Date:From;
        b=JYRN1RvwtTgb8hgcvl8gqeUDiT/wDCDOBxI5vo2TohPFxfoLdMB5ZevfCG9uMduMS
         SshhVA7LNN3KXvTl/4YouRXcaPr5TCj7h9h/AiVdTcnK7/vSVQ7rCByUl66VUaBWL6
         +yWcTlg/zO/0D0ZZV/5nZGhSGVu4IeuKfLY7wVGY0maxRZdr1muLB8XPvNtTyQPTA+
         Or+kqXns15DXyv89yEnYOZ9q/cBQx42YjjY45lJOoQrLJbFizJ3l5B1VatUtAuEtrD
         bnFxvDVIqIoEayEyng9eWHG5Fg9JsA1MvVr6BZeX9EECr64LOHJzxXxJfh7aCYKpJ7
         VYLZdO14NSh3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+d0cf0ad6513e9a1da5df@syzkaller.appspotmail.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 1/8] pstore: Fix warning in pstore_kill_sb()
Date:   Sun,  7 Mar 2021 08:57:54 -0500
Message-Id: <20210307135801.967583-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 9c7d83ae6ba67d6c6199cce24573983db3b56332 ]

syzbot is hitting WARN_ON(pstore_sb != sb) at pstore_kill_sb() [1], for the
assumption that pstore_sb != NULL is wrong because pstore_fill_super() will
not assign pstore_sb = sb when new_inode() for d_make_root() returned NULL
(due to memory allocation fault injection).

Since mount_single() calls pstore_kill_sb() when pstore_fill_super()
failed, pstore_kill_sb() needs to be aware of such failure path.

[1] https://syzkaller.appspot.com/bug?id=6abacb8da5137cb47a416f2bef95719ed60508a0

Reported-by: syzbot <syzbot+d0cf0ad6513e9a1da5df@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210214031307.57903-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index c331efe8de95..bbf241a431f2 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -467,7 +467,7 @@ static struct dentry *pstore_mount(struct file_system_type *fs_type,
 static void pstore_kill_sb(struct super_block *sb)
 {
 	mutex_lock(&pstore_sb_lock);
-	WARN_ON(pstore_sb != sb);
+	WARN_ON(pstore_sb && pstore_sb != sb);
 
 	kill_litter_super(sb);
 	pstore_sb = NULL;
-- 
2.30.1

