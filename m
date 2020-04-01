Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE2A19B2A3
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389403AbgDAQpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389878AbgDAQpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:45:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 011FF206E9;
        Wed,  1 Apr 2020 16:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759550;
        bh=YnotHvaB4DpvW05hOYKcaEFdPBULmNj+Gphpjt+xS1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJh8Ri7AaCJol2aexBSxFRyOcNS2/nzXIkeFp9DRa5baYviyW6FrF9PsKoSNEe4p5
         D1aSCsYGCRTUwwv1wD3n76vsSzazdm1Z6U0RwToQPcrpZpPu9G4RjpX1UeVtvLytSu
         jtM8ObUbVZhIrI6Tvv4hS3t624OOJ7kcEnWVpLAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 113/148] afs: Fix some tracing details
Date:   Wed,  1 Apr 2020 18:18:25 +0200
Message-Id: <20200401161603.386369320@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4636cf184d6d9a92a56c2554681ea520dd4fe49a ]

Fix a couple of tracelines to indicate the usage count after the atomic op,
not the usage count before it to be consistent with other afs and rxrpc
trace lines.

Change the wording of the afs_call_trace_work trace ID label from "WORK" to
"QUEUE" to reflect the fact that it's queueing work, not doing work.

Fixes: 341f741f04be ("afs: Refcount the afs_call struct")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/rxrpc.c             | 4 ++--
 include/trace/events/afs.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index ccc9c708a860a..7dc9c78a1c31c 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -173,7 +173,7 @@ void afs_put_call(struct afs_call *call)
 	int n = atomic_dec_return(&call->usage);
 	int o = atomic_read(&afs_outstanding_calls);
 
-	trace_afs_call(call, afs_call_trace_put, n + 1, o,
+	trace_afs_call(call, afs_call_trace_put, n, o,
 		       __builtin_return_address(0));
 
 	ASSERTCMP(n, >=, 0);
@@ -619,7 +619,7 @@ static void afs_wake_up_async_call(struct sock *sk, struct rxrpc_call *rxcall,
 
 	u = __atomic_add_unless(&call->usage, 1, 0);
 	if (u != 0) {
-		trace_afs_call(call, afs_call_trace_wake, u,
+		trace_afs_call(call, afs_call_trace_wake, u + 1,
 			       atomic_read(&afs_outstanding_calls),
 			       __builtin_return_address(0));
 
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 8b95c16b70454..0978bdae2243b 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -40,7 +40,7 @@ enum afs_call_trace {
 	EM(afs_call_trace_free,			"FREE ") \
 	EM(afs_call_trace_put,			"PUT  ") \
 	EM(afs_call_trace_wake,			"WAKE ") \
-	E_(afs_call_trace_work,			"WORK ")
+	E_(afs_call_trace_work,			"QUEUE")
 
 /*
  * Export enum symbols via userspace.
-- 
2.20.1



