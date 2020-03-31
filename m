Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296E31991A9
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgCaJMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730328AbgCaJMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:12:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21AD020787;
        Tue, 31 Mar 2020 09:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645974;
        bh=upmdMxCOQwLw4/80vqIIQ9aPaJZjTLkqmq0BnGCdU9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aw3Oc0E5Ay0qP+IkZKbPl/Y8FR1tdrZqkJWTrQTx6wABNJY+AfV563KbDQpFo4lhs
         8BuwGq8U1nrLT4y6+Vv1V34waVIJC1uBIaAiY3a1Uv4Edf5fHBoUR1GcHjlaUufIVF
         Y4GCZRPk3YXmg52KxIq2QvWKuGW5VdvWBZBJvtbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com,
        Petr Machata <petrm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 045/155] net: ip_gre: Accept IFLA_INFO_DATA-less configuration
Date:   Tue, 31 Mar 2020 10:58:05 +0200
Message-Id: <20200331085423.486368957@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 32ca98feab8c9076c89c0697c5a85e46fece809d ]

The fix referenced below causes a crash when an ERSPAN tunnel is created
without passing IFLA_INFO_DATA. Fix by validating passed-in data in the
same way as ipgre does.

Fixes: e1f8f78ffe98 ("net: ip_gre: Separate ERSPAN newlink / changelink callbacks")
Reported-by: syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1164,6 +1164,8 @@ static int erspan_netlink_parms(struct n
 	err = ipgre_netlink_parms(dev, data, tb, parms, fwmark);
 	if (err)
 		return err;
+	if (!data)
+		return 0;
 
 	if (data[IFLA_GRE_ERSPAN_VER]) {
 		t->erspan_ver = nla_get_u8(data[IFLA_GRE_ERSPAN_VER]);


