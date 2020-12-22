Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B561E2DA055
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502637AbgLNTHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:07:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408581AbgLNRhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:10 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 006/105] tools/bootconfig: Fix to check the write failure correctly
Date:   Mon, 14 Dec 2020 18:27:40 +0100
Message-Id: <20201214172555.591383855@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit a995e6bc0524450adfd6181dfdcd9d0520cfaba5 ]

Fix to check the write(2) failure including partial write
correctly and try to rollback the partial write, because
if there is no BOOTCONFIG_MAGIC string, we can not remove it.

Link: https://lkml.kernel.org/r/160576521135.320071.3883101436675969998.stgit@devnote2

Fixes: 85c46b78da58 ("bootconfig: Add bootconfig magic word for indicating bootconfig explicitly")
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/main.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index e0878f5f74b1b..ffd6a358925da 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -274,6 +274,7 @@ static void show_xbc_error(const char *data, const char *msg, int pos)
 
 int apply_xbc(const char *path, const char *xbc_path)
 {
+	struct stat stat;
 	u32 size, csum;
 	char *buf, *data;
 	int ret, fd;
@@ -330,16 +331,26 @@ int apply_xbc(const char *path, const char *xbc_path)
 		return fd;
 	}
 	/* TODO: Ensure the @path is initramfs/initrd image */
+	if (fstat(fd, &stat) < 0) {
+		pr_err("Failed to get the size of %s\n", path);
+		goto out;
+	}
 	ret = write(fd, data, size + 8);
-	if (ret < 0) {
+	if (ret < size + 8) {
+		if (ret < 0)
+			ret = -errno;
 		pr_err("Failed to apply a boot config: %d\n", ret);
-		goto out;
+		if (ret < 0)
+			goto out;
+		goto out_rollback;
 	}
 	/* Write a magic word of the bootconfig */
 	ret = write(fd, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN);
-	if (ret < 0) {
+	if (ret < BOOTCONFIG_MAGIC_LEN) {
+		if (ret < 0)
+			ret = -errno;
 		pr_err("Failed to apply a boot config magic: %d\n", ret);
-		goto out;
+		goto out_rollback;
 	}
 	ret = 0;
 out:
@@ -347,6 +358,17 @@ out:
 	free(data);
 
 	return ret;
+
+out_rollback:
+	/* Map the partial write to -ENOSPC */
+	if (ret >= 0)
+		ret = -ENOSPC;
+	if (ftruncate(fd, stat.st_size) < 0) {
+		ret = -errno;
+		pr_err("Failed to rollback the write error: %d\n", ret);
+		pr_err("The initrd %s may be corrupted. Recommend to rebuild.\n", path);
+	}
+	goto out;
 }
 
 int usage(void)
-- 
2.27.0



