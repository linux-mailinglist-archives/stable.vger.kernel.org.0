Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1CF41743A
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345851AbhIXNEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:04:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344174AbhIXNCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:02:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED9A61439;
        Fri, 24 Sep 2021 12:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488069;
        bh=EblabyhP/ZG2Glv8/a6oYU1j3ijpHPJR3hduOs2nGkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JE+EGKBBAo9lc92bDK/FXQgUfFgPDaXgyLENu2xvtyN7Jz23NTRkAyGSLFcDocKks
         b6L46An6Cccgl5rKfZv5T2tzxSW/Po0ifGPhB5KGpQ5wF9bTxR7xSr1skt3A4XrfhE
         XcMZYdO2NVzxKmR/dDrgbA7hvUgST8qFfht/dlFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 040/100] tracing/boot: Fix to loop on only subkeys
Date:   Fri, 24 Sep 2021 14:43:49 +0200
Message-Id: <20210924124342.799797187@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit cfd799837dbc48499abb05d1891b3d9992354d3a ]

Since the commit e5efaeb8a8f5 ("bootconfig: Support mixing
a value and subkeys under a key") allows to co-exist a value
node and key nodes under a node, xbc_node_for_each_child()
is not only returning key node but also a value node.
In the boot-time tracing using xbc_node_for_each_child() to
iterate the events, groups and instances, but those must be
key nodes. Thus it must use xbc_node_for_each_subkey().

Link: https://lkml.kernel.org/r/163112988361.74896.2267026262061819145.stgit@devnote2

Fixes: e5efaeb8a8f5 ("bootconfig: Support mixing a value and subkeys under a key")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_boot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index d713714cba67..4bd8f94a56c6 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -235,14 +235,14 @@ trace_boot_init_events(struct trace_array *tr, struct xbc_node *node)
 	if (!node)
 		return;
 	/* per-event key starts with "event.GROUP.EVENT" */
-	xbc_node_for_each_child(node, gnode) {
+	xbc_node_for_each_subkey(node, gnode) {
 		data = xbc_node_get_data(gnode);
 		if (!strcmp(data, "enable")) {
 			enable_all = true;
 			continue;
 		}
 		enable = false;
-		xbc_node_for_each_child(gnode, enode) {
+		xbc_node_for_each_subkey(gnode, enode) {
 			data = xbc_node_get_data(enode);
 			if (!strcmp(data, "enable")) {
 				enable = true;
@@ -338,7 +338,7 @@ trace_boot_init_instances(struct xbc_node *node)
 	if (!node)
 		return;
 
-	xbc_node_for_each_child(node, inode) {
+	xbc_node_for_each_subkey(node, inode) {
 		p = xbc_node_get_data(inode);
 		if (!p || *p == '\0')
 			continue;
-- 
2.33.0



