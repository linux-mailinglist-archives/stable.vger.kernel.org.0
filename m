Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA92124BF02
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbgHTNjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgHTJ2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:28:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 617F322D2C;
        Thu, 20 Aug 2020 09:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915688;
        bh=Q3c3fttEFPNEraViiHJuygJ4IAfzf6gyNW01lwb61AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeJreRrsaMx7HAiMzU9ZeQy7xyQo0aTtiaPEZkYRrFtusEwy/A6y3nVEkh1cUQFmQ
         QXhdFsj6nwyXPwtd/korL6bTHxbH+fFXtagSKqABV+thTs23KHjXJOZGEySi/oeioI
         q/jaWzMK/UzzJ+pCAoOiTOM4jZt6jAIMNpleAQN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.8 101/232] bootconfig: Fix to find the initargs correctly
Date:   Thu, 20 Aug 2020 11:19:12 +0200
Message-Id: <20200820091617.724127174@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 477d08478170469d10b533624342d13701e24b34 upstream.

Since the parse_args() stops parsing at '--', bootconfig_params()
will never get the '--' as param and initargs_found never be true.
In the result, if we pass some init arguments via the bootconfig,
those are always appended to the kernel command line with '--'
even if the kernel command line already has '--'.

To fix this correctly, check the return value of parse_args()
and set initargs_found true if the return value is not an error
but a valid address.

Link: https://lkml.kernel.org/r/159650953285.270383.14822353843556363851.stgit@devnote2

Fixes: f61872bb58a1 ("bootconfig: Use parse_args() to find bootconfig and '--'")
Cc: stable@vger.kernel.org
Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 init/main.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -387,8 +387,6 @@ static int __init bootconfig_params(char
 {
 	if (strcmp(param, "bootconfig") == 0) {
 		bootconfig_found = true;
-	} else if (strcmp(param, "--") == 0) {
-		initargs_found = true;
 	}
 	return 0;
 }
@@ -399,19 +397,23 @@ static void __init setup_boot_config(con
 	const char *msg;
 	int pos;
 	u32 size, csum;
-	char *data, *copy;
+	char *data, *copy, *err;
 	int ret;
 
 	/* Cut out the bootconfig data even if we have no bootconfig option */
 	data = get_boot_config_from_initrd(&size, &csum);
 
 	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
-	parse_args("bootconfig", tmp_cmdline, NULL, 0, 0, 0, NULL,
-		   bootconfig_params);
+	err = parse_args("bootconfig", tmp_cmdline, NULL, 0, 0, 0, NULL,
+			 bootconfig_params);
 
-	if (!bootconfig_found)
+	if (IS_ERR(err) || !bootconfig_found)
 		return;
 
+	/* parse_args() stops at '--' and returns an address */
+	if (err)
+		initargs_found = true;
+
 	if (!data) {
 		pr_err("'bootconfig' found on command line, but no bootconfig found\n");
 		return;


