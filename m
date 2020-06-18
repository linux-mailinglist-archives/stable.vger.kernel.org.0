Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90061FFF06
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 01:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgFRX5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 19:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728361AbgFRX4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 19:56:42 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A89F21556;
        Thu, 18 Jun 2020 23:56:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jm4Of-003lSL-51; Thu, 18 Jun 2020 19:56:41 -0400
Message-ID: <20200618235641.020682640@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 18 Jun 2020 19:56:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-linus][PATCH 13/17] proc/bootconfig: Fix to use correct quotes for value
References: <20200618235556.451120786@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

Fix /proc/bootconfig to select double or single quotes
corrctly according to the value.

If a bootconfig value includes a double quote character,
we must use single-quotes to quote that value.

This modifies if() condition and blocks for avoiding
double-quote in value check in 2 places. Anyway, since
xbc_array_for_each_value() can handle the array which
has a single node correctly.
Thus,

if (vnode && xbc_node_is_array(vnode)) {
	xbc_array_for_each_value(vnode)	/* vnode->next != NULL */
		...
} else {
	snprintf(val); /* val is an empty string if !vnode */
}

is equivalent to

if (vnode) {
	xbc_array_for_each_value(vnode)	/* vnode->next can be NULL */
		...
} else {
	snprintf("");	/* value is always empty */
}

Link: http://lkml.kernel.org/r/159230244786.65555.3763894451251622488.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: c1a3c36017d4 ("proc: bootconfig: Add /proc/bootconfig to show boot config list")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 fs/proc/bootconfig.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/proc/bootconfig.c b/fs/proc/bootconfig.c
index 9955d75c0585..ad31ec4ad627 100644
--- a/fs/proc/bootconfig.c
+++ b/fs/proc/bootconfig.c
@@ -26,8 +26,9 @@ static int boot_config_proc_show(struct seq_file *m, void *v)
 static int __init copy_xbc_key_value_list(char *dst, size_t size)
 {
 	struct xbc_node *leaf, *vnode;
-	const char *val;
 	char *key, *end = dst + size;
+	const char *val;
+	char q;
 	int ret = 0;
 
 	key = kzalloc(XBC_KEYLEN_MAX, GFP_KERNEL);
@@ -41,16 +42,20 @@ static int __init copy_xbc_key_value_list(char *dst, size_t size)
 			break;
 		dst += ret;
 		vnode = xbc_node_get_child(leaf);
-		if (vnode && xbc_node_is_array(vnode)) {
+		if (vnode) {
 			xbc_array_for_each_value(vnode, val) {
-				ret = snprintf(dst, rest(dst, end), "\"%s\"%s",
-					val, vnode->next ? ", " : "\n");
+				if (strchr(val, '"'))
+					q = '\'';
+				else
+					q = '"';
+				ret = snprintf(dst, rest(dst, end), "%c%s%c%s",
+					q, val, q, vnode->next ? ", " : "\n");
 				if (ret < 0)
 					goto out;
 				dst += ret;
 			}
 		} else {
-			ret = snprintf(dst, rest(dst, end), "\"%s\"\n", val);
+			ret = snprintf(dst, rest(dst, end), "\"\"\n");
 			if (ret < 0)
 				break;
 			dst += ret;
-- 
2.26.2


