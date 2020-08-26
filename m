Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C04252D93
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgHZMDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729484AbgHZMC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 08:02:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D73420786;
        Wed, 26 Aug 2020 12:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443377;
        bh=RmXL/1u0VAWNbKLafrCpKWutDzDTHZH6Cc5wbc73xbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2mb+jiFtFoM8nZsakS4jNxo2a/D2iin9vayTfEOXlIWYi4Xk1g5f4+BG9H/ODY/3v
         x56+98IGMAvsUix4H3CapMt04DRwsKrPgYCirVqZ66k9AEpr+NF3KVvrrQfb4NKgaR
         vBrl9wRtd1M4Ky3rbGfRyejtpCwMwJ1yyQN1VQGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Richard Alpe <richard.alpe@ericsson.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+0e7181deafa7e0b79923@syzkaller.appspotmail.com
Subject: [PATCH 5.7 09/15] tipc: fix uninit skb->data in tipc_nl_compat_dumpit()
Date:   Wed, 26 Aug 2020 14:02:37 +0200
Message-Id: <20200826114849.751629016@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826114849.295321031@linuxfoundation.org>
References: <20200826114849.295321031@linuxfoundation.org>
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
@@ -275,8 +275,9 @@ err_out:
 static int tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 				 struct tipc_nl_compat_msg *msg)
 {
-	int err;
+	struct nlmsghdr *nlh;
 	struct sk_buff *arg;
+	int err;
 
 	if (msg->req_type && (!msg->req_size ||
 			      !TLV_CHECK_TYPE(msg->req, msg->req_type)))
@@ -305,6 +306,15 @@ static int tipc_nl_compat_dumpit(struct
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


