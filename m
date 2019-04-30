Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4899F649
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbfD3Lpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730397AbfD3Lpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:45:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1CEB21670;
        Tue, 30 Apr 2019 11:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624729;
        bh=0dMPLpWRTwRE9bcv19qswhURjqzRhN7yHwywRN8JFYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnWx58Tv3qWnyXEGop0jGBESMjSFIPkeTKcxJDcN0Wqd8mCqaf7oBNlixOvzFOk6C
         jwajo3WIhkLIienmCXi2kK0QVBYr0KtT3DEYRrW8xSNMvkCj2aVShJcJBDWwzM5TVi
         WMfZeGWgLczjUlfsIpDWTojvLdwAK8Dp6mW4Rm0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3ce8520484b0d4e260a5@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/100] tipc: handle the err returned from cmd header function
Date:   Tue, 30 Apr 2019 13:37:44 +0200
Message-Id: <20190430113609.314779227@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2ac695d1d602ce00b12170242f58c3d3a8e36d04 ]

Syzbot found a crash:

  BUG: KMSAN: uninit-value in tipc_nl_compat_name_table_dump+0x54f/0xcd0 net/tipc/netlink_compat.c:872
  Call Trace:
    tipc_nl_compat_name_table_dump+0x54f/0xcd0 net/tipc/netlink_compat.c:872
    __tipc_nl_compat_dumpit+0x59e/0xda0 net/tipc/netlink_compat.c:215
    tipc_nl_compat_dumpit+0x63a/0x820 net/tipc/netlink_compat.c:280
    tipc_nl_compat_handle net/tipc/netlink_compat.c:1226 [inline]
    tipc_nl_compat_recv+0x1b5f/0x2750 net/tipc/netlink_compat.c:1265
    genl_family_rcv_msg net/netlink/genetlink.c:601 [inline]
    genl_rcv_msg+0x185f/0x1a60 net/netlink/genetlink.c:626
    netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
    genl_rcv+0x63/0x80 net/netlink/genetlink.c:637
    netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]
    netlink_unicast+0xf3e/0x1020 net/netlink/af_netlink.c:1336
    netlink_sendmsg+0x127f/0x1300 net/netlink/af_netlink.c:1917
    sock_sendmsg_nosec net/socket.c:622 [inline]
    sock_sendmsg net/socket.c:632 [inline]

  Uninit was created at:
    __alloc_skb+0x309/0xa20 net/core/skbuff.c:208
    alloc_skb include/linux/skbuff.h:1012 [inline]
    netlink_alloc_large_skb net/netlink/af_netlink.c:1182 [inline]
    netlink_sendmsg+0xb82/0x1300 net/netlink/af_netlink.c:1892
    sock_sendmsg_nosec net/socket.c:622 [inline]
    sock_sendmsg net/socket.c:632 [inline]

It was supposed to be fixed on commit 974cb0e3e7c9 ("tipc: fix uninit-value
in tipc_nl_compat_name_table_dump") by checking TLV_GET_DATA_LEN(msg->req)
in cmd->header()/tipc_nl_compat_name_table_dump_header(), which is called
ahead of tipc_nl_compat_name_table_dump().

However, tipc_nl_compat_dumpit() doesn't handle the error returned from cmd
header function. It means even when the check added in that fix fails, it
won't stop calling tipc_nl_compat_name_table_dump(), and the issue will be
triggered again.

So this patch is to add the process for the err returned from cmd header
function in tipc_nl_compat_dumpit().

Reported-by: syzbot+3ce8520484b0d4e260a5@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 0b21187d74df..e3de41eb0000 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -267,8 +267,14 @@ static int tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 	if (msg->rep_type)
 		tipc_tlv_init(msg->rep, msg->rep_type);
 
-	if (cmd->header)
-		(*cmd->header)(msg);
+	if (cmd->header) {
+		err = (*cmd->header)(msg);
+		if (err) {
+			kfree_skb(msg->rep);
+			msg->rep = NULL;
+			return err;
+		}
+	}
 
 	arg = nlmsg_new(0, GFP_KERNEL);
 	if (!arg) {
-- 
2.19.1



