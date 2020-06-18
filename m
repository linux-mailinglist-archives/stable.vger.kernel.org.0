Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F4F1FE116
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbgFRB0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730599AbgFRB0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:26:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 262C820B1F;
        Thu, 18 Jun 2020 01:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443602;
        bh=Xmp9h8I4G3YC2FTtCRXoSzOyc0t02HvCHHCQWkH0dYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gP33bUzZsNyDy9zUC9zIxg5HwnYOjgg5b8y+EYa+/9yyOoDiZBdIxEQAev0kzMoos
         Ev9UlZ6SaeQ6WWThGTuATcoqO3AAoKJ0VumzEmTfnuxM5tqLqj99kMnHwW3eFykc+q
         0HZuK0MU6r3Gt2QSSFO6Mer3/HDxhK18Qnu+HHXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        syzbot+6f1624f937d9d6911e2d@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 031/108] fat: don't allow to mount if the FAT length == 0
Date:   Wed, 17 Jun 2020 21:24:43 -0400
Message-Id: <20200618012600.608744-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

[ Upstream commit b1b65750b8db67834482f758fc385bfa7560d228 ]

If FAT length == 0, the image doesn't have any data. And it can be the
cause of overlapping the root dir and FAT entries.

Also Windows treats it as invalid format.

Reported-by: syzbot+6f1624f937d9d6911e2d@syzkaller.appspotmail.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Link: http://lkml.kernel.org/r/87r1wz8mrd.fsf@mail.parknet.co.jp
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 1df023c4c2cc..c41393e30a04 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1512,6 +1512,12 @@ static int fat_read_bpb(struct super_block *sb, struct fat_boot_sector *b,
 		goto out;
 	}
 
+	if (bpb->fat_fat_length == 0 && bpb->fat32_length == 0) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR, "bogus number of FAT sectors");
+		goto out;
+	}
+
 	error = 0;
 
 out:
-- 
2.25.1

