Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18336431626
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 12:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJRKdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 06:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhJRKdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 06:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 991A1610A3;
        Mon, 18 Oct 2021 10:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634553070;
        bh=fJo1kFXMgR4OIN9sQ1Vu8LC/f/K/WK67EBJXWjUfwX0=;
        h=Subject:To:Cc:From:Date:From;
        b=K2p9VQmWYxmQve0qHZA8Gzb6FzHZCJDZVfGtPLIsheSIJviQ7ztN7TJ1DT5Wpftw4
         jbW8a8UiViO0dnf07pIxUxwOOFqN1Vdzt5ABUSB8RadiVfaGl7kqFGivsUVV0Vy0ZG
         Ub/4AIMmoIwvaEz2OSIe7Gie4JTw1a4MtqysxiaM=
Subject: FAILED: patch "[PATCH] bootconfig: init: Fix memblock leak in xbc_make_cmdline()" failed to apply to 5.10-stable tree
To:     mhiramat@kernel.org, rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 12:30:54 +0200
Message-ID: <16345530548777@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1ae43851b18afe861120ebd7c426dc44f06bb2bd Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 16 Sep 2021 15:23:12 +0900
Subject: [PATCH] bootconfig: init: Fix memblock leak in xbc_make_cmdline()

Free unused memblock in a error case to fix memblock leak
in xbc_make_cmdline().

Link: https://lkml.kernel.org/r/163177339181.682366.8713781325929549256.stgit@devnote2

Fixes: 51887d03aca1 ("bootconfig: init: Allow admin to use bootconfig for kernel command line")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/init/main.c b/init/main.c
index 81a79a77db46..3c4054a95545 100644
--- a/init/main.c
+++ b/init/main.c
@@ -382,6 +382,7 @@ static char * __init xbc_make_cmdline(const char *key)
 	ret = xbc_snprint_cmdline(new_cmdline, len + 1, root);
 	if (ret < 0 || ret > len) {
 		pr_err("Failed to print extra kernel cmdline.\n");
+		memblock_free_ptr(new_cmdline, len + 1);
 		return NULL;
 	}
 

