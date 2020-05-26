Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305901E2A9B
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389278AbgEZS5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389286AbgEZS5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:57:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE9FF20849;
        Tue, 26 May 2020 18:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519439;
        bh=KM+T7rK8LxTAusvClFFwqtI7Ma/8JjMwgBpdJRCQE5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6T0SUYmJvX9NslT6Ack8RgIRRRYkhvbPWLXkfi2Zx+H2k0Jdgfb5+yJGKW/0AjOk
         zOLCfrG6YJVmlaRjNVn1d38eVEFkdyqtR0MXjn7VzDFlQJt57wZpm8VJk0K2zp3LwE
         oWdIoGUqfEIzOe6Ld7+pdXLHQy/ObrZIPltS+DxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 51/65] l2tp: hold tunnel while handling genl tunnel updates
Date:   Tue, 26 May 2020 20:53:10 +0200
Message-Id: <20200526183923.939203552@linuxfoundation.org>
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

commit 8c0e421525c9eb50d68e8f633f703ca31680b746 upstream.

We need to make sure the tunnel is not going to be destroyed by
l2tp_tunnel_destruct() concurrently.

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
@@ -310,8 +310,8 @@ static int l2tp_nl_cmd_tunnel_modify(str
 	}
 	tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
 
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel == NULL) {
+	tunnel = l2tp_tunnel_get(net, tunnel_id);
+	if (!tunnel) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -322,6 +322,8 @@ static int l2tp_nl_cmd_tunnel_modify(str
 	ret = l2tp_tunnel_notify(&l2tp_nl_family, info,
 				 tunnel, L2TP_CMD_TUNNEL_MODIFY);
 
+	l2tp_tunnel_dec_refcount(tunnel);
+
 out:
 	return ret;
 }


