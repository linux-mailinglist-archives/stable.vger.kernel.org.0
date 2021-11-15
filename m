Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5EA4513AA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348598AbhKOTyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343796AbhKOTWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E46635E5;
        Mon, 15 Nov 2021 18:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001985;
        bh=0oNsBUU3kljeFYbE87L3PM2wv2F72C/ERb29oBTfUTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Es+FfB9TT9mWgE2sL04UQTwXW5bYVkP0Pe5VlQl1MDUCNl6BV4ghjyfMumhkxbHqN
         oOXuk0qH2WMolQtNYnZGLO+30Vc4Tv4eVkRTc2EnCKg3yR6CRHfuEW0WPC5Vb44pyc
         Olg2jSUpOGonkvskYwQcEBZzzSnAWOKZxyV8vXG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Punit Agrawal <punitagrawal@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 396/917] kprobes: Do not use local variable when creating debugfs file
Date:   Mon, 15 Nov 2021 17:58:11 +0100
Message-Id: <20211115165442.204682891@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Punit Agrawal <punitagrawal@gmail.com>

[ Upstream commit 8f7262cd66699a4b02eb7549b35c81b2116aad95 ]

debugfs_create_file() takes a pointer argument that can be used during
file operation callbacks (accessible via i_private in the inode
structure). An obvious requirement is for the pointer to refer to
valid memory when used.

When creating the debugfs file to dynamically enable / disable
kprobes, a pointer to local variable is passed to
debugfs_create_file(); which will go out of scope when the init
function returns. The reason this hasn't triggered random memory
corruption is because the pointer is not accessed during the debugfs
file callbacks.

Since the enabled state is managed by the kprobes_all_disabled global
variable, the local variable is not needed. Fix the incorrect (and
unnecessary) usage of local variable during debugfs_file_create() by
passing NULL instead.

Link: https://lkml.kernel.org/r/163163031686.489837.4476867635937014973.stgit@devnote2

Fixes: bf8f6e5b3e51 ("Kprobes: The ON/OFF knob thru debugfs")
Signed-off-by: Punit Agrawal <punitagrawal@gmail.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 790a573bbe00c..1cf8bca1ea861 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2809,13 +2809,12 @@ static const struct file_operations fops_kp = {
 static int __init debugfs_kprobe_init(void)
 {
 	struct dentry *dir;
-	unsigned int value = 1;
 
 	dir = debugfs_create_dir("kprobes", NULL);
 
 	debugfs_create_file("list", 0400, dir, NULL, &kprobes_fops);
 
-	debugfs_create_file("enabled", 0600, dir, &value, &fops_kp);
+	debugfs_create_file("enabled", 0600, dir, NULL, &fops_kp);
 
 	debugfs_create_file("blacklist", 0400, dir, NULL,
 			    &kprobe_blacklist_fops);
-- 
2.33.0



