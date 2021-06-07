Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9ED39E26D
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhFGQQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232170AbhFGQPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD5326144A;
        Mon,  7 Jun 2021 16:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082418;
        bh=vFujPZe8KpAnuSc1WlBKaNJ1ZOKTml1g6cNa9OjYPJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMhSUb6RzGmRvC2LqDtaxHRHf7WnzO5hKK0TjyM2+dTJUlCrEUdn6LP4swqUjC7Bz
         o6gtlH6zQQ8dTk6tbaL8rVTJpjtHfULwzEdeZhBEbs8BxPVeHWxjInJMohK6kfCmLz
         x1b6q14m1iIaWuLYcLqSGPg2S7WsmpGQ2CjFRfCk3WryFKnjsMu9LSjqRiRz8FALyj
         FHwMlimq9RR1WhItWMa5r7T1U4WdxVMnghdXIrmKBVkGitWfbwuoCQ+xf/8tzNK3aB
         /w11gU6fm5yp0AMme6GTKBD92IzjJqM+zBh4VH+pQ748pFNuEl0jaaqcOI40y6vWj0
         NKd8ES8V0+gbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 15/39] gfs2: Prevent direct-I/O write fallback errors from getting lost
Date:   Mon,  7 Jun 2021 12:12:54 -0400
Message-Id: <20210607161318.3583636-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 43a511c44e58e357a687d61a20cf5ef1dc9e5a7c ]

When a direct I/O write falls entirely and falls back to buffered I/O and the
buffered I/O fails, the write failed with return value 0 instead of the error
number reported by the buffered I/O. Fix that.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index b39b339feddc..16fb0184ce5e 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -938,8 +938,11 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		current->backing_dev_info = inode_to_bdi(inode);
 		buffered = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
 		current->backing_dev_info = NULL;
-		if (unlikely(buffered <= 0))
+		if (unlikely(buffered <= 0)) {
+			if (!ret)
+				ret = buffered;
 			goto out_unlock;
+		}
 
 		/*
 		 * We need to ensure that the page cache pages are written to
-- 
2.30.2

