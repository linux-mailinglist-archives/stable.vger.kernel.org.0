Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAAB521161
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 11:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239265AbiEJJwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 05:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239222AbiEJJwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 05:52:04 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ADE237BA6;
        Tue, 10 May 2022 02:48:07 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KyCrH2ZdKzhZ60;
        Tue, 10 May 2022 17:47:27 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 10 May 2022 17:48:04 +0800
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 10 May 2022 17:48:03 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arch@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <stable@vger.kernel.org>
CC:     <peterz@infradead.org>, <tglx@linutronix.de>, <namit@vmware.com>,
        <gor@linux.ibm.com>, <rdunlap@infradead.org>, <paulmck@kernel.org>,
        <mingo@kernel.org>, <jgross@suse.com>,
        <gregkh@linuxfoundation.org>, <mpe@ellerman.id.au>,
        <chenzhongjin@huawei.com>
Subject: [PATCH v4] locking/csd_lock: change csdlock_debug from early_param to __setup
Date:   Tue, 10 May 2022 17:46:39 +0800
Message-ID: <20220510094639.106661-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

csdlock_debug uses early_param and static_branch_enable() to enable
csd_lock_wait feature, which triggers a panic on arm64 with config:
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_VMEMMAP=n

With CONFIG_SPARSEMEM_VMEMMAP=n, __nr_to_section is called in
static_key_enable() and returns NULL which makes NULL dereference
because mem_section is initialized in sparse_init() which is later
than parse_early_param() stage.

For powerpc this is also broken, because early_param stage is
earlier than jump_label_init() so static_key_enable won't work.
powerpc throws an warning: "static key 'xxx' used before call
to jump_label_init()".

Thus, early_param is too early for csd_lock_wait to run
static_branch_enable(), so changes it to __setup to fix these.

Fixes: 8d0968cc6b8f ("locking/csd_lock: Add boot parameter for controlling CSD lock debugging")
Cc: stable@vger.kernel.org
Reported-by: Chen jingwen <chenjingwen6@huawei.com>
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
Change v3 -> v4:
Fix title and description because this fix is also applied
to powerpc.
For more detailed arm64 bug report see:
https://lore.kernel.org/linux-arm-kernel/e8715911-f835-059d-27f8-cc5f5ad30a07@huawei.com/t/

Change v2 -> v3:
Add module name in title

Change v1 -> v2:
Fix return 1 for __setup
---
 kernel/smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 65a630f62363..381eb15cd28f 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -174,9 +174,9 @@ static int __init csdlock_debug(char *str)
 	if (val)
 		static_branch_enable(&csdlock_debug_enabled);
 
-	return 0;
+	return 1;
 }
-early_param("csdlock_debug", csdlock_debug);
+__setup("csdlock_debug=", csdlock_debug);
 
 static DEFINE_PER_CPU(call_single_data_t *, cur_csd);
 static DEFINE_PER_CPU(smp_call_func_t, cur_csd_func);
-- 
2.17.1

