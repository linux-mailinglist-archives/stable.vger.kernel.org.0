Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945B91578A0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgBJNJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:09:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbgBJMjY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:24 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A3242051A;
        Mon, 10 Feb 2020 12:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338364;
        bh=ttL+jA2FXOJkyyUzpVdZiqZa99MyLN+g+DkEIquJj2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUsXb7Na/twvtUrTIVtWaXsuFFgROqKXeW1BnL7f/RW6I/W4bhxC0UPgnLG3ktAbT
         xEXDSS2a36B8610mvuK721gaU4O5eINFbrdSluQLQi86clj9+K1zAm3daies89427q
         P4RUo8BPf9U9zTBNlt19cHm25mCDR6+/PPjHziQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Chiris <adrianc@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 007/367] net/core: Do not clear VF index for node/port GUIDs query
Date:   Mon, 10 Feb 2020 04:28:40 -0800
Message-Id: <20200210122424.498551744@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 9fbf082f569980ddd7cab348e0a118678db0e47e ]

VF numbers were assigned to node_guid and port_guid, but cleared
right before such query calls were issued. It caused to return
node/port GUIDs of VF index 0 for all VFs.

Fixes: 30aad41721e0 ("net/core: Add support for getting VF GUIDs")
Reported-by: Adrian Chiris <adrianc@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1241,6 +1241,8 @@ static noinline_for_stack int rtnl_fill_
 		return 0;
 
 	memset(&vf_vlan_info, 0, sizeof(vf_vlan_info));
+	memset(&node_guid, 0, sizeof(node_guid));
+	memset(&port_guid, 0, sizeof(port_guid));
 
 	vf_mac.vf =
 		vf_vlan.vf =
@@ -1289,8 +1291,6 @@ static noinline_for_stack int rtnl_fill_
 		    sizeof(vf_trust), &vf_trust))
 		goto nla_put_vf_failure;
 
-	memset(&node_guid, 0, sizeof(node_guid));
-	memset(&port_guid, 0, sizeof(port_guid));
 	if (dev->netdev_ops->ndo_get_vf_guid &&
 	    !dev->netdev_ops->ndo_get_vf_guid(dev, vfs_num, &node_guid,
 					      &port_guid)) {


