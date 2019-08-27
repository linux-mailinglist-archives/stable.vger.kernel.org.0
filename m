Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCCA9E03F
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbfH0IBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730990AbfH0IBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:01:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC7542186A;
        Tue, 27 Aug 2019 08:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892909;
        bh=5fBCyLdYKRJZNkGM6vIzgoTUIxN+QmUT113TZ6mjfH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiwC24HkAU3E5HOqQK/8nLt9IqwwoLTHzvHSbsy8UQwIGOZ9N74LGHbJBfsS4KFPc
         ckbiTdSYcztjRmedZdV/KSpWvI0HizJ4sGcibav/iWYeL90V1/sidNeVU+yzK+0JE4
         MeMiP19ljYVZxEAqJlFSZ5V2VIP2F36M9e7Reh1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 054/162] rxrpc: Fix the lack of notification when sendmsg() fails on a DATA packet
Date:   Tue, 27 Aug 2019 09:49:42 +0200
Message-Id: <20190827072740.084025076@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c69565ee6681e151e2bb80502930a16e04b553d1 ]

Fix the fact that a notification isn't sent to the recvmsg side to indicate
a call failed when sendmsg() fails to transmit a DATA packet with the error
ENETUNREACH, EHOSTUNREACH or ECONNREFUSED.

Without this notification, the afs client just sits there waiting for the
call to complete in some manner (which it's not now going to do), which
also pins the rxrpc call in place.

This can be seen if the client has a scope-level IPv6 address, but not a
global-level IPv6 address, and we try and transmit an operation to a
server's IPv6 address.

Looking in /proc/net/rxrpc/calls shows completed calls just sat there with
an abort code of RX_USER_ABORT and an error code of -ENETUNREACH.

Fixes: c54e43d752c7 ("rxrpc: Fix missing start of call timeout")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 5d3f33ce6d410..bae14438f8691 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -226,6 +226,7 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 			rxrpc_set_call_completion(call,
 						  RXRPC_CALL_LOCAL_ERROR,
 						  0, ret);
+			rxrpc_notify_socket(call);
 			goto out;
 		}
 		_debug("need instant resend %d", ret);
-- 
2.20.1



