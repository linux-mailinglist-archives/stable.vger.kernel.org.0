Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0D2FEF44
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbfKPP5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:57:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729433AbfKPPyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:54:33 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 377F820854;
        Sat, 16 Nov 2019 15:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919672;
        bh=ww/oRhqwCYwuB7+eq3xYbcJjFM5tGkRXV22rrkSL5+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKUc77HzMKycluJYfSYf6ceIQ0xdRKJnpRHJfnGNTK5dYQkGZbOmzPs10qim8aKqt
         0VlV6S3AV2gENd9WSm6NPzQyjNA0RKJ3JKf92b6VoqszOrVskKUICiki4BZdyBdlhn
         JCkGqXs4cYKK8ozEJiK3YMyVwGFObd/e1wOXv9Pw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <jiangqi903@gmail.com>,
        Changwei Ge <ge.changwei@h3c.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 41/77] fs/ocfs2/dlm/dlmdebug.c: fix a sleep-in-atomic-context bug in dlm_print_one_mle()
Date:   Sat, 16 Nov 2019 10:53:03 -0500
Message-Id: <20191116155339.11909-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155339.11909-1-sashal@kernel.org>
References: <20191116155339.11909-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 999865764f5f128896402572b439269acb471022 ]

The kernel module may sleep with holding a spinlock.

The function call paths (from bottom to top) in Linux-4.16 are:

[FUNC] get_zeroed_page(GFP_NOFS)
fs/ocfs2/dlm/dlmdebug.c, 332: get_zeroed_page in dlm_print_one_mle
fs/ocfs2/dlm/dlmmaster.c, 240: dlm_print_one_mle in __dlm_put_mle
fs/ocfs2/dlm/dlmmaster.c, 255: __dlm_put_mle in dlm_put_mle
fs/ocfs2/dlm/dlmmaster.c, 254: spin_lock in dlm_put_ml

[FUNC] get_zeroed_page(GFP_NOFS)
fs/ocfs2/dlm/dlmdebug.c, 332: get_zeroed_page in dlm_print_one_mle
fs/ocfs2/dlm/dlmmaster.c, 240: dlm_print_one_mle in __dlm_put_mle
fs/ocfs2/dlm/dlmmaster.c, 222: __dlm_put_mle in dlm_put_mle_inuse
fs/ocfs2/dlm/dlmmaster.c, 219: spin_lock in dlm_put_mle_inuse

To fix this bug, GFP_NOFS is replaced with GFP_ATOMIC.

This bug is found by my static analysis tool DSAC.

Link: http://lkml.kernel.org/r/20180901112528.27025-1-baijiaju1990@gmail.com
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlm/dlmdebug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 825136070d2c1..73eaccea09b98 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -329,7 +329,7 @@ void dlm_print_one_mle(struct dlm_master_list_entry *mle)
 {
 	char *buf;
 
-	buf = (char *) get_zeroed_page(GFP_NOFS);
+	buf = (char *) get_zeroed_page(GFP_ATOMIC);
 	if (buf) {
 		dump_mle(mle, buf, PAGE_SIZE - 1);
 		free_page((unsigned long)buf);
-- 
2.20.1

