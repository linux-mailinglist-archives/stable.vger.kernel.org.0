Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C1219B305
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbgDAQss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389381AbgDAQpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:45:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8E142063A;
        Wed,  1 Apr 2020 16:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759528;
        bh=6Bi39iG/QukXkOH4TVbJbROjr1vFC9DWMnCyXdnQ514=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4LGYD6PjhSEZxK9f7W4xA3SWth2lSLXr2UpIHW8nqqhvt66Mv39YPmXv6GSC3Ktx
         +Cxnsf0Uht8ImggNamxl9eTzZe9X6pKG/5ReioK0ushBEgWLwyM/qlv8STAsFdVRpe
         IIo4LzTvuk7/mRfcr6pbdwjIaEdkKLhfWadeQKYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.14 107/148] xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire
Date:   Wed,  1 Apr 2020 18:18:19 +0200
Message-Id: <20200401161602.925165134@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
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
@@ -2214,6 +2214,9 @@ static int xfrm_add_acquire(struct sk_bu
 	err = verify_newpolicy_info(&ua->policy);
 	if (err)
 		goto free_state;
+	err = verify_sec_ctx_len(attrs);
+	if (err)
+		goto free_state;
 
 	/*   build an XP */
 	xp = xfrm_policy_construct(net, &ua->policy, attrs, &err);


