Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29B53DA4EC
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbhG2N5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238015AbhG2N4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:56:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12D6160F48;
        Thu, 29 Jul 2021 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567009;
        bh=Fvu85sAjs319dWKeZiap0oOOGT1ZpqeMqQ0Tf/uMgwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0t2aj0kZtXoRx4NcSlqsqOiLgoqcxdFBUj+eMfRgq1g51Lq9kv9/uVTYdA4GZw/8g
         AP7n3YlLC1PRdPmlJLaeFqCu0gi9z9jcxvdNM2baYBSYW3+GVhEU4Hx/27YOnkvnxY
         FFU5Lyap+sEqX2iPHnj5Lh3ayENdNyTWaRcWs6Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/17] net/802/garp: fix memleak in garp_request_join()
Date:   Thu, 29 Jul 2021 15:54:09 +0200
Message-Id: <20210729135137.525541234@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
References: <20210729135137.260993951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 42ca63f980842918560b25f0244307fd83b4777c ]

I got kmemleak report when doing fuzz test:

BUG: memory leak
unreferenced object 0xffff88810c909b80 (size 64):
  comm "syz", pid 957, jiffies 4295220394 (age 399.090s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 08 00 00 00 01 02 00 04  ................
  backtrace:
    [<00000000ca1f2e2e>] garp_request_join+0x285/0x3d0
    [<00000000bf153351>] vlan_gvrp_request_join+0x15b/0x190
    [<0000000024005e72>] vlan_dev_open+0x706/0x980
    [<00000000dc20c4d4>] __dev_open+0x2bb/0x460
    [<0000000066573004>] __dev_change_flags+0x501/0x650
    [<0000000035b42f83>] rtnl_configure_link+0xee/0x280
    [<00000000a5e69de0>] __rtnl_newlink+0xed5/0x1550
    [<00000000a5258f4a>] rtnl_newlink+0x66/0x90
    [<00000000506568ee>] rtnetlink_rcv_msg+0x439/0xbd0
    [<00000000b7eaeae1>] netlink_rcv_skb+0x14d/0x420
    [<00000000c373ce66>] netlink_unicast+0x550/0x750
    [<00000000ec74ce74>] netlink_sendmsg+0x88b/0xda0
    [<00000000381ff246>] sock_sendmsg+0xc9/0x120
    [<000000008f6a2db3>] ____sys_sendmsg+0x6e8/0x820
    [<000000008d9c1735>] ___sys_sendmsg+0x145/0x1c0
    [<00000000aa39dd8b>] __sys_sendmsg+0xfe/0x1d0

Calling garp_request_leave() after garp_request_join(), the attr->state
is set to GARP_APPLICANT_VO, garp_attr_destroy() won't be called in last
transmit event in garp_uninit_applicant(), the attr of applicant will be
leaked. To fix this leak, iterate and free each attr of applicant before
rerturning from garp_uninit_applicant().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/802/garp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/802/garp.c b/net/802/garp.c
index 7f50d47470bd..8e19f51833d6 100644
--- a/net/802/garp.c
+++ b/net/802/garp.c
@@ -206,6 +206,19 @@ static void garp_attr_destroy(struct garp_applicant *app, struct garp_attr *attr
 	kfree(attr);
 }
 
+static void garp_attr_destroy_all(struct garp_applicant *app)
+{
+	struct rb_node *node, *next;
+	struct garp_attr *attr;
+
+	for (node = rb_first(&app->gid);
+	     next = node ? rb_next(node) : NULL, node != NULL;
+	     node = next) {
+		attr = rb_entry(node, struct garp_attr, node);
+		garp_attr_destroy(app, attr);
+	}
+}
+
 static int garp_pdu_init(struct garp_applicant *app)
 {
 	struct sk_buff *skb;
@@ -612,6 +625,7 @@ void garp_uninit_applicant(struct net_device *dev, struct garp_application *appl
 
 	spin_lock_bh(&app->lock);
 	garp_gid_event(app, GARP_EVENT_TRANSMIT_PDU);
+	garp_attr_destroy_all(app);
 	garp_pdu_queue(app);
 	spin_unlock_bh(&app->lock);
 
-- 
2.30.2



