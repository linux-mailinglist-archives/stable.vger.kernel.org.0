Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2144528FCD
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346263AbiEPTya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346278AbiEPTxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:53:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E1B47042;
        Mon, 16 May 2022 12:48:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB528B81611;
        Mon, 16 May 2022 19:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C6DC385AA;
        Mon, 16 May 2022 19:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730531;
        bh=cuKichH73sDTAWETAXC1JTIM2p/rWmO8HVY3pasalVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYDRZiz5wvI1cq2IAIJLZ69ZqqdUOhcxa0tmhInI0+clkwSuqnRWbj9+zaVUfp09C
         n6gQPXF+53WE7Sl5rRa/mEb+siccTk8HxRWy9+bbdLe3mVpQtt1HIpBDMjzQNtzNk2
         IS3CBR1WhXpax9ZHbYOC9F0l2Vf9CsC0KcaMuBg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalesh Singh <kaleshsingh@google.com>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Hridya Valsaraju <hridya@google.com>,
        Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/102] procfs: prevent unprivileged processes accessing fdinfo dir
Date:   Mon, 16 May 2022 21:36:02 +0200
Message-Id: <20220516193624.808523501@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalesh Singh <kaleshsingh@google.com>

[ Upstream commit 1927e498aee1757b3df755a194cbfc5cc0f2b663 ]

The file permissions on the fdinfo dir from were changed from
S_IRUSR|S_IXUSR to S_IRUGO|S_IXUGO, and a PTRACE_MODE_READ check was added
for opening the fdinfo files [1].  However, the ptrace permission check
was not added to the directory, allowing anyone to get the open FD numbers
by reading the fdinfo directory.

Add the missing ptrace permission check for opening the fdinfo directory.

[1] https://lkml.kernel.org/r/20210308170651.919148-1-kaleshsingh@google.com

Link: https://lkml.kernel.org/r/20210713162008.1056986-1-kaleshsingh@google.com
Fixes: 7bc3fa0172a4 ("procfs: allow reading fdinfo with PTRACE_MODE_READ")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/fd.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 172c86270b31..913bef0d2a36 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -72,7 +72,7 @@ static int seq_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int seq_fdinfo_open(struct inode *inode, struct file *file)
+static int proc_fdinfo_access_allowed(struct inode *inode)
 {
 	bool allowed = false;
 	struct task_struct *task = get_proc_task(inode);
@@ -86,6 +86,16 @@ static int seq_fdinfo_open(struct inode *inode, struct file *file)
 	if (!allowed)
 		return -EACCES;
 
+	return 0;
+}
+
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
+{
+	int ret = proc_fdinfo_access_allowed(inode);
+
+	if (ret)
+		return ret;
+
 	return single_open(file, seq_show, inode);
 }
 
@@ -348,12 +358,23 @@ static int proc_readfdinfo(struct file *file, struct dir_context *ctx)
 				  proc_fdinfo_instantiate);
 }
 
+static int proc_open_fdinfo(struct inode *inode, struct file *file)
+{
+	int ret = proc_fdinfo_access_allowed(inode);
+
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 const struct inode_operations proc_fdinfo_inode_operations = {
 	.lookup		= proc_lookupfdinfo,
 	.setattr	= proc_setattr,
 };
 
 const struct file_operations proc_fdinfo_operations = {
+	.open		= proc_open_fdinfo,
 	.read		= generic_read_dir,
 	.iterate_shared	= proc_readfdinfo,
 	.llseek		= generic_file_llseek,
-- 
2.35.1



