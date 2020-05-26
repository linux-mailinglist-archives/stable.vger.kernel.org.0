Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01AA1E2EE8
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390843AbgEZTck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390058AbgEZS5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:57:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 790CB2151B;
        Tue, 26 May 2020 18:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519436;
        bh=lZSkrCSWq5IHgh33Yymn5+HmpEzB3rSS5qKnFSXSWGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQr/oyezG9ZQgh/eZmxGIpxAFqbLrH8hWA2SMoEZhwC6/zPl7dB2nHtwh0x4NadvJ
         K7E5AmusEIS6FO/AWkg1QqomajHynvF6K4Y0wSlaX7gjJxMSaAyCJxD2YPK3TCcc2q
         r89vo6ha6WPonYx3GjziLe1snJnpSEIyf15OfkFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 50/65] l2tp: hold tunnel while processing genl delete command
Date:   Tue, 26 May 2020 20:53:09 +0200
Message-Id: <20200526183923.358855333@linuxfoundation.org>
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

commit bb0a32ce4389e17e47e198d2cddaf141561581ad upstream.

l2tp_nl_cmd_tunnel_delete() needs to take a reference on the tunnel, to
prevent it from being concurrently freed by l2tp_tunnel_destruct().

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_netlink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -280,8 +280,8 @@ static int l2tp_nl_cmd_tunnel_delete(str
 	}
 	tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
 
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel == NULL) {
+	tunnel = l2tp_tunnel_get(net, tunnel_id);
+	if (!tunnel) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -291,6 +291,8 @@ static int l2tp_nl_cmd_tunnel_delete(str
 
 	l2tp_tunnel_delete(tunnel);
 
+	l2tp_tunnel_dec_refcount(tunnel);
+
 out:
 	return ret;
 }


