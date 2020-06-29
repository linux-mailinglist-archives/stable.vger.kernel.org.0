Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E269520D785
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732693AbgF2Tah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732687AbgF2Tad (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48D13252E6;
        Mon, 29 Jun 2020 15:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445116;
        bh=VS1CPfZGGl3IXFs3WZontZttp1TBg5R/bIFBI+ppRM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcYFLq2mFBehsid0JInu6MTBf6IJiaRHNOi2XtfS1rdIKBzemdGE3drAdXmRQJ/Sd
         mIMatbU/65TbiDC4BCneLbiZ1zgjdTVj8lhUnTrzFdskTwlzZnr+ymw9/0ssW1sSBJ
         Obn7pKr7jVKC344PP1Ms2Z5lOjad1qvWUd4hnljA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 22/78] net: core: reduce recursion limit value
Date:   Mon, 29 Jun 2020 11:37:10 -0400
Message-Id: <20200629153806.2494953-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit fb7861d14c8d7edac65b2fcb6e8031cb138457b2 ]

In the current code, ->ndo_start_xmit() can be executed recursively only
10 times because of stack memory.
But, in the case of the vxlan, 10 recursion limit value results in
a stack overflow.
In the current code, the nested interface is limited by 8 depth.
There is no critical reason that the recursion limitation value should
be 10.
So, it would be good to be the same value with the limitation value of
nesting interface depth.

Test commands:
    ip link add vxlan10 type vxlan vni 10 dstport 4789 srcport 4789 4789
    ip link set vxlan10 up
    ip a a 192.168.10.1/24 dev vxlan10
    ip n a 192.168.10.2 dev vxlan10 lladdr fc:22:33:44:55:66 nud permanent

    for i in {9..0}
    do
        let A=$i+1
	ip link add vxlan$i type vxlan vni $i dstport 4789 srcport 4789 4789
	ip link set vxlan$i up
	ip a a 192.168.$i.1/24 dev vxlan$i
	ip n a 192.168.$i.2 dev vxlan$i lladdr fc:22:33:44:55:66 nud permanent
	bridge fdb add fc:22:33:44:55:66 dev vxlan$A dst 192.168.$i.2 self
    done
    hping3 192.168.10.2 -2 -d 60000

Splat looks like:
[  103.814237][ T1127] =============================================================================
[  103.871955][ T1127] BUG kmalloc-2k (Tainted: G    B            ): Padding overwritten. 0x00000000897a2e4f-0x000
[  103.873187][ T1127] -----------------------------------------------------------------------------
[  103.873187][ T1127]
[  103.874252][ T1127] INFO: Slab 0x000000005cccc724 objects=5 used=5 fp=0x0000000000000000 flags=0x10000000001020
[  103.881323][ T1127] CPU: 3 PID: 1127 Comm: hping3 Tainted: G    B             5.7.0+ #575
[  103.882131][ T1127] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  103.883006][ T1127] Call Trace:
[  103.883324][ T1127]  dump_stack+0x96/0xdb
[  103.883716][ T1127]  slab_err+0xad/0xd0
[  103.884106][ T1127]  ? _raw_spin_unlock+0x1f/0x30
[  103.884620][ T1127]  ? get_partial_node.isra.78+0x140/0x360
[  103.885214][ T1127]  slab_pad_check.part.53+0xf7/0x160
[  103.885769][ T1127]  ? pskb_expand_head+0x110/0xe10
[  103.886316][ T1127]  check_slab+0x97/0xb0
[  103.886763][ T1127]  alloc_debug_processing+0x84/0x1a0
[  103.887308][ T1127]  ___slab_alloc+0x5a5/0x630
[  103.887765][ T1127]  ? pskb_expand_head+0x110/0xe10
[  103.888265][ T1127]  ? lock_downgrade+0x730/0x730
[  103.888762][ T1127]  ? pskb_expand_head+0x110/0xe10
[  103.889244][ T1127]  ? __slab_alloc+0x3e/0x80
[  103.889675][ T1127]  __slab_alloc+0x3e/0x80
[  103.890108][ T1127]  __kmalloc_node_track_caller+0xc7/0x420
[ ... ]

Fixes: 11a766ce915f ("net: Increase xmit RECURSION_LIMIT to 10.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 31fc54757bf2e..3512c337a4a6b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2449,7 +2449,7 @@ void synchronize_net(void);
 int init_dummy_netdev(struct net_device *dev);
 
 DECLARE_PER_CPU(int, xmit_recursion);
-#define XMIT_RECURSION_LIMIT	10
+#define XMIT_RECURSION_LIMIT	8
 
 static inline int dev_recursion_level(void)
 {
-- 
2.25.1

