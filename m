Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2CA1A4FCB
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgDKMLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgDKMLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:11:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B89821D6C;
        Sat, 11 Apr 2020 12:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607104;
        bh=MmvJFYQiUuoxCAfLFMHbzJ4bdL7Mc7UdVF9VMoB1uOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zBIRoC3GAMbjNlWtPnjIBuvOHlflW2bya2IXrPvnfHBnvN9EQHEhzQPElINn1sMKD
         zKVuoYmastJg4X96+0RufgvlROHUzQYJLJUsBC6Nhcz/dYL0ItLLAPg41UfufZ9H6W
         zGe1n9Aus74k6pqvDpAUg/y++CTzL0QTaWGfT4+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.9 01/32] l2tp: ensure sessions are freed after their PPPOL2TP socket
Date:   Sat, 11 Apr 2020 14:08:40 +0200
Message-Id: <20200411115418.843920874@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115418.455500023@linuxfoundation.org>
References: <20200411115418.455500023@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit cdd10c9627496ad25c87ce6394e29752253c69d3 upstream.

If l2tp_tunnel_delete() or l2tp_tunnel_closeall() deletes a session
right after pppol2tp_release() orphaned its socket, then the 'sock'
variable of the pppol2tp_session_close() callback is NULL. Yet the
session is still used by pppol2tp_release().

Therefore we need to take an extra reference in any case, to prevent
l2tp_tunnel_delete() or l2tp_tunnel_closeall() from freeing the session.

Since the pppol2tp_session_close() callback is only set if the session
is associated to a PPPOL2TP socket and that both l2tp_tunnel_delete()
and l2tp_tunnel_closeall() hold the PPPOL2TP socket before calling
pppol2tp_session_close(), we're sure that pppol2tp_session_close() and
pppol2tp_session_destruct() are paired and called in the right order.
So the reference taken by the former will be released by the later.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/l2tp/l2tp_ppp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -437,11 +437,11 @@ static void pppol2tp_session_close(struc
 
 	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
 
-	if (sock) {
+	if (sock)
 		inet_shutdown(sock, SEND_SHUTDOWN);
-		/* Don't let the session go away before our socket does */
-		l2tp_session_inc_refcount(session);
-	}
+
+	/* Don't let the session go away before our socket does */
+	l2tp_session_inc_refcount(session);
 }
 
 /* Really kill the session socket. (Called from sock_put() if


