Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8309B44A239
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242013AbhKIBQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242927AbhKIBOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:14:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC11361ACD;
        Tue,  9 Nov 2021 01:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419960;
        bh=suNn8fVeIUkpbGLrmxzqa1sCqoAgOTuzj/cjaC+epYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmwferQovib+OZf22OkdS8w2HCZP9ir910/iw7WHFESXCSb7o5rBTLs+4twV9isKw
         k6gEpvxbUuenfMrg4rmN02BNp1BY8mfdZpf24agr6rsEml5/CczpfTPjJidXyTeQOJ
         Xq43gEGQhMWjBiMff5Msjq0bBYtyc78EABZRrR4Jjn7aRdRiJqjYQUowZA7Qu2wiRw
         B4A70+pORlZI1MzyoTDqnZdMgqEKL8Br/KzqG1uai/lV6RBV6pNC+1nJv5pd78Jfrt
         kqKn4zgH9/CqnSabngmJmllvIJGdf5qBppSDJrro1Um8QO6DHbdli3Bz5FnlXV3Xqu
         vYCSKi9GnTzrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 4.19 25/47] tracefs: Have tracefs directories not set OTH permission bits by default
Date:   Mon,  8 Nov 2021 12:50:09 -0500
Message-Id: <20211108175031.1190422-25-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[ Upstream commit 49d67e445742bbcb03106b735b2ab39f6e5c56bc ]

The tracefs file system is by default mounted such that only root user can
access it. But there are legitimate reasons to create a group and allow
those added to the group to have access to tracing. By changing the
permissions of the tracefs mount point to allow access, it will allow
group access to the tracefs directory.

There should not be any real reason to allow all access to the tracefs
directory as it contains sensitive information. Have the default
permission of directories being created not have any OTH (other) bits set,
such that an admin that wants to give permission to a group has to first
disable all OTH bits in the file system.

Link: https://lkml.kernel.org/r/20210818153038.664127804@goodmis.org

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 7098c49f36934..990f794b1dd0a 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -427,7 +427,8 @@ static struct dentry *__create_dir(const char *name, struct dentry *parent,
 	if (unlikely(!inode))
 		return failed_creating(dentry);
 
-	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
+	/* Do not set bits for OTH */
+	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUSR| S_IRGRP | S_IXUSR | S_IXGRP;
 	inode->i_op = ops;
 	inode->i_fop = &simple_dir_operations;
 
-- 
2.33.0

