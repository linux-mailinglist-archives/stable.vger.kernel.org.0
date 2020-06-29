Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8347820E5A7
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgF2VkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbgF2Sk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C584D23F2C;
        Mon, 29 Jun 2020 15:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443911;
        bh=oCmObFEYG7Deu6S00l6SkKdwFEsNk3xQCyFhoooll9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6/68KVJZfRQhzv81ixxzfgby1rOlA5GEyPnbCKIGkxos5eyqAqAIEjgATn7lnaOj
         eFQ6tnqF5aghaf+0wxC8FpGa44A4es+nkXvlnlbawYMRnOvLGXtA0Mquvw/te29hur
         yW1Y5vDdaKdrjzzz2mVFUVTEB3tc8zesAp6afg30=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 011/265] net: core: reduce recursion limit value
Date:   Mon, 29 Jun 2020 11:14:04 -0400
Message-Id: <20200629151818.2493727-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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
index 130a668049ab0..36c7ad24d54d9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3125,7 +3125,7 @@ static inline int dev_recursion_level(void)
 	return this_cpu_read(softnet_data.xmit.recursion);
 }
 
-#define XMIT_RECURSION_LIMIT	10
+#define XMIT_RECURSION_LIMIT	8
 static inline bool dev_xmit_recursion(void)
 {
 	return unlikely(__this_cpu_read(softnet_data.xmit.recursion) >
-- 
2.25.1

