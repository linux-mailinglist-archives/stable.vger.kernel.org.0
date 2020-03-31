Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5401B199179
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgCaJTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731927AbgCaJQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:16:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94DDB208E0;
        Tue, 31 Mar 2020 09:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646218;
        bh=obGgSUtZiDNXWWw0omhi8ISrvD7pcYvAEGbVEz9SNiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWETTxgBTr7FZTwBkQNtDS8RkaQCa/p3nddIy5s1f6Zk4HZd1T4nqYBnge/s2SBlK
         fQxaf9Y08q6RteAkzGGWGzlIHTJZYB3NaMGEfP8JSICcsXoCv5tCPKNCVMe0akEPHX
         Vb3QNgHKDqoXJLetvMDt71SVo+DzXsFKExIojok0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.4 120/155] afs: Fix some tracing details
Date:   Tue, 31 Mar 2020 10:59:20 +0200
Message-Id: <20200331085431.875178989@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 4636cf184d6d9a92a56c2554681ea520dd4fe49a upstream.

Fix a couple of tracelines to indicate the usage count after the atomic op,
not the usage count before it to be consistent with other afs and rxrpc
trace lines.

Change the wording of the afs_call_trace_work trace ID label from "WORK" to
"QUEUE" to reflect the fact that it's queueing work, not doing work.

Fixes: 341f741f04be ("afs: Refcount the afs_call struct")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/rxrpc.c             |    4 ++--
 include/trace/events/afs.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -168,7 +168,7 @@ void afs_put_call(struct afs_call *call)
 	int n = atomic_dec_return(&call->usage);
 	int o = atomic_read(&net->nr_outstanding_calls);
 
-	trace_afs_call(call, afs_call_trace_put, n + 1, o,
+	trace_afs_call(call, afs_call_trace_put, n, o,
 		       __builtin_return_address(0));
 
 	ASSERTCMP(n, >=, 0);
@@ -704,7 +704,7 @@ static void afs_wake_up_async_call(struc
 
 	u = atomic_fetch_add_unless(&call->usage, 1, 0);
 	if (u != 0) {
-		trace_afs_call(call, afs_call_trace_wake, u,
+		trace_afs_call(call, afs_call_trace_wake, u + 1,
 			       atomic_read(&call->net->nr_outstanding_calls),
 			       __builtin_return_address(0));
 
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -233,7 +233,7 @@ enum afs_cb_break_reason {
 	EM(afs_call_trace_get,			"GET  ") \
 	EM(afs_call_trace_put,			"PUT  ") \
 	EM(afs_call_trace_wake,			"WAKE ") \
-	E_(afs_call_trace_work,			"WORK ")
+	E_(afs_call_trace_work,			"QUEUE")
 
 #define afs_server_traces \
 	EM(afs_server_trace_alloc,		"ALLOC    ") \


