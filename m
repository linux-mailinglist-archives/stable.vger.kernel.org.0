Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2385C1CCF38
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 03:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgEKBja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 21:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgEKBja (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 May 2020 21:39:30 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 471B7207FF;
        Mon, 11 May 2020 01:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589161169;
        bh=am+eWUmxcP2bsJRpLx1IxtNAzjyf4uJ9CE9NU9+VV4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmV1Z+9JgrDcuGQn+nqAAmFqyrfQeO6QedzQFdRWaCJKzBK4qEHXvKpwR8JZ840Uy
         QHuXZ1Hsu2RUFvcRooYjpDKPLaj/wEFL8JH9uiecxsgrijQnxnLKWpeZl19GrJ91dL
         e8QksDoJXwyTGoSge+Joitn+dCbwjBlLUu/3qKn0=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] bootconfig: Fix to prevent warning message if no bootconfig option
Date:   Mon, 11 May 2020 10:39:24 +0900
Message-Id: <158916116468.21787.14558782332170588206.stgit@devnote2>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200511095728.8490ad9e3d5a25e7400a4910@kernel.org>
References: <20200511095728.8490ad9e3d5a25e7400a4910@kernel.org>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit de462e5f1071 ("bootconfig: Fix to remove bootconfig
data from initrd while boot") causes a cosmetic regression
on dmesg, which warns "no bootconfig data" message without
bootconfig cmdline option.

Fix setup_boot_config() by moving no bootconfig check after
commandline option check.

Fixes: de462e5f1071 ("bootconfig: Fix to remove bootconfig data from initrd while boot")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 init/main.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/init/main.c b/init/main.c
index 1a5da2c2660c..5803ecb411ab 100644
--- a/init/main.c
+++ b/init/main.c
@@ -400,9 +400,8 @@ static void __init setup_boot_config(const char *cmdline)
 	char *data, *copy;
 	int ret;
 
+	/* Cut out the bootconfig data even if we have no bootconfig option */
 	data = get_boot_config_from_initrd(&size, &csum);
-	if (!data)
-		goto not_found;
 
 	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 	parse_args("bootconfig", tmp_cmdline, NULL, 0, 0, 0, NULL,
@@ -411,6 +410,11 @@ static void __init setup_boot_config(const char *cmdline)
 	if (!bootconfig_found)
 		return;
 
+	if (!data) {
+		pr_err("'bootconfig' found on command line, but no bootconfig found\n");
+		return;
+	}
+
 	if (size >= XBC_DATA_MAX) {
 		pr_err("bootconfig size %d greater than max size %d\n",
 			size, XBC_DATA_MAX);
@@ -446,8 +450,6 @@ static void __init setup_boot_config(const char *cmdline)
 		extra_init_args = xbc_make_cmdline("init");
 	}
 	return;
-not_found:
-	pr_err("'bootconfig' found on command line, but no bootconfig found\n");
 }
 
 #else

