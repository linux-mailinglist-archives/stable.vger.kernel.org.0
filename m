Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F52259C65
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgIAROs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:14:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbgIAPPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:15:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C465F20BED;
        Tue,  1 Sep 2020 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973311;
        bh=pEBxRSw3TqO7gZcYEZTN6mdPju5fZa/dT5DRrcxV4UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnAWP+ofQfhmgqZoVonzmS2tFeEEZnpDRXkCpq+TnWrpsqaYtQ6mZ9B/Ecu23oAzY
         4O8lMn5A89NUEuJRSXU0Q3/6JWpFVPIdqwLCO4HoHJ9BO6AOqtn7C/qkC/EESK+ey+
         RgfIB8dQsyEi3ac95pTArJhZPj5hpQq6n70Pb2Dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Richard Alpe <richard.alpe@ericsson.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+0e7181deafa7e0b79923@syzkaller.appspotmail.com
Subject: [PATCH 4.9 04/78] tipc: fix uninit skb->data in tipc_nl_compat_dumpit()
Date:   Tue,  1 Sep 2020 17:09:40 +0200
Message-Id: <20200901150924.936560986@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150924.680106554@linuxfoundation.org>
References: <20200901150924.680106554@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 47733f9daf4fe4f7e0eb9e273f21ad3a19130487 ]

__tipc_nl_compat_dumpit() has two callers, and it expects them to
pass a valid nlmsghdr via arg->data. This header is artificial and
crafted just for __tipc_nl_compat_dumpit().

tipc_nl_compat_publ_dump() does so by putting a genlmsghdr as well
as some nested attribute, TIPC_NLA_SOCK. But the other caller
tipc_nl_compat_dumpit() does not, this leaves arg->data uninitialized
on this call path.

Fix this by just adding a similar nlmsghdr without any payload in
tipc_nl_compat_dumpit().

This bug exists since day 1, but the recent commit 6ea67769ff33
("net: tipc: prepare attrs in __tipc_nl_compat_dumpit()") makes it
easier to appear.

Reported-and-tested-by: syzbot+0e7181deafa7e0b79923@syzkaller.appspotmail.com
Fixes: d0796d1ef63d ("tipc: convert legacy nl bearer dump to nl compat")
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: Richard Alpe <richard.alpe@ericsson.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/netlink_compat.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -250,8 +250,9 @@ err_out:
 static int tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 				 struct tipc_nl_compat_msg *msg)
 {
-	int err;
+	struct nlmsghdr *nlh;
 	struct sk_buff *arg;
+	int err;
 
 	if (msg->req_type && (!msg->req_size ||
 			      !TLV_CHECK_TYPE(msg->req, msg->req_type)))
@@ -280,6 +281,15 @@ static int tipc_nl_compat_dumpit(struct
 		return -ENOMEM;
 	}
 
+	nlh = nlmsg_put(arg, 0, 0, tipc_genl_family.id, 0, NLM_F_MULTI);
+	if (!nlh) {
+		kfree_skb(arg);
+		kfree_skb(msg->rep);
+		msg->rep = NULL;
+		return -EMSGSIZE;
+	}
+	nlmsg_end(arg, nlh);
+
 	err = __tipc_nl_compat_dumpit(cmd, msg, arg);
 	if (err) {
 		kfree_skb(msg->rep);


