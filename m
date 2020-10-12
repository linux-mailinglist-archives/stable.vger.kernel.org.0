Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2FA28B961
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388691AbgJLOAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731452AbgJLNju (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:39:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4DBD20838;
        Mon, 12 Oct 2020 13:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509989;
        bh=ty/XQN42QxF/uv2gSCu9I9A4/6LWpqHXIWZwyrgsVV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6hOw0LMbUAbn5o+0iutUREOsYLfKp0iitzd04eQTsA48LDeuT9Dyo5Ix+rlnHYeX
         xhts8tsFsTjEGpy/NUIl2mh1u/0JFh5QVZiQeMlYzNCw9V05r5blahAXFqbDFrIZgQ
         9/soYB1sWx+MR35JOh50KJVZS4Yhm41Tp/OcIVB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/49] rxrpc: Fix some missing _bh annotations on locking conn->state_lock
Date:   Mon, 12 Oct 2020 15:27:30 +0200
Message-Id: <20201012132631.436768553@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
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
index 126154a97a592..04213afd7710f 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -342,18 +342,18 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
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



