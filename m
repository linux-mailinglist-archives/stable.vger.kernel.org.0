Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28903DA585
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbhG2OCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238465AbhG2OA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 10:00:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA0C761054;
        Thu, 29 Jul 2021 13:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567175;
        bh=grUaTF2TqPMP7+8rV+DF67i7oeqjiW5BPvbjkAs20xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hA5wxfSnacs7Mul/EB4SUM68OqdWWekuGNQN/EUMaL75CrScgHpE+2qgao7Tp8y7G
         Rtnwnl5h+e4FYMBbMDSa7Naf620Y52MKjxzCgX69Bzdx0GV3ofzjpuvqHXTATXadrl
         CrfU4DIFeME/IUId3e77/pyQmFy6BDgmiVmmkCh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 05/22] net/802/garp: fix memleak in garp_request_join()
Date:   Thu, 29 Jul 2021 15:54:36 +0200
Message-Id: <20210729135137.510821872@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
References: <20210729135137.336097792@linuxfoundation.org>
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
index 400bd857e5f5..f6012f8e59f0 100644
--- a/net/802/garp.c
+++ b/net/802/garp.c
@@ -203,6 +203,19 @@ static void garp_attr_destroy(struct garp_applicant *app, struct garp_attr *attr
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
@@ -609,6 +622,7 @@ void garp_uninit_applicant(struct net_device *dev, struct garp_application *appl
 
 	spin_lock_bh(&app->lock);
 	garp_gid_event(app, GARP_EVENT_TRANSMIT_PDU);
+	garp_attr_destroy_all(app);
 	garp_pdu_queue(app);
 	spin_unlock_bh(&app->lock);
 
-- 
2.30.2



