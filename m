Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2D0F842
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbfD3LlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727730AbfD3LlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:41:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23D6B21734;
        Tue, 30 Apr 2019 11:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624460;
        bh=J0ShUQzD1srjF3bzW26x95MrxhY7MvI01lJ6PQT1qB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZVXc4ov0lAHZXocFF4vnuyo+6CyRweBmg8ALnuTNJGybeFnibZLLjlSIRQfefKLQ
         8CSAtZyJU7f0Bz6Iu/6K66oJtbd5IdDRfMUT1j7o/KPopDtCWo3ySm6ShEeHWXm0Wt
         C0r57OpaUIQPUTkvnDr4corWAgOi5c+OdNdVpNH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8b707430713eb46e1e45@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 27/41] tipc: check bearer name with right length in tipc_nl_compat_bearer_enable
Date:   Tue, 30 Apr 2019 13:38:38 +0200
Message-Id: <20190430113531.206287981@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 6f07e5f06c8712acc423485f657799fc8e11e56c upstream.

Syzbot reported the following crash:

BUG: KMSAN: uninit-value in memchr+0xce/0x110 lib/string.c:961
  memchr+0xce/0x110 lib/string.c:961
  string_is_valid net/tipc/netlink_compat.c:176 [inline]
  tipc_nl_compat_bearer_enable+0x2c4/0x910 net/tipc/netlink_compat.c:401
  __tipc_nl_compat_doit net/tipc/netlink_compat.c:321 [inline]
  tipc_nl_compat_doit+0x3aa/0xaf0 net/tipc/netlink_compat.c:354
  tipc_nl_compat_handle net/tipc/netlink_compat.c:1162 [inline]
  tipc_nl_compat_recv+0x1ae7/0x2750 net/tipc/netlink_compat.c:1265
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

It was triggered when the bearer name size < TIPC_MAX_BEARER_NAME,
it would check with a wrong len/TLV_GET_DATA_LEN(msg->req), which
also includes priority and disc_domain length.

This patch is to fix it by checking it with a right length:
'TLV_GET_DATA_LEN(msg->req) - offsetof(struct tipc_bearer_config, name)'.

Reported-by: syzbot+8b707430713eb46e1e45@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/netlink_compat.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -394,7 +394,12 @@ static int tipc_nl_compat_bearer_enable(
 	if (!bearer)
 		return -EMSGSIZE;
 
-	len = min_t(int, TLV_GET_DATA_LEN(msg->req), TIPC_MAX_BEARER_NAME);
+	len = TLV_GET_DATA_LEN(msg->req);
+	len -= offsetof(struct tipc_bearer_config, name);
+	if (len <= 0)
+		return -EINVAL;
+
+	len = min_t(int, len, TIPC_MAX_BEARER_NAME);
 	if (!string_is_valid(b->name, len))
 		return -EINVAL;
 


