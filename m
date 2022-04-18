Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A778505209
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239446AbiDRMl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240101AbiDRMik (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:38:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C6C24F34;
        Mon, 18 Apr 2022 05:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB70761014;
        Mon, 18 Apr 2022 12:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D723AC385A1;
        Mon, 18 Apr 2022 12:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284957;
        bh=QW4AOLZ2mnwr58m9urouc3JcM35Hp0AuME0jM0U7jgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwS9K43Hbi8A7+WKMB7AyiBf+3dBNDG6QNexSdT2swCOkhVYYTQ/H21uXuHefZ6Pf
         iI+2dJngghI8sYsdE1dO2y4whygYmA9bd5c+F6zqQy1+GWTiC9zZdA6X2uNAw3+J+L
         VzqqCEeGEOTOIR78sF3XwQmgYoZpo2R/ZspV9ECo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/189] SUNRPC: Fix the svc_deferred_event trace class
Date:   Mon, 18 Apr 2022 14:11:22 +0200
Message-Id: <20220418121202.269470664@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4d5004451ab2218eab94a30e1841462c9316ba19 ]

Fix a NULL deref crash that occurs when an svc_rqst is deferred
while the sunrpc tracing subsystem is enabled. svc_revisit() sets
dr->xprt to NULL, so it can't be relied upon in the tracepoint to
provide the remote's address.

Unfortunately we can't revert the "svc_deferred_class" hunk in
commit ece200ddd54b ("sunrpc: Save remote presentation address in
svc_xprt for trace events") because there is now a specific check
of event format specifiers for unsafe dereferences. The warning
that check emits is:

  event svc_defer_recv has unsafe dereference of argument 1

A "%pISpc" format specifier with a "struct sockaddr *" is indeed
flagged by this check.

Instead, take the brute-force approach used by the svcrdma_qp_error
tracepoint. Convert the dr::addr field into a presentation address
in the TP_fast_assign() arm of the trace event, and store that as
a string. This fix can be backported to -stable kernels.

In the meantime, commit c6ced22997ad ("tracing: Update print fmt
check to handle new __get_sockaddr() macro") is now in v5.18, so
this wonky fix can be replaced with __sockaddr() and friends
properly during the v5.19 merge window.

Fixes: ece200ddd54b ("sunrpc: Save remote presentation address in svc_xprt for trace events")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sunrpc.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 7c48613c1830..6bcb8c7a3175 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1924,17 +1924,18 @@ DECLARE_EVENT_CLASS(svc_deferred_event,
 	TP_STRUCT__entry(
 		__field(const void *, dr)
 		__field(u32, xid)
-		__string(addr, dr->xprt->xpt_remotebuf)
+		__array(__u8, addr, INET6_ADDRSTRLEN + 10)
 	),
 
 	TP_fast_assign(
 		__entry->dr = dr;
 		__entry->xid = be32_to_cpu(*(__be32 *)(dr->args +
 						       (dr->xprt_hlen>>2)));
-		__assign_str(addr, dr->xprt->xpt_remotebuf);
+		snprintf(__entry->addr, sizeof(__entry->addr) - 1,
+			 "%pISpc", (struct sockaddr *)&dr->addr);
 	),
 
-	TP_printk("addr=%s dr=%p xid=0x%08x", __get_str(addr), __entry->dr,
+	TP_printk("addr=%s dr=%p xid=0x%08x", __entry->addr, __entry->dr,
 		__entry->xid)
 );
 
-- 
2.35.1



