Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C6033018A
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhCGN6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230495AbhCGN5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:57:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 092EE65104;
        Sun,  7 Mar 2021 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125469;
        bh=AmziC16prEcsebsq6nos7eFOfhYpjhikRBeNGvcAHSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbRd7oplMfBoypxPe4XrfKU/BiFQHqCJ4qduUfYP4CL+nl8o1hJHJRYNqGVHwJqve
         mky6FTGNMQBWUUJv3FgJdmzdxc2WRcAYpR/ti6Rk155F/zb9hnmWEpwcMweC3nLsa3
         NcEh/4lw8v0ijh5r92PyCfKACQrpuu8P6HTdFoKK/refxvCK3uSyN96P/Sa85mWM76
         hQyNRs/ntrql/jBX/q36r0fENbq6hm7lR4+BdZ41K13tHGlyFY84HQZHlmLBibLSvE
         zPXdhwvWc38tsrDVEYHlKlB+fSInZ/OFNpEizM0eLdzPMGfVu+xluncT6DlBx8Mr1m
         cic07fA9MHHWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+d0cf0ad6513e9a1da5df@syzkaller.appspotmail.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 02/12] pstore: Fix warning in pstore_kill_sb()
Date:   Sun,  7 Mar 2021 08:57:36 -0500
Message-Id: <20210307135746.967418-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135746.967418-1-sashal@kernel.org>
References: <20210307135746.967418-1-sashal@kernel.org>
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
index 93a217e4f563..14658b009f1b 100644
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

