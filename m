Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67DA1E2EA9
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390538AbgEZTaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390639AbgEZTAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:00:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0182C2084C;
        Tue, 26 May 2020 19:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519603;
        bh=gpZmhsnwNHdyJCaMvj9OyCG9hcuSd46Tspnmci5xZsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YT09Gv5h0lsoNrV3Xly3VRO4l4sYijWKepz/SxB0uVsJ3tc857C3naDbauD1NsteK
         +yLbOcLcrwkYKbV2IAvjwgEV0Gwpb/nRzKkITnKvuNYd3cHTc/eEYe70Tn/NDVGsWN
         JQjT/x59mrGXNrEYZG8VvbfGZDOfvc94SjwKxk6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 40/64] l2tp: hold tunnel while handling genl TUNNEL_GET commands
Date:   Tue, 26 May 2020 20:53:09 +0200
Message-Id: <20200526183926.706282045@linuxfoundation.org>
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

commit 4e4b21da3acc68a7ea55f850cacc13706b7480e9 upstream.

Use l2tp_tunnel_get() instead of l2tp_tunnel_find() so that we get
a reference on the tunnel, preventing l2tp_tunnel_destruct() from
freeing it from under us.

Also move l2tp_tunnel_get() below nlmsg_new() so that we only take
the reference when needed.

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_netlink.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -436,34 +436,37 @@ static int l2tp_nl_cmd_tunnel_get(struct
 
 	if (!info->attrs[L2TP_ATTR_CONN_ID]) {
 		ret = -EINVAL;
-		goto out;
+		goto err;
 	}
 
 	tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
 
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel == NULL) {
-		ret = -ENODEV;
-		goto out;
-	}
-
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg) {
 		ret = -ENOMEM;
-		goto out;
+		goto err;
+	}
+
+	tunnel = l2tp_tunnel_get(net, tunnel_id);
+	if (!tunnel) {
+		ret = -ENODEV;
+		goto err_nlmsg;
 	}
 
 	ret = l2tp_nl_tunnel_send(msg, info->snd_portid, info->snd_seq,
 				  NLM_F_ACK, tunnel, L2TP_CMD_TUNNEL_GET);
 	if (ret < 0)
-		goto err_out;
+		goto err_nlmsg_tunnel;
+
+	l2tp_tunnel_dec_refcount(tunnel);
 
 	return genlmsg_unicast(net, msg, info->snd_portid);
 
-err_out:
+err_nlmsg_tunnel:
+	l2tp_tunnel_dec_refcount(tunnel);
+err_nlmsg:
 	nlmsg_free(msg);
-
-out:
+err:
 	return ret;
 }
 


