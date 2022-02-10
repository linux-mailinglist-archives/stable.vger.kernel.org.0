Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4655C4B0B66
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 11:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbiBJKun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 05:50:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240214AbiBJKum (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 05:50:42 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12663101;
        Thu, 10 Feb 2022 02:50:39 -0800 (PST)
X-UUID: f22d432b66fd4044b7d9032c26b2248f-20220210
X-UUID: f22d432b66fd4044b7d9032c26b2248f-20220210
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <cheng-jui.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1612641741; Thu, 10 Feb 2022 18:50:35 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 10 Feb 2022 18:50:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Feb 2022 18:50:33 +0800
From:   Cheng Jui Wang <cheng-jui.wang@mediatek.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
CC:     Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>,
        "Boqun Feng" <boqun.feng@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <stable@vger.kernel.org>,
        <wsd_upstream@mediatek.com>,
        Eason-YH Lin <eason-yh.lin@mediatek.com>,
        Kobe-CP Wu <kobe-cp.wu@mediatek.com>,
        Jeff-CC Hsu <jeff-cc.hsu@mediatek.com>,
        Cheng Jui Wang <cheng-jui.wang@mediatek.com>
Subject: [PATCH] lockdep: Correct lock_classes index mapping
Date:   Thu, 10 Feb 2022 18:50:11 +0800
Message-ID: <20220210105011.21712-1-cheng-jui.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A kernel exception was hit when trying to dump /proc/lockdep_chains after
lockdep report "BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!":

Unable to handle kernel paging request at virtual address 00054005450e05c3
...
00054005450e05c3] address between user and kernel address ranges
...
pc : [0xffffffece769b3a8] string+0x50/0x10c
lr : [0xffffffece769ac88] vsnprintf+0x468/0x69c
...
 Call trace:
  string+0x50/0x10c
  vsnprintf+0x468/0x69c
  seq_printf+0x8c/0xd8
  print_name+0x64/0xf4
  lc_show+0xb8/0x128
  seq_read_iter+0x3cc/0x5fc
  proc_reg_read_iter+0xdc/0x1d4

The cause of the problem is the function lock_chain_get_class() will
shift lock_classes index by 1, but the index don't need to be shifted
anymore since commit 01bb6f0af992 ("locking/lockdep: Change the range of
class_idx in held_lock struct") already change the index to start from
0.

The lock_classes[-1] located at chain_hlocks array. When printing
lock_classes[-1] after the chain_hlocks entries are modified, the
exception happened.

The output of lockdep_chains are incorrect due to this problem too.

Fixes: f611e8cf98ec ("lockdep: Take read/write status in consideration when generate chainkey")

Signed-off-by: Cheng Jui Wang <cheng-jui.wang@mediatek.com>
---
 kernel/locking/lockdep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 4a882f83aeb9..f8a0212189ca 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3462,7 +3462,7 @@ struct lock_class *lock_chain_get_class(struct lock_chain *chain, int i)
 	u16 chain_hlock = chain_hlocks[chain->base + i];
 	unsigned int class_idx = chain_hlock_class_idx(chain_hlock);
 
-	return lock_classes + class_idx - 1;
+	return lock_classes + class_idx;
 }
 
 /*
@@ -3530,7 +3530,7 @@ static void print_chain_keys_chain(struct lock_chain *chain)
 		hlock_id = chain_hlocks[chain->base + i];
 		chain_key = print_chain_key_iteration(hlock_id, chain_key);
 
-		print_lock_name(lock_classes + chain_hlock_class_idx(hlock_id) - 1);
+		print_lock_name(lock_classes + chain_hlock_class_idx(hlock_id));
 		printk("\n");
 	}
 }
-- 
2.18.0

