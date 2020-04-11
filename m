Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFECA1A51F2
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgDKMMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgDKMMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:12:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 098BD21744;
        Sat, 11 Apr 2020 12:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607131;
        bh=aoqivjAdPfLXCHPm7MVh9istfFKL/G+QKC2KQBc0cpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xz93EiA3+oS3Xbjz42bFENCZLlRgATkVwrICVGrU3sO0ICVVdm0EJV8mu8Q++gPuC
         UFsmcucmUvTCaK6fjdet/eWDn2vpjcCXqpfK/Iy+agTPfHG4HYPO9gisMZjtLKU1Bj
         JgTiSZIW3Pcgpl0jbECOjkBwV59cJ9T5DhMXrdiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.9 02/32] l2tp: fix race between l2tp_session_delete() and l2tp_tunnel_closeall()
Date:   Sat, 11 Apr 2020 14:08:41 +0200
Message-Id: <20200411115419.004556589@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115418.455500023@linuxfoundation.org>
References: <20200411115418.455500023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/l2tp/l2tp_core.c |    6 ++++++
 net/l2tp/l2tp_core.h |    1 +
 2 files changed, 7 insertions(+)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1351,6 +1351,9 @@ again:
 
 			hlist_del_init(&session->hlist);
 
+			if (test_and_set_bit(0, &session->dead))
+				goto again;
+
 			if (session->ref != NULL)
 				(*session->ref)(session);
 
@@ -1799,6 +1802,9 @@ EXPORT_SYMBOL_GPL(__l2tp_session_unhash)
  */
 int l2tp_session_delete(struct l2tp_session *session)
 {
+	if (test_and_set_bit(0, &session->dead))
+		return 0;
+
 	if (session->ref)
 		(*session->ref)(session);
 	__l2tp_session_unhash(session);
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -84,6 +84,7 @@ struct l2tp_session_cfg {
 struct l2tp_session {
 	int			magic;		/* should be
 						 * L2TP_SESSION_MAGIC */
+	long			dead;
 
 	struct l2tp_tunnel	*tunnel;	/* back pointer to tunnel
 						 * context */


