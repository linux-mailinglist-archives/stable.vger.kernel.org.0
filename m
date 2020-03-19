Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A783518B572
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgCSNSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729786AbgCSNSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:18:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD82A206D7;
        Thu, 19 Mar 2020 13:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623913;
        bh=XR2Q7N+ULL4qYeXZw4qAUzkKIZ11FxM9mC8lPTKkg7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ijcgv5z9n7Mo4+iP52aYrjmuCjRM2x0PMPQQ20pxyU45B/DjNVyqifYtBJuftEcuT
         c6VCVrMwOvezfPFY1C6yjtp1reqvEvAVfK6sruIIkXSAeePmDWVM6OZNN/pG4tLoH7
         NBQfERBXFeWGfXnuCmSRqerzGQ/9SyyBBjPqEdhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 94/99] net: rmnet: fix NULL pointer dereference in rmnet_newlink()
Date:   Thu, 19 Mar 2020 14:04:12 +0100
Message-Id: <20200319124007.436271029@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 93b5cbfa9636d385126f211dca9efa7e3f683202 ]

rmnet registers IFLA_LINK interface as a lower interface.
But, IFLA_LINK could be NULL.
In the current code, rmnet doesn't check IFLA_LINK.
So, panic would occur.

Test commands:
    modprobe rmnet
    ip link add rmnet0 type rmnet mux_id 1

Splat looks like:
[   36.826109][ T1115] general protection fault, probably for non-canonical address 0xdffffc0000000000I
[   36.838817][ T1115] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   36.839908][ T1115] CPU: 1 PID: 1115 Comm: ip Not tainted 5.6.0-rc1+ #447
[   36.840569][ T1115] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   36.841408][ T1115] RIP: 0010:rmnet_newlink+0x54/0x510 [rmnet]
[   36.841986][ T1115] Code: 83 ec 18 48 c1 e9 03 80 3c 01 00 0f 85 d4 03 00 00 48 8b 6a 28 48 b8 00 00 00 00 00 c
[   36.843923][ T1115] RSP: 0018:ffff8880b7e0f1c0 EFLAGS: 00010247
[   36.844756][ T1115] RAX: dffffc0000000000 RBX: ffff8880d14cca00 RCX: 1ffff11016fc1e99
[   36.845859][ T1115] RDX: 0000000000000000 RSI: ffff8880c3d04000 RDI: 0000000000000004
[   36.846961][ T1115] RBP: 0000000000000000 R08: ffff8880b7e0f8b0 R09: ffff8880b6ac2d90
[   36.848020][ T1115] R10: ffffffffc0589a40 R11: ffffed1016d585b7 R12: ffffffff88ceaf80
[   36.848788][ T1115] R13: ffff8880c3d04000 R14: ffff8880b7e0f8b0 R15: ffff8880c3d04000
[   36.849546][ T1115] FS:  00007f50ab3360c0(0000) GS:ffff8880da000000(0000) knlGS:0000000000000000
[   36.851784][ T1115] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.852422][ T1115] CR2: 000055871afe5ab0 CR3: 00000000ae246001 CR4: 00000000000606e0
[   36.853181][ T1115] Call Trace:
[   36.853514][ T1115]  __rtnl_newlink+0xbdb/0x1270
[   36.853967][ T1115]  ? lock_downgrade+0x6e0/0x6e0
[   36.854420][ T1115]  ? rtnl_link_unregister+0x220/0x220
[   36.854936][ T1115]  ? lock_acquire+0x164/0x3b0
[   36.855376][ T1115]  ? is_bpf_image_address+0xff/0x1d0
[   36.855884][ T1115]  ? rtnl_newlink+0x4c/0x90
[   36.856304][ T1115]  ? kernel_text_address+0x111/0x140
[   36.856857][ T1115]  ? __kernel_text_address+0xe/0x30
[   36.857440][ T1115]  ? unwind_get_return_address+0x5f/0xa0
[   36.858063][ T1115]  ? create_prof_cpu_mask+0x20/0x20
[   36.858644][ T1115]  ? arch_stack_walk+0x83/0xb0
[   36.859171][ T1115]  ? stack_trace_save+0x82/0xb0
[   36.859710][ T1115]  ? stack_trace_consume_entry+0x160/0x160
[   36.860357][ T1115]  ? deactivate_slab.isra.78+0x2c5/0x800
[   36.860928][ T1115]  ? kasan_unpoison_shadow+0x30/0x40
[   36.861520][ T1115]  ? kmem_cache_alloc_trace+0x135/0x350
[   36.862125][ T1115]  ? rtnl_newlink+0x4c/0x90
[   36.864073][ T1115]  rtnl_newlink+0x65/0x90
[ ... ]

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 7d8303e45f090..b7df8c1121e35 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -157,6 +157,11 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 	int err = 0;
 	u16 mux_id;
 
+	if (!tb[IFLA_LINK]) {
+		NL_SET_ERR_MSG_MOD(extack, "link not specified");
+		return -EINVAL;
+	}
+
 	real_dev = __dev_get_by_index(src_net, nla_get_u32(tb[IFLA_LINK]));
 	if (!real_dev || !dev)
 		return -ENODEV;
-- 
2.20.1



