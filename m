Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E47027C713
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbgI2LtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731102AbgI2Lsy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F26020702;
        Tue, 29 Sep 2020 11:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380133;
        bh=LQQ7qLmCdsLj4b/mwLAgVcXK7kSm3eRjFdRBU/CCUX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCHSc9BaQOIBVJBr2/u1NkkSV7cwFdoFr0o9TIhlCanF8oa33fgCe2q3j/KumFNov
         BleyU2HJsE2rqS13uHAIewQOm/05VDMU8cOScif3gHAHd6xvYjqcHUTvuagmCC17LZ
         gDAIZzzVz3lpD/okNnZrbNb0rDa5tIvo3tsHLyo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.8 82/99] lib/bootconfig: Fix a bug of breaking existing tree nodes
Date:   Tue, 29 Sep 2020 13:02:05 +0200
Message-Id: <20200929105933.772711668@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit ead1e19ad905b97261f0ad7a98bb64abb9323b2b upstream.

Fix a bug of breaking existing tree nodes by parsing the second
and subsequent braces. Since the bootconfig parser uses the
node.next field as a flag of current parent node, but this will
break the existing tree if the same key node is specified again
in the bootconfig.

For example, the following bootconfig should be foo.buz and bar.

foo
bar
foo { buz }

However, when parsing the brace "{", it breaks foo->bar link
by marking open-brace node. So the bootconfig unlinks bar
from the bootconfig internal tree.

This introduces a stack outside of the tree and record the
last open-brace on the stack instead of using node.next field.

Link: https://lkml.kernel.org/r/160068148267.1088739.8264704338030168660.stgit@devnote2

Fixes: 76db5a27a827 ("bootconfig: Add Extra Boot Config support")
Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/bootconfig.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -31,6 +31,8 @@ static size_t xbc_data_size __initdata;
 static struct xbc_node *last_parent __initdata;
 static const char *xbc_err_msg __initdata;
 static int xbc_err_pos __initdata;
+static int open_brace[XBC_DEPTH_MAX] __initdata;
+static int brace_index __initdata;
 
 static int __init xbc_parse_error(const char *msg, const char *p)
 {
@@ -423,27 +425,27 @@ static char *skip_spaces_until_newline(c
 	return p;
 }
 
-static int __init __xbc_open_brace(void)
+static int __init __xbc_open_brace(char *p)
 {
-	/* Mark the last key as open brace */
-	last_parent->next = XBC_NODE_MAX;
+	/* Push the last key as open brace */
+	open_brace[brace_index++] = xbc_node_index(last_parent);
+	if (brace_index >= XBC_DEPTH_MAX)
+		return xbc_parse_error("Exceed max depth of braces", p);
 
 	return 0;
 }
 
 static int __init __xbc_close_brace(char *p)
 {
-	struct xbc_node *node;
-
-	if (!last_parent || last_parent->next != XBC_NODE_MAX)
+	brace_index--;
+	if (!last_parent || brace_index < 0 ||
+	    (open_brace[brace_index] != xbc_node_index(last_parent)))
 		return xbc_parse_error("Unexpected closing brace", p);
 
-	node = last_parent;
-	node->next = 0;
-	do {
-		node = xbc_node_get_parent(node);
-	} while (node && node->next != XBC_NODE_MAX);
-	last_parent = node;
+	if (brace_index == 0)
+		last_parent = NULL;
+	else
+		last_parent = &xbc_nodes[open_brace[brace_index - 1]];
 
 	return 0;
 }
@@ -651,7 +653,7 @@ static int __init xbc_open_brace(char **
 		return ret;
 	*k = n;
 
-	return __xbc_open_brace();
+	return __xbc_open_brace(n - 1);
 }
 
 static int __init xbc_close_brace(char **k, char *n)
@@ -671,6 +673,13 @@ static int __init xbc_verify_tree(void)
 	int i, depth, len, wlen;
 	struct xbc_node *n, *m;
 
+	/* Brace closing */
+	if (brace_index) {
+		n = &xbc_nodes[open_brace[brace_index]];
+		return xbc_parse_error("Brace is not closed",
+					xbc_node_get_data(n));
+	}
+
 	/* Empty tree */
 	if (xbc_node_num == 0) {
 		xbc_parse_error("Empty config", xbc_data);
@@ -735,6 +744,7 @@ void __init xbc_destroy_all(void)
 	xbc_node_num = 0;
 	memblock_free(__pa(xbc_nodes), sizeof(struct xbc_node) * XBC_NODE_MAX);
 	xbc_nodes = NULL;
+	brace_index = 0;
 }
 
 /**


