Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25902283A80
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgJEPez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727724AbgJEPek (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:34:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D99DA2074F;
        Mon,  5 Oct 2020 15:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912079;
        bh=6Ik8m9Fwk55yU+5dO5ocp1Vp8J3IiDZkfJYrwgmjAhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZcSOuhILzhzJxxPLJncvAM/Jc+peX1E+ZMyaVJzVdw4HJad6WC8xYRk8WJGVnApj
         SMB4rQYoWuQNDy7YnSspCo9naRyP5Ujm7bx5iL3qF0HLvavRfIGLqtibAedV5H89OM
         mAmaBVIHdyEj5YLqsliMD+BnIkxjL9ETKkEip6qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Acked-by: Ian Kent" <raven@themaw.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 71/85] autofs: use __kernel_write() for the autofs pipe writing
Date:   Mon,  5 Oct 2020 17:27:07 +0200
Message-Id: <20201005142118.147243790@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 90fb702791bf99b959006972e8ee7bb4609f441b ]

autofs got broken in some configurations by commit 13c164b1a186
("autofs: switch to kernel_write") because there is now an extra LSM
permission check done by security_file_permission() in rw_verify_area().

autofs is one if the few places that really does want the much more
limited __kernel_write(), because the write is an internal kernel one
that shouldn't do any user permission checks (it also doesn't need the
file_start_write/file_end_write logic, since it's just a pipe).

There are a couple of other cases like that - accounting, core dumping,
and splice - but autofs stands out because it can be built as a module.

As a result, we need to export this internal __kernel_write() function
again.

We really don't want any other module to use this, but we don't have a
"EXPORT_SYMBOL_FOR_AUTOFS_ONLY()".  But we can mark it GPL-only to at
least approximate that "internal use only" for licensing.

While in this area, make autofs pass in NULL for the file position
pointer, since it's always a pipe, and we now use a NULL file pointer
for streaming file descriptors (see file_ppos() and commit 438ab720c675:
"vfs: pass ppos=NULL to .read()/.write() of FMODE_STREAM files")

This effectively reverts commits 9db977522449 ("fs: unexport
__kernel_write") and 13c164b1a186 ("autofs: switch to kernel_write").

Fixes: 13c164b1a186 ("autofs: switch to kernel_write")
Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Acked-by: Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/autofs/waitq.c | 2 +-
 fs/read_write.c   | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/autofs/waitq.c b/fs/autofs/waitq.c
index 74c886f7c51cb..5ced859dac539 100644
--- a/fs/autofs/waitq.c
+++ b/fs/autofs/waitq.c
@@ -53,7 +53,7 @@ static int autofs_write(struct autofs_sb_info *sbi,
 
 	mutex_lock(&sbi->pipe_mutex);
 	while (bytes) {
-		wr = kernel_write(file, data, bytes, &file->f_pos);
+		wr = __kernel_write(file, data, bytes, NULL);
 		if (wr <= 0)
 			break;
 		data += wr;
diff --git a/fs/read_write.c b/fs/read_write.c
index 4fb797822567a..9a5cb9c2f0d46 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -538,6 +538,14 @@ ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t
 	inc_syscw(current);
 	return ret;
 }
+/*
+ * This "EXPORT_SYMBOL_GPL()" is more of a "EXPORT_SYMBOL_DONTUSE()",
+ * but autofs is one of the few internal kernel users that actually
+ * wants this _and_ can be built as a module. So we need to export
+ * this symbol for autofs, even though it really isn't appropriate
+ * for any other kernel modules.
+ */
+EXPORT_SYMBOL_GPL(__kernel_write);
 
 ssize_t kernel_write(struct file *file, const void *buf, size_t count,
 			    loff_t *pos)
-- 
2.25.1



