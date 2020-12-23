Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E396A2E1E43
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbgLWPfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbgLWPe1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87C33233FA;
        Wed, 23 Dec 2020 15:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737641;
        bh=UHaC3CS9rEOWkoBcqO2PlFtmvds4zpdPZzHtdQjvbLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzKaI8ci12YPKJ/wh8VJwcAi6aaMpfGHb8ZUpeV4+jJJAKm/GKJnsoOif5f1ZAJWk
         pMMzdS1ptnyOe42XdlX/2gaMYluAs8cVva9LlgEYmss4bJm6s1A9b0cYB96Uf5VOpA
         H+7NNnnzg2Rq+l2wxOQt5CBZ3oL7KTPWSb4ixZDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2643e825238d7aabb37f@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 36/40] fs: quota: fix array-index-out-of-bounds bug by passing correct argument to vfs_cleanup_quota_inode()
Date:   Wed, 23 Dec 2020 16:33:37 +0100
Message-Id: <20201223150517.275754032@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

commit e51d68e76d604c6d5d1eb13ae1d6da7f6c8c0dfc upstream.

When dquot_resume() was last updated, the argument that got passed
to vfs_cleanup_quota_inode was incorrectly set.

If type = -1 and dquot_load_quota_sb() returns a negative value,
then vfs_cleanup_quota_inode() gets called with -1 passed as an
argument, and this leads to an array-index-out-of-bounds bug.

Fix this issue by correctly passing the arguments.

Fixes: ae45f07d47cc ("quota: Simplify dquot_resume()")
Link: https://lore.kernel.org/r/20201208194338.7064-1-anant.thazhemadam@gmail.com
Reported-by: syzbot+2643e825238d7aabb37f@syzkaller.appspotmail.com
Tested-by: syzbot+2643e825238d7aabb37f@syzkaller.appspotmail.com
CC: stable@vger.kernel.org
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/quota/dquot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2455,7 +2455,7 @@ int dquot_resume(struct super_block *sb,
 		ret = dquot_load_quota_sb(sb, cnt, dqopt->info[cnt].dqi_fmt_id,
 					  flags);
 		if (ret < 0)
-			vfs_cleanup_quota_inode(sb, type);
+			vfs_cleanup_quota_inode(sb, cnt);
 	}
 
 	return ret;


