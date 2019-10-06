Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD88CD7A7
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbfJFRcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727680AbfJFRcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:32:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B6602080F;
        Sun,  6 Oct 2019 17:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383170;
        bh=39PRf/MVA+ao5+qMDsj3bQ/nmAdxHUb3Gi5Nx23nRz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0+am5K3uGNB+0Y0vTpS0TE1+h+rvwyI7pXDk7pxU7wHYXj7rMk0wG3L0/0sZ/OfW
         +4pOxNyr4T4EaNmyWf/zfESX3Td2J/1lEonLVvldBETx0+6UkuaYvfmYRcnFzSIeOK
         V0MLkhSWwr6pVWFsreWxZ0o+Pn7i2zJ939xAtjKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 090/106] rxrpc: Fix rxrpc_recvmsg tracepoint
Date:   Sun,  6 Oct 2019 19:21:36 +0200
Message-Id: <20191006171200.034701040@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit db9b2e0af605e7c994784527abfd9276cabd718a ]

Fix the rxrpc_recvmsg tracepoint to handle being called with a NULL call
parameter.

Fixes: a25e21f0bcd2 ("rxrpc, afs: Use debug_ids rather than pointers in traces")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rxrpc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1073,7 +1073,7 @@ TRACE_EVENT(rxrpc_recvmsg,
 			     ),
 
 	    TP_fast_assign(
-		    __entry->call = call->debug_id;
+		    __entry->call = call ? call->debug_id : 0;
 		    __entry->why = why;
 		    __entry->seq = seq;
 		    __entry->offset = offset;


