Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF5E3A6353
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhFNLL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235373AbhFNLJu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:09:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D1DD61937;
        Mon, 14 Jun 2021 10:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667619;
        bh=DLMDT5yoIuHLalTf6IHs2wLH3wn7191t57D5C0gPIfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXJWymRGSiWDeIRo9UxXZ89mhDfmUl3QinxY1d72o5duMjfyoo8XP5VKEZtW/tICs
         LGZTen52+8zWgweNKs49G6yUsoB3wpHVPue7U/FjzUBtDoip9uhJX0F5sTRt8LoO6G
         IXIx8JOw+yl8Vkn95llhfOhsbLpV9Of3lTPAZhHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 001/173] proc: Track /proc/$pid/attr/ opener mm_struct
Date:   Mon, 14 Jun 2021 12:25:33 +0200
Message-Id: <20210614102658.191142450@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 591a22c14d3f45cc38bd1931c593c221df2f1881 upstream.

Commit bfb819ea20ce ("proc: Check /proc/$pid/attr/ writes against file opener")
tried to make sure that there could not be a confusion between the opener of
a /proc/$pid/attr/ file and the writer. It used struct cred to make sure
the privileges didn't change. However, there were existing cases where a more
privileged thread was passing the opened fd to a differently privileged thread
(during container setup). Instead, use mm_struct to track whether the opener
and writer are still the same process. (This is what several other proc files
already do, though for different reasons.)

Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
Reported-by: Andrea Righi <andrea.righi@canonical.com>
Tested-by: Andrea Righi <andrea.righi@canonical.com>
Fixes: bfb819ea20ce ("proc: Check /proc/$pid/attr/ writes against file opener")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/base.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2674,6 +2674,11 @@ out:
 }
 
 #ifdef CONFIG_SECURITY
+static int proc_pid_attr_open(struct inode *inode, struct file *file)
+{
+	return __mem_open(inode, file, PTRACE_MODE_READ_FSCREDS);
+}
+
 static ssize_t proc_pid_attr_read(struct file * file, char __user * buf,
 				  size_t count, loff_t *ppos)
 {
@@ -2704,7 +2709,7 @@ static ssize_t proc_pid_attr_write(struc
 	int rv;
 
 	/* A task may only write when it was the opener. */
-	if (file->f_cred != current_real_cred())
+	if (file->private_data != current->mm)
 		return -EPERM;
 
 	rcu_read_lock();
@@ -2754,9 +2759,11 @@ out:
 }
 
 static const struct file_operations proc_pid_attr_operations = {
+	.open		= proc_pid_attr_open,
 	.read		= proc_pid_attr_read,
 	.write		= proc_pid_attr_write,
 	.llseek		= generic_file_llseek,
+	.release	= mem_release,
 };
 
 #define LSM_DIR_OPS(LSM) \


