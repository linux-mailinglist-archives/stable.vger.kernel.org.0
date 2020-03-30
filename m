Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824FF197CF4
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 15:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgC3NcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 09:32:07 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:34363 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbgC3NcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 09:32:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 49AEE6C2;
        Mon, 30 Mar 2020 09:32:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 30 Mar 2020 09:32:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1udPbv
        KrlwSw1Sd7yrwh19lrBQW6377hb+5xsobA/1Y=; b=PyV7wpXMbV+3vZ9SnZq0WZ
        63PqkOQpeQntI/uctxKPLlny/Tn4Gks/lygfR3XwrRwinUXfq4cBTBqtdII03NXz
        tTalvD4G3/QuCCviLPOCp/gkGZQIKFHXGZ++ZqdXvLGB+sq57b8pQLg2Y8Rt1e2x
        b518XPStKr+C9xDCrhXfaKi5w3UesdftjwhdWGzAcBgQlv6ISbwDwN8GvwNvhW8/
        tVAGSTIydCCEFOzXNxtTvVDVNzz4hHSCQAAPFsy/VgER7DPK0Zxtrb/6sgRqvbCV
        N7wnmx1inDJSrKP0YHC84Qr9wKbMu842H3FfkEBEUwkPe5H1lK20wrgGQDv9UYKg
        ==
X-ME-Sender: <xms:1fSBXvbgn6x7_oSWodaFDpYHjWgE5V1VAQyY3uHJWkpjHr6Vqqlzug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1fSBXt-S6NlhkIghtpkfL0MsVjrSSrR6upZ8U_85MN_zpTKF45eLEg>
    <xmx:1fSBXk_De7h9YHLJNnOdgtlKYw2wTEIcMo0PoywkBHiHpstocK9syg>
    <xmx:1fSBXhoZQZXRW2Z0r8pbwAmPGlaM6E2ANfc3ky-ecc2rMZ0-22Zfvg>
    <xmx:1fSBXhfZElEE7lLyxK5lAR8KUyel9hnrK9o7Tr0PQGiOp52On53EDQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7059A3280066;
        Mon, 30 Mar 2020 09:32:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] afs: Fix some tracing details" failed to apply to 4.14-stable tree
To:     dhowells@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Mar 2020 15:32:02 +0200
Message-ID: <1585575122165119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4636cf184d6d9a92a56c2554681ea520dd4fe49a Mon Sep 17 00:00:00 2001
From: David Howells <dhowells@redhat.com>
Date: Fri, 13 Mar 2020 13:36:01 +0000
Subject: [PATCH] afs: Fix some tracing details

Fix a couple of tracelines to indicate the usage count after the atomic op,
not the usage count before it to be consistent with other afs and rxrpc
trace lines.

Change the wording of the afs_call_trace_work trace ID label from "WORK" to
"QUEUE" to reflect the fact that it's queueing work, not doing work.

Fixes: 341f741f04be ("afs: Refcount the afs_call struct")
Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 4c28712bb7f6..907d5948564a 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -169,7 +169,7 @@ void afs_put_call(struct afs_call *call)
 	int n = atomic_dec_return(&call->usage);
 	int o = atomic_read(&net->nr_outstanding_calls);
 
-	trace_afs_call(call, afs_call_trace_put, n + 1, o,
+	trace_afs_call(call, afs_call_trace_put, n, o,
 		       __builtin_return_address(0));
 
 	ASSERTCMP(n, >=, 0);
@@ -736,7 +736,7 @@ static void afs_wake_up_async_call(struct sock *sk, struct rxrpc_call *rxcall,
 
 	u = atomic_fetch_add_unless(&call->usage, 1, 0);
 	if (u != 0) {
-		trace_afs_call(call, afs_call_trace_wake, u,
+		trace_afs_call(call, afs_call_trace_wake, u + 1,
 			       atomic_read(&call->net->nr_outstanding_calls),
 			       __builtin_return_address(0));
 
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 564ba1b5cf57..c612cabbc378 100644
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

