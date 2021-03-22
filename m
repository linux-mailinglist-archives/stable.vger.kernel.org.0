Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6680234421A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhCVMip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231970AbhCVMhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:37:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8392A619B7;
        Mon, 22 Mar 2021 12:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416605;
        bh=CN3T1qOgsUHDlPVRDBZKauMw0TaEEfVloDUqbldJQeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKonxwT/vXOIqHAyEtz2GxS+Mk4Pn03LBcQM+7GiVcD8ir5yMt5sm4HDhigmDIdRl
         GFoJwolpmabpOuR6+2hGHKIR4ddPDep8PXZZ78qZV9kf2LLZaVEzyDYKKC1Uyo9W16
         hEUCzpJ9yk+5ADRpPGC7LrtSPoFKH5P710qJo8Js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+d0cf0ad6513e9a1da5df@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 050/157] pstore: Fix warning in pstore_kill_sb()
Date:   Mon, 22 Mar 2021 13:26:47 +0100
Message-Id: <20210322121935.332613653@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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


