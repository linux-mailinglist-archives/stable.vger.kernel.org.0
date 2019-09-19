Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CBAB857D
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394069AbfISWVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392901AbfISWTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:19:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 477A420678;
        Thu, 19 Sep 2019 22:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931575;
        bh=/IGYm6FqiPma+nq6xhXQJSSljNALe2I6/2gLD+evXA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSwAZAU2nQ3KZVcR8E/yB3pbn1zNPvtAX+3PWUQErcA1HaRRLR125+81uKRqL5mpK
         AGEp3VPM0k6x49YMioRxpJ7U3cgvo45pIG34XvLr+4kFklyuOH7a9r8fnUkbUzGLH8
         e+QjaP0vfEA77T9SzcPcZ3vxRWm+UTV9ULw7Cud8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 05/74] net: Fix null de-reference of device refcount
Date:   Fri, 20 Sep 2019 00:03:18 +0200
Message-Id: <20190919214801.749254612@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

[ Upstream commit 10cc514f451a0f239aa34f91bc9dc954a9397840 ]

In event of failure during register_netdevice, free_netdev is
invoked immediately. free_netdev assumes that all the netdevice
refcounts have been dropped prior to it being called and as a
result frees and clears out the refcount pointer.

However, this is not necessarily true as some of the operations
in the NETDEV_UNREGISTER notifier handlers queue RCU callbacks for
invocation after a grace period. The IPv4 callback in_dev_rcu_put
tries to access the refcount after free_netdev is called which
leads to a null de-reference-

44837.761523:   <6> Unable to handle kernel paging request at
                    virtual address 0000004a88287000
44837.761651:   <2> pc : in_dev_finish_destroy+0x4c/0xc8
44837.761654:   <2> lr : in_dev_finish_destroy+0x2c/0xc8
44837.762393:   <2> Call trace:
44837.762398:   <2>  in_dev_finish_destroy+0x4c/0xc8
44837.762404:   <2>  in_dev_rcu_put+0x24/0x30
44837.762412:   <2>  rcu_nocb_kthread+0x43c/0x468
44837.762418:   <2>  kthread+0x118/0x128
44837.762424:   <2>  ret_from_fork+0x10/0x1c

Fix this by waiting for the completion of the call_rcu() in
case of register_netdevice errors.

Fixes: 93ee31f14f6f ("[NET]: Fix free_netdev on register_netdev failure.")
Cc: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7353,6 +7353,8 @@ int register_netdevice(struct net_device
 	ret = notifier_to_errno(ret);
 	if (ret) {
 		rollback_registered(dev);
+		rcu_barrier();
+
 		dev->reg_state = NETREG_UNREGISTERED;
 	}
 	/*


