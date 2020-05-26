Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A391E2EA8
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390672AbgEZTAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390664AbgEZTAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:00:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA3F52084C;
        Tue, 26 May 2020 19:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519613;
        bh=kik3Qx3CFXylBjXJOWdBex/IgBTrkggAbEtn0sCLsv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvCUOHSqz5cX5JZqA3N96CZFEAuDdNVKUl2DcjR7jm0TC2LE1h4F0snc2xzRa57JA
         oj4gi8OfcbF8JaY3EkE56JcW45FFje01Rrn8gyA15rjkdClmrjQwq4Qtuc47KwUFjq
         JBlspio/FSH2EzEU9VncK1O06xKbP+AGX894NF4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 34/64] l2tp: define parameters of l2tp_session_get*() as "const"
Date:   Tue, 26 May 2020 20:53:03 +0200
Message-Id: <20200526183923.990064664@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit 9aaef50c44f132e040dcd7686c8e78a3390037c5 upstream.

Make l2tp_pernet()'s parameter constant, so that l2tp_session_get*() can
declare their "net" variable as "const".
Also constify "ifname" in l2tp_session_get_by_ifname().

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |    7 ++++---
 net/l2tp/l2tp_core.h |    5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -119,7 +119,7 @@ static inline struct l2tp_tunnel *l2tp_t
 	return sk->sk_user_data;
 }
 
-static inline struct l2tp_net *l2tp_pernet(struct net *net)
+static inline struct l2tp_net *l2tp_pernet(const struct net *net)
 {
 	BUG_ON(!net);
 
@@ -231,7 +231,7 @@ l2tp_session_id_hash(struct l2tp_tunnel
 /* Lookup a session. A new reference is held on the returned session.
  * Optionally calls session->ref() too if do_ref is true.
  */
-struct l2tp_session *l2tp_session_get(struct net *net,
+struct l2tp_session *l2tp_session_get(const struct net *net,
 				      struct l2tp_tunnel *tunnel,
 				      u32 session_id, bool do_ref)
 {
@@ -306,7 +306,8 @@ EXPORT_SYMBOL_GPL(l2tp_session_get_nth);
 /* Lookup a session by interface name.
  * This is very inefficient but is only used by management interfaces.
  */
-struct l2tp_session *l2tp_session_get_by_ifname(struct net *net, char *ifname,
+struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
+						const char *ifname,
 						bool do_ref)
 {
 	struct l2tp_net *pn = l2tp_pernet(net);
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -231,12 +231,13 @@ out:
 	return tunnel;
 }
 
-struct l2tp_session *l2tp_session_get(struct net *net,
+struct l2tp_session *l2tp_session_get(const struct net *net,
 				      struct l2tp_tunnel *tunnel,
 				      u32 session_id, bool do_ref);
 struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth,
 					  bool do_ref);
-struct l2tp_session *l2tp_session_get_by_ifname(struct net *net, char *ifname,
+struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
+						const char *ifname,
 						bool do_ref);
 struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id);
 struct l2tp_tunnel *l2tp_tunnel_find_nth(struct net *net, int nth);


