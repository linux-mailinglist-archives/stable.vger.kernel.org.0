Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C665053A7
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbiDRNAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241397AbiDRM6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:58:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7D827FF8;
        Mon, 18 Apr 2022 05:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98CC260FB6;
        Mon, 18 Apr 2022 12:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD44C385A1;
        Mon, 18 Apr 2022 12:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285542;
        bh=RuI6u+OIMxRckoYB0ZZOJmgmVKvMnxAua/PYBTcCYEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVK8vrB2S9T3vlhTWc3sPcmBwGdE5B0OFzY72btiKcXkoRSJq/hLaAMf453vUF/jy
         YEbJDa9FB+zXcyfaI2eMK6+W9K2qfArAhfPt6dWGQ3VIOw3MQM41AoiEfkt0osEZoY
         w+9cUx7WL7TTLo18RGzRw+tWtkRTTLEEkxHpBpFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/105] SUNRPC: Fix the svc_deferred_event trace class
Date:   Mon, 18 Apr 2022 14:12:13 +0200
Message-Id: <20220418121145.985862344@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
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
index 23db248a7fdb..ed1bbac004d5 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1874,17 +1874,18 @@ DECLARE_EVENT_CLASS(svc_deferred_event,
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



