Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C61DD26B
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389899AbfJRWKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389866AbfJRWKQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:10:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D6902246A;
        Fri, 18 Oct 2019 22:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436615;
        bh=3fIb/XpE5v/FmqlNuybYCPwnbwJAl3gVKkv+KO2OZGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRkrv16kbZL+EriiPxzY/u7XqnkIEJnb21xVwW3o/EHgRP6qt59TztKfCshpV/gxr
         qBHvtE6EzqNncSJMHR2ef3gA+NRsAOZ2VLW1vYzUZY5u9z4sQ7j1GojclXUZ0Taeab
         TukBqzIuRXSJfbSThXEL7TRTiI2BbYTFrWjfmc5I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Samuel Dionne-Riel <samuel@dionne-riel.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Graham Christensen <graham@grahamc.com>,
        Michal Hocko <mhocko@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 05/21] exec: load_script: Do not exec truncated interpreter path
Date:   Fri, 18 Oct 2019 18:09:51 -0400
Message-Id: <20191018221007.10851-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018221007.10851-1-sashal@kernel.org>
References: <20191018221007.10851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit b5372fe5dc84235dbe04998efdede3c4daa866a9 ]

Commit 8099b047ecc4 ("exec: load_script: don't blindly truncate
shebang string") was trying to protect against a confused exec of a
truncated interpreter path. However, it was overeager and also refused
to truncate arguments as well, which broke userspace, and it was
reverted. This attempts the protection again, but allows arguments to
remain truncated. In an effort to improve readability, helper functions
and comments have been added.

Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Samuel Dionne-Riel <samuel@dionne-riel.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Graham Christensen <graham@grahamc.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_script.c | 57 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 48 insertions(+), 9 deletions(-)

diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index afdf4e3cafc2a..37c2093a24d3c 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -14,14 +14,31 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 
+static inline bool spacetab(char c) { return c == ' ' || c == '\t'; }
+static inline char *next_non_spacetab(char *first, const char *last)
+{
+	for (; first <= last; first++)
+		if (!spacetab(*first))
+			return first;
+	return NULL;
+}
+static inline char *next_terminator(char *first, const char *last)
+{
+	for (; first <= last; first++)
+		if (spacetab(*first) || !*first)
+			return first;
+	return NULL;
+}
+
 static int load_script(struct linux_binprm *bprm)
 {
 	const char *i_arg, *i_name;
-	char *cp;
+	char *cp, *buf_end;
 	struct file *file;
 	char interp[BINPRM_BUF_SIZE];
 	int retval;
 
+	/* Not ours to exec if we don't start with "#!". */
 	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!'))
 		return -ENOEXEC;
 
@@ -34,18 +51,40 @@ static int load_script(struct linux_binprm *bprm)
 	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
 		return -ENOENT;
 
-	/*
-	 * This section does the #! interpretation.
-	 * Sorta complicated, but hopefully it will work.  -TYT
-	 */
-
+	/* Release since we are not mapping a binary into memory. */
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
 
-	bprm->buf[BINPRM_BUF_SIZE - 1] = '\0';
-	if ((cp = strchr(bprm->buf, '\n')) == NULL)
-		cp = bprm->buf+BINPRM_BUF_SIZE-1;
+	/*
+	 * This section handles parsing the #! line into separate
+	 * interpreter path and argument strings. We must be careful
+	 * because bprm->buf is not yet guaranteed to be NUL-terminated
+	 * (though the buffer will have trailing NUL padding when the
+	 * file size was smaller than the buffer size).
+	 *
+	 * We do not want to exec a truncated interpreter path, so either
+	 * we find a newline (which indicates nothing is truncated), or
+	 * we find a space/tab/NUL after the interpreter path (which
+	 * itself may be preceded by spaces/tabs). Truncating the
+	 * arguments is fine: the interpreter can re-read the script to
+	 * parse them on its own.
+	 */
+	buf_end = bprm->buf + sizeof(bprm->buf) - 1;
+	cp = strnchr(bprm->buf, sizeof(bprm->buf), '\n');
+	if (!cp) {
+		cp = next_non_spacetab(bprm->buf + 2, buf_end);
+		if (!cp)
+			return -ENOEXEC; /* Entire buf is spaces/tabs */
+		/*
+		 * If there is no later space/tab/NUL we must assume the
+		 * interpreter path is truncated.
+		 */
+		if (!next_terminator(cp, buf_end))
+			return -ENOEXEC;
+		cp = buf_end;
+	}
+	/* NUL-terminate the buffer and any trailing spaces/tabs. */
 	*cp = '\0';
 	while (cp > bprm->buf) {
 		cp--;
-- 
2.20.1

