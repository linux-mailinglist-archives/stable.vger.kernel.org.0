Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574CB46EB47
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 16:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbhLIPgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 10:36:01 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39954 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239670AbhLIPgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 10:36:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8144CE2686;
        Thu,  9 Dec 2021 15:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E23C341CB;
        Thu,  9 Dec 2021 15:32:24 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1mvLPD-000Sw4-8I;
        Thu, 09 Dec 2021 10:32:23 -0500
Message-ID: <20211209153223.096399871@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 09 Dec 2021 10:29:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yabin Cui <yabinc@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        stable@vger.kernel.org, Kalesh Singh <kaleshsingh@google.com>
Subject: [for-linus][PATCH 1/5] tracefs: Have new files inherit the ownership of their parent
References: <20211209152908.459494269@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If directories in tracefs have their ownership changed, then any new files
and directories that are created under those directories should inherit
the ownership of the director they are created in.

Link: https://lkml.kernel.org/r/20211208075720.4855d180@gandalf.local.home

Cc: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yabin Cui <yabinc@google.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: stable@vger.kernel.org
Fixes: 4282d60689d4f ("tracefs: Add new tracefs file system")
Reported-by: Kalesh Singh <kaleshsingh@google.com>
Reported: https://lore.kernel.org/all/CAC_TJve8MMAv+H_NdLSJXZUSoxOEq2zB_pVaJ9p=7H6Bu3X76g@mail.gmail.com/
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 fs/tracefs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 925a621b432e..06cf0534cc60 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -414,6 +414,8 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
 	inode->i_mode = mode;
 	inode->i_fop = fops ? fops : &tracefs_file_operations;
 	inode->i_private = data;
+	inode->i_uid = d_inode(dentry->d_parent)->i_uid;
+	inode->i_gid = d_inode(dentry->d_parent)->i_gid;
 	d_instantiate(dentry, inode);
 	fsnotify_create(dentry->d_parent->d_inode, dentry);
 	return end_creating(dentry);
@@ -436,6 +438,8 @@ static struct dentry *__create_dir(const char *name, struct dentry *parent,
 	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUSR| S_IRGRP | S_IXUSR | S_IXGRP;
 	inode->i_op = ops;
 	inode->i_fop = &simple_dir_operations;
+	inode->i_uid = d_inode(dentry->d_parent)->i_uid;
+	inode->i_gid = d_inode(dentry->d_parent)->i_gid;
 
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
-- 
2.33.0
