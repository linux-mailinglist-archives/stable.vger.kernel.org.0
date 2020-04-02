Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C52819C81E
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390072AbgDBRdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390070AbgDBRdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 13:33:11 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9A26212CC;
        Thu,  2 Apr 2020 17:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585848791;
        bh=Z2FGlzZ1BfBR2PNxxL1ZnwivTkdTJHsUzyKhfneWRO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXDaXMXbUKy8Go3ZN9P3GW/UBSew3QYoHHJbOW5+1xAf1otoK62lUxDGhqSna1UjL
         R0bEzNuQ3q8BC6+Rh4Ale4ZwF/x4xIOo3eDs/bMOarNASTfKsPLTqlrP1w0P0Pn24+
         P26AVibhr0KY7MuJtZf8gIu8MsB843cG3FtqHBdA=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, g.nault@alphalink.fr,
        "David S . Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 8/8] l2tp: fix race between l2tp_session_delete() and l2tp_tunnel_closeall()
Date:   Thu,  2 Apr 2020 18:32:50 +0100
Message-Id: <20200402173250.7858-9-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200402173250.7858-1-will@kernel.org>
References: <20200402173250.7858-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit b228a94066406b6c456321d69643b0d7ce11cfa6 upstream.

There are several ways to remove L2TP sessions:

  * deleting a session explicitly using the netlink interface (with
    L2TP_CMD_SESSION_DELETE),
  * deleting the session's parent tunnel (either by closing the
    tunnel's file descriptor or using the netlink interface),
  * closing the PPPOL2TP file descriptor of a PPP pseudo-wire.

In some cases, when these methods are used concurrently on the same
session, the session can be removed twice, leading to use-after-free
bugs.

This patch adds a 'dead' flag, used by l2tp_session_delete() and
l2tp_tunnel_closeall() to prevent them from stepping on each other's
toes.

The session deletion path used when closing a PPPOL2TP file descriptor
doesn't need to be adapted. It already has to ensure that a session
remains valid for the lifetime of its PPPOL2TP file descriptor.
So it takes an extra reference on the session in the ->session_close()
callback (pppol2tp_session_close()), which is eventually dropped
in the ->sk_destruct() callback of the PPPOL2TP socket
(pppol2tp_session_destruct()).
Still, __l2tp_session_unhash() and l2tp_session_queue_purge() can be
called twice and even concurrently for a given session, but thanks to
proper locking and re-initialisation of list fields, this is not an
issue.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Will Deacon <will@kernel.org>
---
 net/l2tp/l2tp_core.c | 6 ++++++
 net/l2tp/l2tp_core.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 03475b124841..2b8b5c57c7f0 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1351,6 +1351,9 @@ again:
 
 			hlist_del_init(&session->hlist);
 
+			if (test_and_set_bit(0, &session->dead))
+				goto again;
+
 			if (session->ref != NULL)
 				(*session->ref)(session);
 
@@ -1799,6 +1802,9 @@ EXPORT_SYMBOL_GPL(__l2tp_session_unhash);
  */
 int l2tp_session_delete(struct l2tp_session *session)
 {
+	if (test_and_set_bit(0, &session->dead))
+		return 0;
+
 	if (session->ref)
 		(*session->ref)(session);
 	__l2tp_session_unhash(session);
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 705fbc63ddc2..06323a12d62c 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -85,6 +85,7 @@ struct l2tp_session_cfg {
 struct l2tp_session {
 	int			magic;		/* should be
 						 * L2TP_SESSION_MAGIC */
+	long			dead;
 
 	struct l2tp_tunnel	*tunnel;	/* back pointer to tunnel
 						 * context */
-- 
2.26.0.rc2.310.g2932bb562d-goog

