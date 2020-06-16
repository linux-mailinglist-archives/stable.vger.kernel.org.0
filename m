Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164891FADAA
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 12:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgFPKOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 06:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbgFPKOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 06:14:20 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 545FB20786;
        Tue, 16 Jun 2020 10:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592302460;
        bh=GTN2W44fV0EEOZQw/F7oMAo0E/9r651b3C7FjfRxfE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7h1ItQbnqLrL4u/C1WuUM+qht0ykMxVALs6sb430/NAWytseW9GPa0Cc6fX3S/zv
         iCICx3XlgvUOaG52MZ3wrTyCmFFaG0JnOS2zwzzUtr6UITQNnwEsfCnMkUdqFbTgW1
         PnluV9dMZQrIXI7sndwHDUj60Xb5y1JZCQJ+5qRI=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/4] tools/bootconfig: Fix to use correct quotes for value
Date:   Tue, 16 Jun 2020 19:14:17 +0900
Message-Id: <159230245697.65555.12444299015852932304.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <159230243779.65555.11413773790099102781.stgit@devnote2>
References: <159230243779.65555.11413773790099102781.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix bootconfig tool to select double or single quotes
correctly according to the value.

If a bootconfig value includes a double quote character,
we must use single-quotes to quote that value.

Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
  Changes in v2:
   - Fix patch description.
---
 tools/bootconfig/main.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index 0efaf45f7367..21896a6675fd 100644
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

