Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A952E56D2C2
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 03:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiGKBuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 21:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiGKBuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 21:50:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933CB18371;
        Sun, 10 Jul 2022 18:50:00 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lh6GD5bkyzkWbV;
        Mon, 11 Jul 2022 09:47:48 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Jul 2022 09:49:57 +0800
Received: from ubuntu1804.huawei.com (10.67.174.66) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Jul 2022 09:49:57 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <rostedt@goodmis.org>
CC:     <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <stable@vger.kernel.org>, <tom.zanussi@linux.intel.com>,
        <trix@redhat.com>, <zhangjinhao2@huawei.com>,
        <zhengyejian1@huawei.com>
Subject: [PATCH v2] tracing/histograms: Fix memory leak problem
Date:   Mon, 11 Jul 2022 09:47:31 +0800
Message-ID: <20220711014731.69520-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220708210335.79a38356@gandalf.local.home>
References: <20220708210335.79a38356@gandalf.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.66]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 46bbe5c671e06f070428b9be142cc4ee5cedebac.

As commit 46bbe5c671e0 ("tracing: fix double free") said, the
"double free" problem reported by clang static analyzer is:
  > In parse_var_defs() if there is a problem allocating
  > var_defs.expr, the earlier var_defs.name is freed.
  > This free is duplicated by free_var_defs() which frees
  > the rest of the list.

However, if there is a problem allocating N-th var_defs.expr:
  + in parse_var_defs(), the freed 'earlier var_defs.name' is
    actually the N-th var_defs.name;
  + then in free_var_defs(), the names from 0th to (N-1)-th are freed;

                        IF ALLOCATING PROBLEM HAPPENED HERE!!! -+
                                                                 \
                                                                  |
          0th           1th                 (N-1)-th      N-th    V
          +-------------+-------------+-----+-------------+-----------
var_defs: | name | expr | name | expr | ... | name | expr | name | ///
          +-------------+-------------+-----+-------------+-----------

These two frees don't act on same name, so there was no "double free"
problem before. Conversely, after that commit, we get a "memory leak"
problem because the above "N-th var_defs.name" is not freed.

If enable CONFIG_DEBUG_KMEMLEAK and inject a fault at where the N-th
var_defs.expr allocated, then execute on shell like:
  $ echo 'hist:key=call_site:val=$v1,$v2:v1=bytes_req,v2=bytes_alloc' > \
/sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

Then kmemleak reports:
  unreferenced object 0xffff8fb100ef3518 (size 8):
    comm "bash", pid 196, jiffies 4295681690 (age 28.538s)
    hex dump (first 8 bytes):
      76 31 00 00 b1 8f ff ff                          v1......
    backtrace:
      [<0000000038fe4895>] kstrdup+0x2d/0x60
      [<00000000c99c049a>] event_hist_trigger_parse+0x206f/0x20e0
      [<00000000ae70d2cc>] trigger_process_regex+0xc0/0x110
      [<0000000066737a4c>] event_trigger_write+0x75/0xd0
      [<000000007341e40c>] vfs_write+0xbb/0x2a0
      [<0000000087fde4c2>] ksys_write+0x59/0xd0
      [<00000000581e9cdf>] do_syscall_64+0x3a/0x80
      [<00000000cf3b065c>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Cc: stable@vger.kernel.org
Fixes: 46bbe5c671e0 ("tracing: fix double free")
Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 kernel/trace/trace_events_hist.c | 2 ++
 1 file changed, 2 insertions(+)

Changes since v1:
- Assign 'NULL' after 'kfree' for safety as suggested by Steven
- Rename commit title and add Suggested-by tag

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 48e82e141d54..e87a46794079 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4430,6 +4430,8 @@ static int parse_var_defs(struct hist_trigger_data *hist_data)
 
 			s = kstrdup(field_str, GFP_KERNEL);
 			if (!s) {
+				kfree(hist_data->attrs->var_defs.name[n_vars]);
+				hist_data->attrs->var_defs.name[n_vars] = NULL;
 				ret = -ENOMEM;
 				goto free;
 			}
-- 
2.32.0

