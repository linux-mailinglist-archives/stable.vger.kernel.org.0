Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA8F34414E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhCVMcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230133AbhCVMbq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C921E61990;
        Mon, 22 Mar 2021 12:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416306;
        bh=CN3T1qOgsUHDlPVRDBZKauMw0TaEEfVloDUqbldJQeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdT8N30orHqRFPNRdLskVp3AV0jrfRfM3tZte+ntfMzF2r74cdvWuZRXwzzpAl/nX
         nSvoj+TaU3E6KyRg/uzB6qPrFN4hnzrlgWYV4SY7DCeIiGqwdPnglLKcZzJgY4PJRP
         nuEl4pj1qd5v1A/nd3SyrIs2CfRG5oJvBI9UD9XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+d0cf0ad6513e9a1da5df@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.11 056/120] pstore: Fix warning in pstore_kill_sb()
Date:   Mon, 22 Mar 2021 13:27:19 +0100
Message-Id: <20210322121931.548616001@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 9c7d83ae6ba67d6c6199cce24573983db3b56332 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pstore/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -467,7 +467,7 @@ static struct dentry *pstore_mount(struc
 static void pstore_kill_sb(struct super_block *sb)
 {
 	mutex_lock(&pstore_sb_lock);
-	WARN_ON(pstore_sb != sb);
+	WARN_ON(pstore_sb && pstore_sb != sb);
 
 	kill_litter_super(sb);
 	pstore_sb = NULL;


