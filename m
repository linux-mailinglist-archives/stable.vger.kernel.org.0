Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C521E2EEA
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390034AbgEZS5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390013AbgEZS5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:57:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88DE42084C;
        Tue, 26 May 2020 18:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519426;
        bh=wf0ZVFQ7x8anE5OuhsDIZiFHHWobosTKSUdq6cG++ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeYnVC3osavgoKhILJxHVq2nG+Arc5dsal55SNaYqlJHGIXACeC5EhmcTz1DTBOnn
         shsoc7B1FtblIybmNTNsIlmXKT0Kz1SS3NsfPbaGA0Bcn3j2XYspE/RzzMvFfi/jjB
         hX8alvCiDWhcUpu66XmH6/1AQEl3+OG2Rf/HYGQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 47/65] l2tp: define parameters of l2tp_tunnel_find*() as "const"
Date:   Tue, 26 May 2020 20:53:06 +0200
Message-Id: <20200526183922.327475322@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit 2f858b928bf5a8174911aaec76b8b72a9ca0533d upstream.

l2tp_tunnel_find() and l2tp_tunnel_find_nth() don't modify "net".

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |    4 ++--
 net/l2tp/l2tp_core.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -378,7 +378,7 @@ exist:
 
 /* Lookup a tunnel by id
  */
-struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id)
+struct l2tp_tunnel *l2tp_tunnel_find(const struct net *net, u32 tunnel_id)
 {
 	struct l2tp_tunnel *tunnel;
 	struct l2tp_net *pn = l2tp_pernet(net);
@@ -396,7 +396,7 @@ struct l2tp_tunnel *l2tp_tunnel_find(str
 }
 EXPORT_SYMBOL_GPL(l2tp_tunnel_find);
 
-struct l2tp_tunnel *l2tp_tunnel_find_nth(struct net *net, int nth)
+struct l2tp_tunnel *l2tp_tunnel_find_nth(const struct net *net, int nth)
 {
 	struct l2tp_net *pn = l2tp_pernet(net);
 	struct l2tp_tunnel *tunnel;
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -242,8 +242,8 @@ struct l2tp_session *l2tp_session_get_nt
 struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
 						const char *ifname,
 						bool do_ref);
-struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id);
-struct l2tp_tunnel *l2tp_tunnel_find_nth(struct net *net, int nth);
+struct l2tp_tunnel *l2tp_tunnel_find(const struct net *net, u32 tunnel_id);
+struct l2tp_tunnel *l2tp_tunnel_find_nth(const struct net *net, int nth);
 
 int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id,
 		       u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg,


