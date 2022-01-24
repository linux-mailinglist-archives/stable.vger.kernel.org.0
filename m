Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38BC499A74
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378965AbiAXVoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53228 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454827AbiAXVdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:33:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4277B614D9;
        Mon, 24 Jan 2022 21:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169A9C340E4;
        Mon, 24 Jan 2022 21:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060029;
        bh=V51i5NSzuvI4kZFN8M+AscwhplgJFBRBDz7wg7aMuqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sR09uEvQimogDHClWp0xGuX5xV4nh+J9S4T8mAsPbXp/Xflbr5dvxOqNJtJ2G4qm1
         7tXmfCEZdKWnM35OfiRI73TnAdJvcfJrnaVRtYDqlmCaQTQl8tGeM6qjW8B8qWDLSB
         XbMTUGZ3xpQuaDjVRFc2R1LPxmapmtfAD7s51h/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0815/1039] SUNRPC: Fix sockaddr handling in the svc_xprt_create_error trace point
Date:   Mon, 24 Jan 2022 19:43:24 +0100
Message-Id: <20220124184152.700408346@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit dc6c6fb3d639756a532bcc47d4a9bf9f3965881b ]

While testing, I got an unexpected KASAN splat:

Jan 08 13:50:27 oracle-102.nfsv4.dev kernel: BUG: KASAN: stack-out-of-bounds in trace_event_raw_event_svc_xprt_create_err+0x190/0x210 [sunrpc]
Jan 08 13:50:27 oracle-102.nfsv4.dev kernel: Read of size 28 at addr ffffc9000008f728 by task mount.nfs/4628

The memcpy() in the TP_fast_assign section of this trace point
copies the size of the destination buffer in order that the buffer
won't be overrun.

In other similar trace points, the source buffer for this memcpy is
a "struct sockaddr_storage" so the actual length of the source
buffer is always long enough to prevent the memcpy from reading
uninitialized or unallocated memory.

However, for this trace point, the source buffer can be as small as
a "struct sockaddr_in". For AF_INET sockaddrs, the memcpy() reads
memory that follows the source buffer, which is not always valid
memory.

To avoid copying past the end of the passed-in sockaddr, make the
source address's length available to the memcpy(). It would be a
little nicer if the tracing infrastructure was more friendly about
storing socket addresses that are not AF_INET, but I could not find
a way to make printk("%pIS") work with a dynamic array.

Reported-by: KASAN
Fixes: 4b8f380e46e4 ("SUNRPC: Tracepoint to record errors in svc_xpo_create()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sunrpc.h | 5 +++--
 net/sunrpc/svc_xprt.c         | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 3a99358c262b4..52288f1c1b52d 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1744,10 +1744,11 @@ TRACE_EVENT(svc_xprt_create_err,
 		const char *program,
 		const char *protocol,
 		struct sockaddr *sap,
+		size_t salen,
 		const struct svc_xprt *xprt
 	),
 
-	TP_ARGS(program, protocol, sap, xprt),
+	TP_ARGS(program, protocol, sap, salen, xprt),
 
 	TP_STRUCT__entry(
 		__field(long, error)
@@ -1760,7 +1761,7 @@ TRACE_EVENT(svc_xprt_create_err,
 		__entry->error = PTR_ERR(xprt);
 		__assign_str(program, program);
 		__assign_str(protocol, protocol);
-		memcpy(__entry->addr, sap, sizeof(__entry->addr));
+		memcpy(__entry->addr, sap, min(salen, sizeof(__entry->addr)));
 	),
 
 	TP_printk("addr=%pISpc program=%s protocol=%s error=%ld",
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 1e99ba1b9d723..008f1b05a7a9f 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -243,7 +243,7 @@ static struct svc_xprt *__svc_xpo_create(struct svc_xprt_class *xcl,
 	xprt = xcl->xcl_ops->xpo_create(serv, net, sap, len, flags);
 	if (IS_ERR(xprt))
 		trace_svc_xprt_create_err(serv->sv_program->pg_name,
-					  xcl->xcl_name, sap, xprt);
+					  xcl->xcl_name, sap, len, xprt);
 	return xprt;
 }
 
-- 
2.34.1



