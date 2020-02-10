Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF15D1578B3
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgBJNJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:09:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729387AbgBJMjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:18 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C582420661;
        Mon, 10 Feb 2020 12:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338357;
        bh=88zAnXw2hLqc8dBEYZYPem3Likizp9uLRhvjzs2exSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsP0tKvnr+eyE7+uchr3EiAs/LJKoNezv/aS42O1MyNgP/iDo3/6ZcpXbWEQG+WJ8
         jzIa0BXUS/Pd3Mftju8YjMSsohouoRzHzlIdNmY8sW2OXuFEJaFCUSXnOD8a9VIzHd
         kdpCg65lo2TVNsGzrhemjIqxkzINca5xvbpHJdis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.5 016/367] rxrpc: Fix use-after-free in rxrpc_put_local()
Date:   Mon, 10 Feb 2020 04:28:49 -0800
Message-Id: <20200210122425.363774826@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit fac20b9e738523fc884ee3ea5be360a321cd8bad ]

Fix rxrpc_put_local() to not access local->debug_id after calling
atomic_dec_return() as, unless that returned n==0, we no longer have the
right to access the object.

Fixes: 06d9532fa6b3 ("rxrpc: Fix read-after-free in rxrpc_queue_local()")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/local_object.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -364,11 +364,14 @@ void rxrpc_queue_local(struct rxrpc_loca
 void rxrpc_put_local(struct rxrpc_local *local)
 {
 	const void *here = __builtin_return_address(0);
+	unsigned int debug_id;
 	int n;
 
 	if (local) {
+		debug_id = local->debug_id;
+
 		n = atomic_dec_return(&local->usage);
-		trace_rxrpc_local(local->debug_id, rxrpc_local_put, n, here);
+		trace_rxrpc_local(debug_id, rxrpc_local_put, n, here);
 
 		if (n == 0)
 			call_rcu(&local->rcu, rxrpc_local_rcu);


