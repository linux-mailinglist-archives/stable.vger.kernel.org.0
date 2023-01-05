Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED1865E447
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 04:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjAEDz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 22:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjAEDzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 22:55:04 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0802A46814
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 19:53:28 -0800 (PST)
Received: from dggpeml100012.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NnXWg1RGQzqTtf;
        Thu,  5 Jan 2023 11:48:47 +0800 (CST)
Received: from localhost.localdomain (10.67.175.61) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 5 Jan 2023 11:53:27 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <gregkh@linuxfoundation.org>
CC:     <mhiramat@kernel.org>, <rostedt@goodmis.org>,
        <stable@vger.kernel.org>, <zanussi@kernel.org>,
        <zhengyejian1@huawei.com>
Subject: [PATCH 5.15] tracing: Fix issue of missing one synthetic field
Date:   Thu, 5 Jan 2023 11:54:52 +0800
Message-ID: <20230105035452.3092172-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <16728414332518@kroah.com>
References: <16728414332518@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.61]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ff4837f7fe59ff018eca4705a70eca5e0b486b97 ]

The maximum number of synthetic fields supported is defined as
SYNTH_FIELDS_MAX which value currently is 64, but it actually fails
when try to generate a synthetic event with 64 fields by executing like:

  # echo "my_synth_event int v1; int v2; int v3; int v4; int v5; int v6;\
   int v7; int v8; int v9; int v10; int v11; int v12; int v13; int v14;\
   int v15; int v16; int v17; int v18; int v19; int v20; int v21; int v22;\
   int v23; int v24; int v25; int v26; int v27; int v28; int v29; int v30;\
   int v31; int v32; int v33; int v34; int v35; int v36; int v37; int v38;\
   int v39; int v40; int v41; int v42; int v43; int v44; int v45; int v46;\
   int v47; int v48; int v49; int v50; int v51; int v52; int v53; int v54;\
   int v55; int v56; int v57; int v58; int v59; int v60; int v61; int v62;\
   int v63; int v64" >> /sys/kernel/tracing/synthetic_events

Correct the field counting to fix it.

Link: https://lore.kernel.org/linux-trace-kernel/20221207091557.3137904-1-zhengyejian1@huawei.com

Cc: <mhiramat@kernel.org>
Cc: <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Fixes: c9e759b1e845 ("tracing: Rework synthetic event command parsing")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
[Fix conflict due to lack of c24be24aed405d64ebcf04526614c13b2adfb1d2]
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 kernel/trace/trace_events_synth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 47eb92b3edd0..2fdf3fd591e1 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -1275,12 +1275,12 @@ static int __create_synth_event(const char *name, const char *raw_fields)
 				goto err;
 			}
 
-			fields[n_fields++] = field;
 			if (n_fields == SYNTH_FIELDS_MAX) {
 				synth_err(SYNTH_ERR_TOO_MANY_FIELDS, 0);
 				ret = -EINVAL;
 				goto err;
 			}
+			fields[n_fields++] = field;
 
 			n_fields_this_loop++;
 		}
-- 
2.25.1

