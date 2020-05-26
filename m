Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EF91E2EA2
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390021AbgEZTAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390644AbgEZTAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:00:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7297820849;
        Tue, 26 May 2020 19:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519605;
        bh=XzcxUG96yYozFT5O6RsP3Qq4X3YArpZiW7G+yLJC4WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16OIlOTRmoQBkRfr2hMfaHFLkGr3cVZQdmgXkz2d5cza77xc50J1Zsl8rbrAwNE2r
         OfdVaS1Jhh4kzP5nqDq33Sy05OUERfFOVTY+2Ggd3abEAJ6lBrfoIqAW8Xat66i3XS
         Rd8P3zrmkiSNbYXb/QHJiOqbGfTPVgHPynUFO5E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 41/64] l2tp: hold tunnel used while creating sessions with netlink
Date:   Tue, 26 May 2020 20:53:10 +0200
Message-Id: <20200526183927.391843059@linuxfoundation.org>
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

commit e702c1204eb57788ef189c839c8c779368267d70 upstream.

Use l2tp_tunnel_get() to retrieve tunnel, so that it can't go away on
us. Otherwise l2tp_tunnel_destruct() might release the last reference
count concurrently, thus freeing the tunnel while we're using it.

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_netlink.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -510,8 +510,9 @@ static int l2tp_nl_cmd_session_create(st
 		ret = -EINVAL;
 		goto out;
 	}
+
 	tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
+	tunnel = l2tp_tunnel_get(net, tunnel_id);
 	if (!tunnel) {
 		ret = -ENODEV;
 		goto out;
@@ -519,24 +520,24 @@ static int l2tp_nl_cmd_session_create(st
 
 	if (!info->attrs[L2TP_ATTR_SESSION_ID]) {
 		ret = -EINVAL;
-		goto out;
+		goto out_tunnel;
 	}
 	session_id = nla_get_u32(info->attrs[L2TP_ATTR_SESSION_ID]);
 
 	if (!info->attrs[L2TP_ATTR_PEER_SESSION_ID]) {
 		ret = -EINVAL;
-		goto out;
+		goto out_tunnel;
 	}
 	peer_session_id = nla_get_u32(info->attrs[L2TP_ATTR_PEER_SESSION_ID]);
 
 	if (!info->attrs[L2TP_ATTR_PW_TYPE]) {
 		ret = -EINVAL;
-		goto out;
+		goto out_tunnel;
 	}
 	cfg.pw_type = nla_get_u16(info->attrs[L2TP_ATTR_PW_TYPE]);
 	if (cfg.pw_type >= __L2TP_PWTYPE_MAX) {
 		ret = -EINVAL;
-		goto out;
+		goto out_tunnel;
 	}
 
 	if (tunnel->version > 2) {
@@ -555,7 +556,7 @@ static int l2tp_nl_cmd_session_create(st
 			u16 len = nla_len(info->attrs[L2TP_ATTR_COOKIE]);
 			if (len > 8) {
 				ret = -EINVAL;
-				goto out;
+				goto out_tunnel;
 			}
 			cfg.cookie_len = len;
 			memcpy(&cfg.cookie[0], nla_data(info->attrs[L2TP_ATTR_COOKIE]), len);
@@ -564,7 +565,7 @@ static int l2tp_nl_cmd_session_create(st
 			u16 len = nla_len(info->attrs[L2TP_ATTR_PEER_COOKIE]);
 			if (len > 8) {
 				ret = -EINVAL;
-				goto out;
+				goto out_tunnel;
 			}
 			cfg.peer_cookie_len = len;
 			memcpy(&cfg.peer_cookie[0], nla_data(info->attrs[L2TP_ATTR_PEER_COOKIE]), len);
@@ -607,7 +608,7 @@ static int l2tp_nl_cmd_session_create(st
 	if ((l2tp_nl_cmd_ops[cfg.pw_type] == NULL) ||
 	    (l2tp_nl_cmd_ops[cfg.pw_type]->session_create == NULL)) {
 		ret = -EPROTONOSUPPORT;
-		goto out;
+		goto out_tunnel;
 	}
 
 	/* Check that pseudowire-specific params are present */
@@ -617,7 +618,7 @@ static int l2tp_nl_cmd_session_create(st
 	case L2TP_PWTYPE_ETH_VLAN:
 		if (!info->attrs[L2TP_ATTR_VLAN_ID]) {
 			ret = -EINVAL;
-			goto out;
+			goto out_tunnel;
 		}
 		break;
 	case L2TP_PWTYPE_ETH:
@@ -645,6 +646,8 @@ static int l2tp_nl_cmd_session_create(st
 		}
 	}
 
+out_tunnel:
+	l2tp_tunnel_dec_refcount(tunnel);
 out:
 	return ret;
 }


