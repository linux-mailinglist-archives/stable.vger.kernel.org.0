Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB27472971
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242547AbhLMKUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242381AbhLMKSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:18:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88893C08EE18;
        Mon, 13 Dec 2021 01:56:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0CA3ACE0E82;
        Mon, 13 Dec 2021 09:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972FFC34600;
        Mon, 13 Dec 2021 09:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389398;
        bh=Zg8X3xFvtIRn8bz/MNvF/3kFTKOoHhnAM88W8vZQ7QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0ObX2D0FQZVoRoKcag6OgEPta8BdY4Y6KFAHUWDzyYDWEWXYjkCtzhvdwA2xvwmq
         bi60mp1AGQD4X82wwAFhBqzHoG5mnt6gmp5fNh/2OcqZ74rbnTsyrSovBtgvtsZ/eR
         pCTwI9OPlHXyNmwlXhOiDJB9M+wxjh6B+g9dw768=
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
Subject: [PATCH 5.15 086/171] tracefs: Have new files inherit the ownership of their parent
Date:   Mon, 13 Dec 2021 10:30:01 +0100
Message-Id: <20211213092947.947222280@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -414,6 +414,8 @@ struct dentry *tracefs_create_file(const
 	inode->i_mode = mode;
 	inode->i_fop = fops ? fops : &tracefs_file_operations;
 	inode->i_private = data;
+	inode->i_uid = d_inode(dentry->d_parent)->i_uid;
+	inode->i_gid = d_inode(dentry->d_parent)->i_gid;
 	d_instantiate(dentry, inode);
 	fsnotify_create(dentry->d_parent->d_inode, dentry);
 	return end_creating(dentry);
@@ -436,6 +438,8 @@ static struct dentry *__create_dir(const
 	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUSR| S_IRGRP | S_IXUSR | S_IXGRP;
 	inode->i_op = ops;
 	inode->i_fop = &simple_dir_operations;
+	inode->i_uid = d_inode(dentry->d_parent)->i_uid;
+	inode->i_gid = d_inode(dentry->d_parent)->i_gid;
 
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);


