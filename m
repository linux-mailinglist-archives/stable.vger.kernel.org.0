Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDF04725B4
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbhLMJph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:45:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56148 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbhLMJnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:43:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FD23B80E1D;
        Mon, 13 Dec 2021 09:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518A1C341CB;
        Mon, 13 Dec 2021 09:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388613;
        bh=0p9XQmV2M3kviX6dwt5IIWXClwuY2DBSaPF/Pjv+fGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+9f0ZA3G91ocn2ZsIThFJVFQwSfl2oNhmx1pgPrTu8gdJ9eZgwdwR5rC6sYeLd5a
         Li16EnUCWS+HJG4+c0Sf6ITxRYFDJs+7zM4q80FYy07m+XInkWVVczmTOiMuRWP7LO
         D+U1LyEgza1ti2jplT5/1yIp2BEc0D4MKC4q8rzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Yabin Cui <yabinc@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 36/88] tracefs: Have new files inherit the ownership of their parent
Date:   Mon, 13 Dec 2021 10:30:06 +0100
Message-Id: <20211213092934.488919536@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit ee7f3666995d8537dec17b1d35425f28877671a9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -409,6 +409,8 @@ struct dentry *tracefs_create_file(const
 	inode->i_mode = mode;
 	inode->i_fop = fops ? fops : &tracefs_file_operations;
 	inode->i_private = data;
+	inode->i_uid = d_inode(dentry->d_parent)->i_uid;
+	inode->i_gid = d_inode(dentry->d_parent)->i_gid;
 	d_instantiate(dentry, inode);
 	fsnotify_create(dentry->d_parent->d_inode, dentry);
 	return end_creating(dentry);
@@ -431,6 +433,8 @@ static struct dentry *__create_dir(const
 	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUSR| S_IRGRP | S_IXUSR | S_IXGRP;
 	inode->i_op = ops;
 	inode->i_fop = &simple_dir_operations;
+	inode->i_uid = d_inode(dentry->d_parent)->i_uid;
+	inode->i_gid = d_inode(dentry->d_parent)->i_gid;
 
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);


