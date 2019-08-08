Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB40B869C3
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405338AbfHHTKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404950AbfHHTKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:10:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16F4A2184E;
        Thu,  8 Aug 2019 19:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291439;
        bh=g8nANGYIFzqLcRbz1W4HcPaeJTDSNW5/rBxQlHopmJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJ5i7f68mrX4wKnh8bLj5zBKxEVma+Ul8FkV5ql+iG4eRHcyg2kjq4UUhYsz5EN10
         o+2epecX80cf4ArpLuZV5T7PHZiEV6LGlvt1QDiXL802CMkM5rfmZFIH0iwQYLgRia
         5PuufaMMjfAljOVFBN6vJPWvNKJ9pOwVOf0Mtstw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 15/33] net: bridge: delete local fdb on device init failure
Date:   Thu,  8 Aug 2019 21:05:22 +0200
Message-Id: <20190808190454.326369843@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit d7bae09fa008c6c9a489580db0a5a12063b97f97 ]

On initialization failure we have to delete the local fdb which was
inserted due to the default pvid creation. This problem has been present
since the inception of default_pvid. Note that currently there are 2 cases:
1) in br_dev_init() when br_multicast_init() fails
2) if register_netdevice() fails after calling ndo_init()

This patch takes care of both since br_vlan_flush() is called on both
occasions. Also the new fdb delete would be a no-op on normal bridge
device destruction since the local fdb would've been already flushed by
br_dev_delete(). This is not an issue for ports since nbp_vlan_init() is
called last when adding a port thus nothing can fail after it.

Reported-by: syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com
Fixes: 5be5a2df40f0 ("bridge: Add filtering support for default_pvid")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_vlan.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -636,6 +636,11 @@ void br_vlan_flush(struct net_bridge *br
 
 	ASSERT_RTNL();
 
+	/* delete auto-added default pvid local fdb before flushing vlans
+	 * otherwise it will be leaked on bridge device init failure
+	 */
+	br_fdb_delete_by_port(br, NULL, 0, 1);
+
 	vg = br_vlan_group(br);
 	__vlan_flush(vg);
 	RCU_INIT_POINTER(br->vlgrp, NULL);


