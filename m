Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA68300643
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbhAVOzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:55:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728102AbhAVOXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F92423B86;
        Fri, 22 Jan 2021 14:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325078;
        bh=Ezrq2UMDPmiA5cdvtmkULodDY1ScrX4C2r0E2sELQZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdPWxgkAe0Ft9/Xvl3mK+24wqymC+qAHzbpewht/CUumsf1GFVL6Ahy2Qt383agU7
         l2zK2abJwJruKpjNQ0lT9XJhqKScYhmMx1jUmnSuOzDfO0jqEiHbBUvK/RoxdWbNd9
         cipl5Dpn1Nw++/UgpnlCc4HFsJKZEzzyTYbB53q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 24/33] rxrpc: Call state should be read with READ_ONCE() under some circumstances
Date:   Fri, 22 Jan 2021 15:12:40 +0100
Message-Id: <20210122135734.553550962@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baptiste Lepers <baptiste.lepers@gmail.com>

[ Upstream commit a95d25dd7b94a5ba18246da09b4218f132fed60e ]

The call state may be changed at any time by the data-ready routine in
response to received packets, so if the call state is to be read and acted
upon several times in a function, READ_ONCE() must be used unless the call
state lock is held.

As it happens, we used READ_ONCE() to read the state a few lines above the
unmarked read in rxrpc_input_data(), so use that value rather than
re-reading it.

Fixes: a158bdd3247b ("rxrpc: Fix call timeouts")
Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/161046715522.2450566.488819910256264150.stgit@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -431,7 +431,7 @@ static void rxrpc_input_data(struct rxrp
 		return;
 	}
 
-	if (call->state == RXRPC_CALL_SERVER_RECV_REQUEST) {
+	if (state == RXRPC_CALL_SERVER_RECV_REQUEST) {
 		unsigned long timo = READ_ONCE(call->next_req_timo);
 		unsigned long now, expect_req_by;
 


