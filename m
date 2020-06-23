Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF7C206496
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390575AbgFWVYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389942AbgFWUU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA742073E;
        Tue, 23 Jun 2020 20:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943628;
        bh=JU9sCxxkFFdsFCi4Fz5cEczvWYShzLwWuqXG+2gEuUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhaejGnHLWKvs5aO/xfdBmO/12pU4cmOtYKPpeUintzH8b6XDhX8WRKvXYGxec1oC
         PaPdwTbHQ8SZolYfe0DghQBIxcKX14a8IYOFMnJWIiuCeGy0saglyQqg/61XwVwrfV
         tv3Exw6+KnQZ7gzpvk2OTmEiscNKJDxiBRMYW61o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.7 465/477] tools/bootconfig: Fix to use correct quotes for value
Date:   Tue, 23 Jun 2020 21:57:42 +0200
Message-Id: <20200623195429.533035502@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 272da3279df191f028fd63d1683e5ecd56fcb13b upstream.

Fix bootconfig tool to select double or single quotes
correctly according to the value.

If a bootconfig value includes a double quote character,
we must use single-quotes to quote that value.

Link: http://lkml.kernel.org/r/159230245697.65555.12444299015852932304.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/bootconfig/main.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -14,13 +14,18 @@
 #include <linux/kernel.h>
 #include <linux/bootconfig.h>
 
-static int xbc_show_array(struct xbc_node *node)
+static int xbc_show_value(struct xbc_node *node)
 {
 	const char *val;
+	char q;
 	int i = 0;
 
 	xbc_array_for_each_value(node, val) {
-		printf("\"%s\"%s", val, node->next ? ", " : ";\n");
+		if (strchr(val, '"'))
+			q = '\'';
+		else
+			q = '"';
+		printf("%c%s%c%s", q, val, q, node->next ? ", " : ";\n");
 		i++;
 	}
 	return i;
@@ -48,10 +53,7 @@ static void xbc_show_compact_tree(void)
 			continue;
 		} else if (cnode && xbc_node_is_value(cnode)) {
 			printf("%s = ", xbc_node_get_data(node));
-			if (cnode->next)
-				xbc_show_array(cnode);
-			else
-				printf("\"%s\";\n", xbc_node_get_data(cnode));
+			xbc_show_value(cnode);
 		} else {
 			printf("%s;\n", xbc_node_get_data(node));
 		}


