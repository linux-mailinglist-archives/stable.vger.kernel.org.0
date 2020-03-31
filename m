Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C96901991DE
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731281AbgCaJHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731279AbgCaJHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:07:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E5BF212CC;
        Tue, 31 Mar 2020 09:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645672;
        bh=G/zQPYs7GWV+jXp+rWe/LIgnh+0jqvatsNAm9hy88Rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2Ldl4h8FxmKpeaqCUhkD5ZrR3cIp4mqIGPX1dR+IP+3znxT4QZId9c7ndXBeIFDw
         N+sI9JYSpe2Oou5URhZCrE8rF5dvbkFXQaf7UOX60MO8r1Z0avmI5H9+Sz3UkIxU4z
         SNvDJZa2ZjEzjj1fY9QCsL6FbOqy9/Nzj6v0TqhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.5 128/170] xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire
Date:   Tue, 31 Mar 2020 10:59:02 +0200
Message-Id: <20200331085437.389607964@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit a1a7e3a36e01ca6e67014f8cf673cb8e47be5550 upstream.

Without doing verify_sec_ctx_len() check in xfrm_add_acquire(), it may be
out-of-bounds to access uctx->ctx_str with uctx->ctx_len, as noticed by
syz:

  BUG: KASAN: slab-out-of-bounds in selinux_xfrm_alloc_user+0x237/0x430
  Read of size 768 at addr ffff8880123be9b4 by task syz-executor.1/11650

  Call Trace:
   dump_stack+0xe8/0x16e
   print_address_description.cold.3+0x9/0x23b
   kasan_report.cold.4+0x64/0x95
   memcpy+0x1f/0x50
   selinux_xfrm_alloc_user+0x237/0x430
   security_xfrm_policy_alloc+0x5c/0xb0
   xfrm_policy_construct+0x2b1/0x650
   xfrm_add_acquire+0x21d/0xa10
   xfrm_user_rcv_msg+0x431/0x6f0
   netlink_rcv_skb+0x15a/0x410
   xfrm_netlink_rcv+0x6d/0x90
   netlink_unicast+0x50e/0x6a0
   netlink_sendmsg+0x8ae/0xd40
   sock_sendmsg+0x133/0x170
   ___sys_sendmsg+0x834/0x9a0
   __sys_sendmsg+0x100/0x1e0
   do_syscall_64+0xe5/0x660
   entry_SYSCALL_64_after_hwframe+0x6a/0xdf

So fix it by adding the missing verify_sec_ctx_len check there.

Fixes: 980ebd25794f ("[IPSEC]: Sync series - acquire insert")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_user.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2276,6 +2276,9 @@ static int xfrm_add_acquire(struct sk_bu
 	err = verify_newpolicy_info(&ua->policy);
 	if (err)
 		goto free_state;
+	err = verify_sec_ctx_len(attrs);
+	if (err)
+		goto free_state;
 
 	/*   build an XP */
 	xp = xfrm_policy_construct(net, &ua->policy, attrs, &err);


