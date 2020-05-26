Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7893F1E2EA0
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389033AbgEZTAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390626AbgEZS77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A53F2084C;
        Tue, 26 May 2020 18:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519598;
        bh=lZSkrCSWq5IHgh33Yymn5+HmpEzB3rSS5qKnFSXSWGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdSiKJmX2Ejy8j82mfhv118xiVEBt20a2zd+oNHYEsPQyLybZ3qlDaQ7JsZ273+/S
         9iPMMfGjdz4fvwWC4soNhkcqjcIh4jl8vtcNfZXB7aBoN7vo7E5ka/t4YxajyISxC2
         TsE0Q59VXhPwU2iWaAlqMbOfRbzoGhfr5u8LqZAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 38/64] l2tp: hold tunnel while processing genl delete command
Date:   Tue, 26 May 2020 20:53:07 +0200
Message-Id: <20200526183925.705310414@linuxfoundation.org>
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


