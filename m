Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BE4205E28
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389887AbgFWUU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389937AbgFWUU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A94520780;
        Tue, 23 Jun 2020 20:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943626;
        bh=5LDLI5H6sMrSpzHKnCAMgq0GYUOgelYUTiMI0XOiXs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpOqODamcOb2/IWf/T3U4OT7V+KoXY6gc+qaWOoN1dqCTl9kg3BGnruoGxr7oZ+yu
         V5fEpPZoc+YB7FM+Hy4gRQq4xnZI1AwJSDMmJjdwcz4NLK1VcSfcLkRAQkSJ+7DA29
         ty7V9iETZY+5CSfZyVRsJqhEVwLibkQSAsMR37Oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.7 464/477] proc/bootconfig: Fix to use correct quotes for value
Date:   Tue, 23 Jun 2020 21:57:41 +0200
Message-Id: <20200623195429.485939347@linuxfoundation.org>
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

commit 4e264ffd953463cd14c0720eaa9315ac052f5973 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/bootconfig.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/proc/bootconfig.c
+++ b/fs/proc/bootconfig.c
@@ -26,8 +26,9 @@ static int boot_config_proc_show(struct
 static int __init copy_xbc_key_value_list(char *dst, size_t size)
 {
 	struct xbc_node *leaf, *vnode;
-	const char *val;
 	char *key, *end = dst + size;
+	const char *val;
+	char q;
 	int ret = 0;
 
 	key = kzalloc(XBC_KEYLEN_MAX, GFP_KERNEL);
@@ -41,16 +42,20 @@ static int __init copy_xbc_key_value_lis
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


