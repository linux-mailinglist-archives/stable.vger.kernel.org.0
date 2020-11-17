Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54462B637D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbgKQNij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732782AbgKQNgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7635207BC;
        Tue, 17 Nov 2020 13:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620212;
        bh=LGUjmngtKBsYdUm9AYXeULPsR0jyCDVhnz6TrZR9j0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izuBqSb2OxiAkAr9vVAOEjGRtCzHVRN72dpa88nNikafx0NCDWTzMKrYRbCzN+U4t
         iQfbJLe7p1q5M8KPRNo+1U02eU+L7/h0ilBn+dco73CCA9n1FfBaKT4xceNE7+0DGW
         IsEpQO7/pV7NA5MnAeRTcC4nEOTNDqApRnD9RdvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 143/255] SUNRPC: Fix general protection fault in trace_rpc_xdr_overflow()
Date:   Tue, 17 Nov 2020 14:04:43 +0100
Message-Id: <20201117122145.909256388@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit d321ff589c16d8c2207485a6d7fbdb14e873d46e ]

The TP_fast_assign() section is careful enough not to dereference
xdr->rqst if it's NULL. The TP_STRUCT__entry section is not.

Fixes: 5582863f450c ("SUNRPC: Add XDR overflow trace event")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sunrpc.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 65d7dfbbc9cd7..ca2f27b9f919d 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -607,10 +607,10 @@ TRACE_EVENT(rpc_xdr_overflow,
 		__field(size_t, tail_len)
 		__field(unsigned int, page_len)
 		__field(unsigned int, len)
-		__string(progname,
-			 xdr->rqst->rq_task->tk_client->cl_program->name)
-		__string(procedure,
-			 xdr->rqst->rq_task->tk_msg.rpc_proc->p_name)
+		__string(progname, xdr->rqst ?
+			 xdr->rqst->rq_task->tk_client->cl_program->name : "unknown")
+		__string(procedure, xdr->rqst ?
+			 xdr->rqst->rq_task->tk_msg.rpc_proc->p_name : "unknown")
 	),
 
 	TP_fast_assign(
-- 
2.27.0



