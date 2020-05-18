Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28F01D8446
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732904AbgERSFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732391AbgERSFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:05:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3613420853;
        Mon, 18 May 2020 18:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825112;
        bh=09n0LPrMQrdBJRI41KV3ZpJcp4wImuhEc6SnU+Jd4Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COq0heGyzv84HWipTlMP1L3QzsjBRjqIpiU6RRYiL0V9Qh3uHUC7d8WWKMStydtPO
         prWTdDzJkctYZGCCt/paBtnAoAtI0D1pwPMP8AevvuYcfZn8ZhDn46Z5i6PvrhnWuJ
         tDbieAGJ241At71mIPohIZO035+H486ue71RtWfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.6 135/194] bootconfig: Fix to prevent warning message if no bootconfig option
Date:   Mon, 18 May 2020 19:37:05 +0200
Message-Id: <20200518173542.650801501@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 init/main.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -398,9 +398,8 @@ static void __init setup_boot_config(con
 	char *data, *copy;
 	int ret;
 
+	/* Cut out the bootconfig data even if we have no bootconfig option */
 	data = get_boot_config_from_initrd(&size, &csum);
-	if (!data)
-		goto not_found;
 
 	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 	parse_args("bootconfig", tmp_cmdline, NULL, 0, 0, 0, NULL,
@@ -409,6 +408,11 @@ static void __init setup_boot_config(con
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
@@ -440,8 +444,6 @@ static void __init setup_boot_config(con
 		extra_init_args = xbc_make_cmdline("init");
 	}
 	return;
-not_found:
-	pr_err("'bootconfig' found on command line, but no bootconfig found\n");
 }
 
 #else


