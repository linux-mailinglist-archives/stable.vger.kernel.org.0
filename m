Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8561EAC65
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731195AbgFASTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731770AbgFASQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:16:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23B3A2068D;
        Mon,  1 Jun 2020 18:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035417;
        bh=7kQum3scC1PlzQZWDOU3X+hetN2EwlUEfzOG7dH9P+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faGDmH71eLcRG6c0EphuvySCW1Yx4i/uWf0i+/KfxYVTcb1AQvSHJYxiPkcMyo65L
         8ZX6LXuyYrk9gnF6uSuna/j+1Q6EWczfT3VDhBvReA0oiXTMXFNIPacuqIgXtBggpb
         wbi7fyjqX5mB/R1fSnrttGEP675L+HwE/fMlYZYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.6 150/177] xfrm: fix a warning in xfrm_policy_insert_list
Date:   Mon,  1 Jun 2020 19:54:48 +0200
Message-Id: <20200601174100.914487345@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit ed17b8d377eaf6b4a01d46942b4c647378a79bdd upstream.

This waring can be triggered simply by:

  # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
    priority 1 mark 0 mask 0x10  #[1]
  # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
    priority 2 mark 0 mask 0x1   #[2]
  # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
    priority 2 mark 0 mask 0x10  #[3]

Then dmesg shows:

  [ ] WARNING: CPU: 1 PID: 7265 at net/xfrm/xfrm_policy.c:1548
  [ ] RIP: 0010:xfrm_policy_insert_list+0x2f2/0x1030
  [ ] Call Trace:
  [ ]  xfrm_policy_inexact_insert+0x85/0xe50
  [ ]  xfrm_policy_insert+0x4ba/0x680
  [ ]  xfrm_add_policy+0x246/0x4d0
  [ ]  xfrm_user_rcv_msg+0x331/0x5c0
  [ ]  netlink_rcv_skb+0x121/0x350
  [ ]  xfrm_netlink_rcv+0x66/0x80
  [ ]  netlink_unicast+0x439/0x630
  [ ]  netlink_sendmsg+0x714/0xbf0
  [ ]  sock_sendmsg+0xe2/0x110

The issue was introduced by Commit 7cb8a93968e3 ("xfrm: Allow inserting
policies with matching mark and different priorities"). After that, the
policies [1] and [2] would be able to be added with different priorities.

However, policy [3] will actually match both [1] and [2]. Policy [1]
was matched due to the 1st 'return true' in xfrm_policy_mark_match(),
and policy [2] was matched due to the 2nd 'return true' in there. It
caused WARN_ON() in xfrm_policy_insert_list().

This patch is to fix it by only (the same value and priority) as the
same policy in xfrm_policy_mark_match().

Thanks to Yuehaibing, we could make this fix better.

v1->v2:
  - check policy->mark.v == pol->mark.v only without mask.

Fixes: 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and different priorities")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_policy.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1436,12 +1436,7 @@ static void xfrm_policy_requeue(struct x
 static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
 				   struct xfrm_policy *pol)
 {
-	u32 mark = policy->mark.v & policy->mark.m;
-
-	if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
-		return true;
-
-	if ((mark & pol->mark.m) == pol->mark.v &&
+	if (policy->mark.v == pol->mark.v &&
 	    policy->priority == pol->priority)
 		return true;
 


