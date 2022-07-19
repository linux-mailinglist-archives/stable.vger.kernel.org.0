Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B852579B8B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237512AbiGSM2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239664AbiGSM2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99C065D5B;
        Tue, 19 Jul 2022 05:10:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F60E6177E;
        Tue, 19 Jul 2022 12:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE93C341C6;
        Tue, 19 Jul 2022 12:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232636;
        bh=kPJAsjLpGBb2Q5ipTE7OnPID7nGe121aKEl9He9CuPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JInfe+sNLlK7r/GJZ1xpO/AMrIPBz5fnHfkJsKjeYYM4PA1+sMW4xVniXGzJIBnLq
         2t/eZKqs5GiRx9jIow8FgU0ukQt2Pa8dZ1TbRH93DlzFlYc5mQTtGCv8Hd2rWguTrY
         dm+t49Nfcdn4tuTXotwEY9JLFgdBI5t6HNr5q7Y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 013/167] net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer
Date:   Tue, 19 Jul 2022 13:52:25 +0200
Message-Id: <20220719114657.982708181@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 820b8963adaea34a87abbecb906d1f54c0aabfb7 upstream.

The trace event sock_exceed_buf_limit saves the prot->sysctl_mem pointer
and then dereferences it in the TP_printk() portion. This is unsafe as the
TP_printk() portion is executed at the time the buffer is read. That is,
it can be seconds, minutes, days, months, even years later. If the proto
is freed, then this dereference will can also lead to a kernel crash.

Instead, save the sysctl_mem array into the ring buffer and have the
TP_printk() reference that instead. This is the proper and safe way to
read pointers in trace events.

Link: https://lore.kernel.org/all/20220706052130.16368-12-kuniyu@amazon.com/

Cc: stable@vger.kernel.org
Fixes: 3847ce32aea9f ("core: add tracepoints for queueing skb to rcvbuf")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/sock.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -98,7 +98,7 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_STRUCT__entry(
 		__array(char, name, 32)
-		__field(long *, sysctl_mem)
+		__array(long, sysctl_mem, 3)
 		__field(long, allocated)
 		__field(int, sysctl_rmem)
 		__field(int, rmem_alloc)
@@ -110,7 +110,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_fast_assign(
 		strncpy(__entry->name, prot->name, 32);
-		__entry->sysctl_mem = prot->sysctl_mem;
+		__entry->sysctl_mem[0] = READ_ONCE(prot->sysctl_mem[0]);
+		__entry->sysctl_mem[1] = READ_ONCE(prot->sysctl_mem[1]);
+		__entry->sysctl_mem[2] = READ_ONCE(prot->sysctl_mem[2]);
 		__entry->allocated = allocated;
 		__entry->sysctl_rmem = sk_get_rmem0(sk, prot);
 		__entry->rmem_alloc = atomic_read(&sk->sk_rmem_alloc);


