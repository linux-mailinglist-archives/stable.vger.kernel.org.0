Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3526E623E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjDRMbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjDRMa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECB710260
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:30:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F48B631BF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FB8C433D2;
        Tue, 18 Apr 2023 12:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821043;
        bh=gJwGfhhbzrXH2LleKwZLtadwe6YlssC2QtloV+oJPfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHEfoFg0PTcswVAGfKYurogkmCGoXn4PkHL+0pIARwr/Es0x5/Dac0v2bFHI0pPqm
         WfnPkn+XZzoxVdeIxhHpWwBS5xEEo5z8qNrbtpoOPcme4jwZS5yglKU+IyDyz8NdCA
         5eFkyn5Tibq3KWp05mlC88ow8WNc5OYDSJDaLRb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yongchen Yin <wb-yyc939293@alibaba-inc.com>,
        Rongwei Wang <rongwei.wang@linux.alibaba.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 40/92] mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()
Date:   Tue, 18 Apr 2023 14:21:15 +0200
Message-Id: <20230418120306.239168205@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rongwei Wang <rongwei.wang@linux.alibaba.com>

commit 6fe7d6b992113719e96744d974212df3fcddc76c upstream.

The si->lock must be held when deleting the si from the available list.
Otherwise, another thread can re-add the si to the available list, which
can lead to memory corruption.  The only place we have found where this
happens is in the swapoff path.  This case can be described as below:

core 0                       core 1
swapoff

del_from_avail_list(si)      waiting

try lock si->lock            acquire swap_avail_lock
                             and re-add si into
                             swap_avail_head

acquire si->lock but missing si already being added again, and continuing
to clear SWP_WRITEOK, etc.

It can be easily found that a massive warning messages can be triggered
inside get_swap_pages() by some special cases, for example, we call
madvise(MADV_PAGEOUT) on blocks of touched memory concurrently, meanwhile,
run much swapon-swapoff operations (e.g.  stress-ng-swap).

However, in the worst case, panic can be caused by the above scene.  In
swapoff(), the memory used by si could be kept in swap_info[] after
turning off a swap.  This means memory corruption will not be caused
immediately until allocated and reset for a new swap in the swapon path.
A panic message caused: (with CONFIG_PLIST_DEBUG enabled)

------------[ cut here ]------------
top: 00000000e58a3003, n: 0000000013e75cda, p: 000000008cd4451a
prev: 0000000035b1e58a, n: 000000008cd4451a, p: 000000002150ee8d
next: 000000008cd4451a, n: 000000008cd4451a, p: 000000008cd4451a
WARNING: CPU: 21 PID: 1843 at lib/plist.c:60 plist_check_prev_next_node+0x50/0x70
Modules linked in: rfkill(E) crct10dif_ce(E)...
CPU: 21 PID: 1843 Comm: stress-ng Kdump: ... 5.10.134+
Hardware name: Alibaba Cloud ECS, BIOS 0.0.0 02/06/2015
pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
pc : plist_check_prev_next_node+0x50/0x70
lr : plist_check_prev_next_node+0x50/0x70
sp : ffff0018009d3c30
x29: ffff0018009d3c40 x28: ffff800011b32a98
x27: 0000000000000000 x26: ffff001803908000
x25: ffff8000128ea088 x24: ffff800011b32a48
x23: 0000000000000028 x22: ffff001800875c00
x21: ffff800010f9e520 x20: ffff001800875c00
x19: ffff001800fdc6e0 x18: 0000000000000030
x17: 0000000000000000 x16: 0000000000000000
x15: 0736076307640766 x14: 0730073007380731
x13: 0736076307640766 x12: 0730073007380731
x11: 000000000004058d x10: 0000000085a85b76
x9 : ffff8000101436e4 x8 : ffff800011c8ce08
x7 : 0000000000000000 x6 : 0000000000000001
x5 : ffff0017df9ed338 x4 : 0000000000000001
x3 : ffff8017ce62a000 x2 : ffff0017df9ed340
x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 plist_check_prev_next_node+0x50/0x70
 plist_check_head+0x80/0xf0
 plist_add+0x28/0x140
 add_to_avail_list+0x9c/0xf0
 _enable_swap_info+0x78/0xb4
 __do_sys_swapon+0x918/0xa10
 __arm64_sys_swapon+0x20/0x30
 el0_svc_common+0x8c/0x220
 do_el0_svc+0x2c/0x90
 el0_svc+0x1c/0x30
 el0_sync_handler+0xa8/0xb0
 el0_sync+0x148/0x180
irq event stamp: 2082270

Now, si->lock locked before calling 'del_from_avail_list()' to make sure
other thread see the si had been deleted and SWP_WRITEOK cleared together,
will not reinsert again.

This problem exists in versions after stable 5.10.y.

Link: https://lkml.kernel.org/r/20230404154716.23058-1-rongwei.wang@linux.alibaba.com
Fixes: a2468cc9bfdff ("swap: choose swap device according to numa node")
Tested-by: Yongchen Yin <wb-yyc939293@alibaba-inc.com>
Signed-off-by: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -672,6 +672,7 @@ static void __del_from_avail_list(struct
 {
 	int nid;
 
+	assert_spin_locked(&p->lock);
 	for_each_node(nid)
 		plist_del(&p->avail_lists[nid], &swap_avail_heads[nid]);
 }
@@ -2579,8 +2580,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 		spin_unlock(&swap_lock);
 		goto out_dput;
 	}
-	del_from_avail_list(p);
 	spin_lock(&p->lock);
+	del_from_avail_list(p);
 	if (p->prio < 0) {
 		struct swap_info_struct *si = p;
 		int nid;


