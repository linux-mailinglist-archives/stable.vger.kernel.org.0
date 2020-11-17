Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69B12B623D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731659AbgKQN0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:26:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731448AbgKQN0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F0F8206D5;
        Tue, 17 Nov 2020 13:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619598;
        bh=jpUYbl5JrzNr7TEJluYUsRQS4v/IdPcPoMuMxicp6kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzLsDx5gxOTmXAQZgLzWrQ1L95M3e22Zxz0+NBttq50XlSFajjc6fWtbkBIrPtGFM
         ygiSzdfV+UsWCDWSHr/bce9JrfzRx8LFePmP3vwMhU0ChE95SUW5pVRSzxdGweTIM1
         T/tXvD4dNIfZLRlbE8ZIW0eVfFNuRXBI0BUHqYHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/151] SUNRPC: Fix general protection fault in trace_rpc_xdr_overflow()
Date:   Tue, 17 Nov 2020 14:05:22 +0100
Message-Id: <20201117122125.888937096@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
index 28df77a948e56..f16e9fb97e9f4 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -357,10 +357,10 @@ TRACE_EVENT(rpc_xdr_overflow,
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



