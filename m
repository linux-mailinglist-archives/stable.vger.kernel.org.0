Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CCA49A4DC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387303AbiAYAE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837811AbiAXX23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71509C075944;
        Mon, 24 Jan 2022 13:33:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F095B8123A;
        Mon, 24 Jan 2022 21:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5424C340E7;
        Mon, 24 Jan 2022 21:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060032;
        bh=ABEAfmidjsjbLbKwr52w0wjGu7YGjdn3QnaXSOEAMvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NLrEb04sIQzcnspcYaHfORHQHYE7oxax7OtWHMi2hmh/mG08YiB9YoqxS3uKeSof
         FHefPtJbYIEvnLgJPGh5ZSUfBPO/l/HtO3VULk1+y2OaOqFkDAGsp7aLuMx25YpoYT
         4dGI9delSaDrqWT7ngH0Mm1locVuqfCG7DiXSWlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0816/1039] SUNRPC: Fix sockaddr handling in svcsock_accept_class trace points
Date:   Mon, 24 Jan 2022 19:43:25 +0100
Message-Id: <20220124184152.731952293@linuxfoundation.org>
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

[ Upstream commit 16720861675393a35974532b3c837d9fd7bfe08c ]

Avoid potentially hazardous memory copying and the needless use of
"%pIS" -- in the kernel, an RPC service listener is always bound to
ANYADDR. Having the network namespace is helpful when recording
errors, though.

Fixes: a0469f46faab ("SUNRPC: Replace dprintk call sites in TCP state change callouts")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sunrpc.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 52288f1c1b52d..7b5dcff84cf27 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -2147,17 +2147,17 @@ DECLARE_EVENT_CLASS(svcsock_accept_class,
 	TP_STRUCT__entry(
 		__field(long, status)
 		__string(service, service)
-		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
+		__field(unsigned int, netns_ino)
 	),
 
 	TP_fast_assign(
 		__entry->status = status;
 		__assign_str(service, service);
-		memcpy(__entry->addr, &xprt->xpt_local, sizeof(__entry->addr));
+		__entry->netns_ino = xprt->xpt_net->ns.inum;
 	),
 
-	TP_printk("listener=%pISpc service=%s status=%ld",
-		__entry->addr, __get_str(service), __entry->status
+	TP_printk("addr=listener service=%s status=%ld",
+		__get_str(service), __entry->status
 	)
 );
 
-- 
2.34.1



