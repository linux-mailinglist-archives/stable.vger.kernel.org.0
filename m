Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3480D1F2E54
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgFHXMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729149AbgFHXMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE75620C09;
        Mon,  8 Jun 2020 23:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657954;
        bh=nppkGNsgd8sT4knkdEAZDk058TvFrYu7+dw5e2lghy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P24vqFSG/WfAilz2gceX1IdeT1TaSjpYVx4l4ufBQqxOW7wEexUL5dw8zVuCi5S7D
         e4uiE7nCL1YXKmKvI6KyJSD/n8loPvnttKsGJHQcV02uLI5uymcQ16R33v+jY5lh6H
         dnwrKV71UXIXWK/53sLBV4QoFPFFHDHLw8StGmMs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 5.6 019/606] bootconfig: Fix to prevent warning message if no bootconfig option
Date:   Mon,  8 Jun 2020 19:02:24 -0400
Message-Id: <20200608231211.3363633-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 611d0a95d46b0977a530b4d538948c69d447b001 upstream.

Commit de462e5f1071 ("bootconfig: Fix to remove bootconfig
data from initrd while boot") causes a cosmetic regression
on dmesg, which warns "no bootconfig data" message without
bootconfig cmdline option.

Fix setup_boot_config() by moving no bootconfig check after
commandline option check.

Link: http://lkml.kernel.org/r/9b1ba335-071d-c983-89a4-2677b522dcc8@molgen.mpg.de
Link: http://lkml.kernel.org/r/158916116468.21787.14558782332170588206.stgit@devnote2

Fixes: de462e5f1071 ("bootconfig: Fix to remove bootconfig data from initrd while boot")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/init/main.c b/init/main.c
index ee0345e7e9f1..8ee04f875b21 100644
--- a/init/main.c
+++ b/init/main.c
@@ -398,9 +398,8 @@ static void __init setup_boot_config(const char *cmdline)
 	char *data, *copy;
 	int ret;
 
+	/* Cut out the bootconfig data even if we have no bootconfig option */
 	data = get_boot_config_from_initrd(&size, &csum);
-	if (!data)
-		goto not_found;
 
 	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 	parse_args("bootconfig", tmp_cmdline, NULL, 0, 0, 0, NULL,
@@ -409,6 +408,11 @@ static void __init setup_boot_config(const char *cmdline)
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
@@ -440,8 +444,6 @@ static void __init setup_boot_config(const char *cmdline)
 		extra_init_args = xbc_make_cmdline("init");
 	}
 	return;
-not_found:
-	pr_err("'bootconfig' found on command line, but no bootconfig found\n");
 }
 
 #else
-- 
2.25.1

