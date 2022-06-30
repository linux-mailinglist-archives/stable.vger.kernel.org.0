Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135EF560EB5
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 03:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiF3BeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 21:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiF3BeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 21:34:09 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7331C128;
        Wed, 29 Jun 2022 18:34:08 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LYLSj06Xcz9sv3;
        Thu, 30 Jun 2022 09:33:25 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 09:34:06 +0800
Received: from ubuntu1804.huawei.com (10.67.174.66) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 09:34:06 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <rostedt@goodmis.org>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <tom.zanussi@linux.intel.com>,
        <trix@redhat.com>
CC:     <stable@vger.kernel.org>, <zhangjinhao2@huawei.com>,
        <zhengyejian1@huawei.com>
Subject: [PATCH] tracing/histograms: Simplify create_hist_fields()
Date:   Thu, 30 Jun 2022 09:31:52 +0800
Message-ID: <20220630013152.164871-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.66]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

When I look into implements of create_hist_fields(), I think there can be
following two simplifications:
  1. If something wrong happened in parse_var_defs(), free_var_defs() would
     have been called in it, so no need goto free again after calling it;
  2. After calling create_key_fields(), regardless of the value of 'ret', it
     then always runs into 'out: ', so the judge of 'ret' is redundant.

No functional changes.

Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 kernel/trace/trace_events_hist.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 2784951e0fc8..832c4ccf41ab 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4454,7 +4454,7 @@ static int create_hist_fields(struct hist_trigger_data *hist_data,
 
 	ret = parse_var_defs(hist_data);
 	if (ret)
-		goto out;
+		return ret;
 
 	ret = create_val_fields(hist_data, file);
 	if (ret)
@@ -4465,8 +4465,7 @@ static int create_hist_fields(struct hist_trigger_data *hist_data,
 		goto out;
 
 	ret = create_key_fields(hist_data, file);
-	if (ret)
-		goto out;
+
  out:
 	free_var_defs(hist_data);
 
-- 
2.32.0

