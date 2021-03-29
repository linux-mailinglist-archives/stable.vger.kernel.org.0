Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04A634C66D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhC2IH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231871AbhC2IGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:06:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E19661969;
        Mon, 29 Mar 2021 08:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005183;
        bh=EDzOvmxmGlDWOmsb+2EolzaQYhq59iSo0ELWtOQdzuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yiPZ4nrYWt+ujwWn/gnhLKG7NVjF9CLFexlCB/4BtCzJ/S+P8nGKrl22sNCVVkcQB
         3MIecPJyHjIPQjd37AJITfhYQT71CKUpx2kFuG2/0NM0ScDGv0YMMgBLVeTA8bDlhn
         kTTS6yh5Iv1zd/MVduq8c3JUu70zQlCLydJ420Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.14 54/59] can: dev: Move device back to init netns on owning netns delete
Date:   Mon, 29 Mar 2021 09:58:34 +0200
Message-Id: <20210329075610.645745414@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Willi <martin@strongswan.org>

commit 3a5ca857079ea022e0b1b17fc154f7ad7dbc150f upstream.

When a non-initial netns is destroyed, the usual policy is to delete
all virtual network interfaces contained, but move physical interfaces
back to the initial netns. This keeps the physical interface visible
on the system.

CAN devices are somewhat special, as they define rtnl_link_ops even
if they are physical devices. If a CAN interface is moved into a
non-initial netns, destroying that netns lets the interface vanish
instead of moving it back to the initial netns. default_device_exit()
skips CAN interfaces due to having rtnl_link_ops set. Reproducer:

  ip netns add foo
  ip link set can0 netns foo
  ip netns delete foo

WARNING: CPU: 1 PID: 84 at net/core/dev.c:11030 ops_exit_list+0x38/0x60
CPU: 1 PID: 84 Comm: kworker/u4:2 Not tainted 5.10.19 #1
Workqueue: netns cleanup_net
[<c010e700>] (unwind_backtrace) from [<c010a1d8>] (show_stack+0x10/0x14)
[<c010a1d8>] (show_stack) from [<c086dc10>] (dump_stack+0x94/0xa8)
[<c086dc10>] (dump_stack) from [<c086b938>] (__warn+0xb8/0x114)
[<c086b938>] (__warn) from [<c086ba10>] (warn_slowpath_fmt+0x7c/0xac)
[<c086ba10>] (warn_slowpath_fmt) from [<c0629f20>] (ops_exit_list+0x38/0x60)
[<c0629f20>] (ops_exit_list) from [<c062a5c4>] (cleanup_net+0x230/0x380)
[<c062a5c4>] (cleanup_net) from [<c0142c20>] (process_one_work+0x1d8/0x438)
[<c0142c20>] (process_one_work) from [<c0142ee4>] (worker_thread+0x64/0x5a8)
[<c0142ee4>] (worker_thread) from [<c0148a98>] (kthread+0x148/0x14c)
[<c0148a98>] (kthread) from [<c0100148>] (ret_from_fork+0x14/0x2c)

To properly restore physical CAN devices to the initial netns on owning
netns exit, introduce a flag on rtnl_link_ops that can be set by drivers.
For CAN devices setting this flag, default_device_exit() considers them
non-virtual, applying the usual namespace move.

The issue was introduced in the commit mentioned below, as at that time
CAN devices did not have a dellink() operation.

Fixes: e008b5fc8dc7 ("net: Simplfy default_device_exit and improve batching.")
Link: https://lore.kernel.org/r/20210302122423.872326-1-martin@strongswan.org
Signed-off-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/dev.c   |    1 +
 include/net/rtnetlink.h |    2 ++
 net/core/dev.c          |    2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -1191,6 +1191,7 @@ static void can_dellink(struct net_devic
 
 static struct rtnl_link_ops can_link_ops __read_mostly = {
 	.kind		= "can",
+	.netns_refund	= true,
 	.maxtype	= IFLA_CAN_MAX,
 	.policy		= can_policy,
 	.setup		= can_setup,
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -33,6 +33,7 @@ static inline int rtnl_msg_family(const
  *
  *	@list: Used internally
  *	@kind: Identifier
+ *	@netns_refund: Physical device, move to init_net on netns exit
  *	@maxtype: Highest device specific netlink attribute number
  *	@policy: Netlink policy for device specific attribute validation
  *	@validate: Optional validation function for netlink/changelink parameters
@@ -92,6 +93,7 @@ struct rtnl_link_ops {
 	unsigned int		(*get_num_tx_queues)(void);
 	unsigned int		(*get_num_rx_queues)(void);
 
+	bool			netns_refund;
 	int			slave_maxtype;
 	const struct nla_policy	*slave_policy;
 	int			(*slave_validate)(struct nlattr *tb[],
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8667,7 +8667,7 @@ static void __net_exit default_device_ex
 			continue;
 
 		/* Leave virtual devices for the generic cleanup */
-		if (dev->rtnl_link_ops)
+		if (dev->rtnl_link_ops && !dev->rtnl_link_ops->netns_refund)
 			continue;
 
 		/* Push remaining network devices to init_net */


