Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115A5F72D
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfD3Lsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730866AbfD3Lsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 196852173E;
        Tue, 30 Apr 2019 11:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624910;
        bh=BMQhf59ngHxcrEisMnwNzHCcj0mMR5dhpJStGP4pMZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRwGooaxwd3SzClfT0+CxNoBcxtNARInHG4ObmWRyw9cz4wex3vmxcZcpq2hZUst5
         inxsf57ZEQsJFEwnu5TBv6R3Wk37nq6Bg8fP6yaw3dNfrkji6wrIqMSqGsUIgjP6Ih
         ZhB8Q/+YKefGrtCt9GzjKYuAd7DM9tZ47xBe//Z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.0 11/89] tracing: Fix a memory leak by early error exit in trace_pid_write()
Date:   Tue, 30 Apr 2019 13:38:02 +0200
Message-Id: <20190430113610.273122015@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wang6495@umn.edu>

commit 91862cc7867bba4ee5c8fcf0ca2f1d30427b6129 upstream.

In trace_pid_write(), the buffer for trace parser is allocated through
kmalloc() in trace_parser_get_init(). Later on, after the buffer is used,
it is then freed through kfree() in trace_parser_put(). However, it is
possible that trace_pid_write() is terminated due to unexpected errors,
e.g., ENOMEM. In that case, the allocated buffer will not be freed, which
is a memory leak bug.

To fix this issue, free the allocated buffer when an error is encountered.

Link: http://lkml.kernel.org/r/1555726979-15633-1-git-send-email-wang6495@umn.edu

Fixes: f4d34a87e9c10 ("tracing: Use pid bitmap instead of a pid array for set_event_pid")
Cc: stable@vger.kernel.org
Signed-off-by: Wenwen Wang <wang6495@umn.edu>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -496,8 +496,10 @@ int trace_pid_write(struct trace_pid_lis
 	 * not modified.
 	 */
 	pid_list = kmalloc(sizeof(*pid_list), GFP_KERNEL);
-	if (!pid_list)
+	if (!pid_list) {
+		trace_parser_put(&parser);
 		return -ENOMEM;
+	}
 
 	pid_list->pid_max = READ_ONCE(pid_max);
 
@@ -507,6 +509,7 @@ int trace_pid_write(struct trace_pid_lis
 
 	pid_list->pids = vzalloc((pid_list->pid_max + 7) >> 3);
 	if (!pid_list->pids) {
+		trace_parser_put(&parser);
 		kfree(pid_list);
 		return -ENOMEM;
 	}


