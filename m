Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACB528B783
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389418AbgJLNoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731569AbgJLNm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:42:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86E622065C;
        Mon, 12 Oct 2020 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510178;
        bh=VaxD0FgZC4wD3Zf23NpCkmSZ+Xts0XxuKwdoUeFe6uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDtnLmT1+pcr3Ctl6i3siPNqaTKNOaXh/1qVt177pVutF71I5/psa7B9+jy/wXod/
         hT1N6ovH0K/n7ohaidZu9blt9HtgQAOeOzFGztjqqL/iDGhW7CZ9tEz5zcLZpAmYXo
         10mcumFLnTVtZvKRS3up/X6NfG53Npb+DdmIBLJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 72/85] rxrpc: Fix some missing _bh annotations on locking conn->state_lock
Date:   Mon, 12 Oct 2020 15:27:35 +0200
Message-Id: <20201012132636.309387284@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit fa1d113a0f96f9ab7e4fe4f8825753ba1e34a9d3 ]

conn->state_lock may be taken in softirq mode, but a previous patch
replaced an outer lock in the response-packet event handling code, and lost
the _bh from that when doing so.

Fix this by applying the _bh annotation to the state_lock locking.

Fixes: a1399f8bb033 ("rxrpc: Call channels should have separate call number spaces")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/conn_event.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 06fcff2ebbba1..b5864683f200d 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -341,18 +341,18 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 			return ret;
 
 		spin_lock(&conn->channel_lock);
-		spin_lock(&conn->state_lock);
+		spin_lock_bh(&conn->state_lock);
 
 		if (conn->state == RXRPC_CONN_SERVICE_CHALLENGING) {
 			conn->state = RXRPC_CONN_SERVICE;
-			spin_unlock(&conn->state_lock);
+			spin_unlock_bh(&conn->state_lock);
 			for (loop = 0; loop < RXRPC_MAXCALLS; loop++)
 				rxrpc_call_is_secure(
 					rcu_dereference_protected(
 						conn->channels[loop].call,
 						lockdep_is_held(&conn->channel_lock)));
 		} else {
-			spin_unlock(&conn->state_lock);
+			spin_unlock_bh(&conn->state_lock);
 		}
 
 		spin_unlock(&conn->channel_lock);
-- 
2.25.1



