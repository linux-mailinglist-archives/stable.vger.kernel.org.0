Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341164CF73C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbiCGJpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240986AbiCGJlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9A06D193;
        Mon,  7 Mar 2022 01:38:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 189446116E;
        Mon,  7 Mar 2022 09:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C93C340E9;
        Mon,  7 Mar 2022 09:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645935;
        bh=vUUx7TDfvi9NLzfwhBM7JvnGySc+0jCcgOAbRK5rt/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlVMajugN+JxMxA+O9lTJv4FhRyRj2ssg8ajocIMQK+dLkTa1MtlJwEPBNhfeN4it
         SwVb7js1lwqmZWUIOgBU40qnkzaPRPO2lcmUpIfAC5Li6VwK9QSf/HylRjOFeVXD0e
         upBdULY6cdLijjReitXyMC+Hn2tXlmy8TP7Uc4j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/262] SUNRPC: Fix sockaddr handling in the svc_xprt_create_error trace point
Date:   Mon,  7 Mar 2022 10:17:04 +0100
Message-Id: <20220307091704.747088295@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index daaf407e9e494..1213c078dcca5 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1727,10 +1727,11 @@ TRACE_EVENT(svc_xprt_create_err,
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
@@ -1743,7 +1744,7 @@ TRACE_EVENT(svc_xprt_create_err,
 		__entry->error = PTR_ERR(xprt);
 		__assign_str(program, program);
 		__assign_str(protocol, protocol);
-		memcpy(__entry->addr, sap, sizeof(__entry->addr));
+		memcpy(__entry->addr, sap, min(salen, sizeof(__entry->addr)));
 	),
 
 	TP_printk("addr=%pISpc program=%s protocol=%s error=%ld",
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 6316bd2b8f37b..d4b663401be14 100644
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



