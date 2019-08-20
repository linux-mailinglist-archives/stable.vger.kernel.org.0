Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645AD960A1
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbfHTNmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730568AbfHTNmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:42:17 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50141230F2;
        Tue, 20 Aug 2019 13:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308536;
        bh=ECsyXTY3HYoxGnRCb/ZeFI/+c+Nb7sEcT1pTDulIRg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3Djf1xLNQ8jX+Rq4T2yo2soqPA3Xx0jxR2jv/Nj6bWmHpgjIOcjUL9xp0QWzR1GY
         2EzcpWvnaqU6NWfouwLkIY/DIiBsl49j1xPCSZ7OGdhpAzupSIf0zLF9I8BYBmEuCw
         qf6+/9feNVrNSYaxg9leU44meWY6EJgJpi+gLfTY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 03/27] afs: Fix the CB.ProbeUuid service handler to reply correctly
Date:   Tue, 20 Aug 2019 09:41:49 -0400
Message-Id: <20190820134213.11279-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134213.11279-1-sashal@kernel.org>
References: <20190820134213.11279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2067b2b3f4846402a040286135f98f46f8919939 ]

Fix the service handler function for the CB.ProbeUuid RPC call so that it
replies in the correct manner - that is an empty reply for success and an
abort of 1 for failure.

Putting 0 or 1 in an integer in the body of the reply should result in the
fileserver throwing an RX_PROTOCOL_ERROR abort and discarding its record of
the client; older servers, however, don't necessarily check that all the
data got consumed, and so might incorrectly think that they got a positive
response and associate the client with the wrong host record.

If the client is incorrectly associated, this will result in callbacks
intended for a different client being delivered to this one and then, when
the other client connects and responds positively, all of the callback
promises meant for the client that issued the improper response will be
lost and it won't receive any further change notifications.

Fixes: 9396d496d745 ("afs: support the CB.ProbeUuid RPC op")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cmservice.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 9e51d6fe7e8f9..40c6860d4c632 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -423,18 +423,14 @@ static void SRXAFSCB_ProbeUuid(struct work_struct *work)
 	struct afs_call *call = container_of(work, struct afs_call, work);
 	struct afs_uuid *r = call->request;
 
-	struct {
-		__be32	match;
-	} reply;
-
 	_enter("");
 
 	if (memcmp(r, &call->net->uuid, sizeof(call->net->uuid)) == 0)
-		reply.match = htonl(0);
+		afs_send_empty_reply(call);
 	else
-		reply.match = htonl(1);
+		rxrpc_kernel_abort_call(call->net->socket, call->rxcall,
+					1, 1, "K-1");
 
-	afs_send_simple_reply(call, &reply, sizeof(reply));
 	afs_put_call(call);
 	_leave("");
 }
-- 
2.20.1

