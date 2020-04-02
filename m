Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A34319C807
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389836AbgDBRcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389279AbgDBRcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 13:32:07 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116A82078E;
        Thu,  2 Apr 2020 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585848726;
        bh=U20aZZ3dHYLmcqx9SScru4FwbsuOkWANxTyvJJbulzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPrrx/Z2EWbtNFETesfQK8J9rUriPxC3QF8oSN7MMG1MtHj2Uwomu3pv9rlG3yPJP
         1a5mXrxMFHuC5GOOrqEkZDSVqLKdlE4r5S1jcaHuG4NTFyoHcf++oUcVBl7ULSihz8
         M0yTy3r1/Rh1zkK+g0sj4cEZDZdBVjObS3xBIpk8=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, g.nault@alphalink.fr,
        "David S . Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 1/2] l2tp: ensure sessions are freed after their PPPOL2TP socket
Date:   Thu,  2 Apr 2020 18:31:57 +0100
Message-Id: <20200402173158.7798-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200402173158.7798-1-will@kernel.org>
References: <20200402173158.7798-1-will@kernel.org>
MIME-Version: 1.0
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
---
 net/l2tp/l2tp_ppp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 16b63e60396f..d919b3e6b548 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -437,11 +437,11 @@ static void pppol2tp_session_close(struct l2tp_session *session)
 
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
-- 
2.26.0.rc2.310.g2932bb562d-goog

