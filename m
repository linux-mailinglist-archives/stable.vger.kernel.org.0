Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D42529E95
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 11:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245386AbiEQJ6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 05:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245316AbiEQJ5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 05:57:55 -0400
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2D3E37AB0;
        Tue, 17 May 2022 02:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=zqxKM6eotU228yrHwT
        eanJ4JHp6muv7frj9QCzZ1g10=; b=CrdwYFeIsB3anMwUtaE7nAn+QSxi/XWise
        X59wLAiS1OzNgtTnIj7/OkDUjkVzakmkAfMRvyIZ2ybKz1J3+PSvaYMVqYCEJk80
        5MEHmRJPrNcCbJ3uXLUzx4dRPheWtKQItKCN3KEq6BmHN2AU+q1rxpJVKt9VmcTa
        wzLSzbmtU=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp9 (Coremail) with SMTP id DcCowAA3PCWEcYNiDfluDQ--.937S4;
        Tue, 17 May 2022 17:57:42 +0800 (CST)
From:   Yuanjun Gong <ruc_gongyuanjun@163.com>
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/1] tracing: fix possible null pointer dereference
Date:   Tue, 17 May 2022 17:57:23 +0800
Message-Id: <20220517095723.7426-1-ruc_gongyuanjun@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DcCowAA3PCWEcYNiDfluDQ--.937S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7AryDJrWfAr13Xr4rtFWxXrb_yoW8GrW7pr
        W5Cr15Kr48tanFvF13uFn7Cry8J3s7Jry5CF4Uu3WfJry5Gr1vqr4q9ry8u3W0yFWDJwnx
        Xw1UZryF9FZrta7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piQJ55UUUUU=
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: 5uxfsw5rqj53pdqm30i6rwjhhfrp/1tbiNxcE5VWBn73nLgAAs+
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gong Yuanjun <ruc_gongyuanjun@163.com>

In hist_trigger_elt_data_alloc(), elt_data is freed by
hist_elt_data_free() if kcalloc fails.

static int hist_trigger_elt_data_alloc(struct tracing_map_elt *elt)
{
...
elt_data->field_var_str = kcalloc(n_str, sizeof(char *), GFP_KERNEL);
        if (!elt_data->field_var_str) {
                hist_elt_data_free(elt_data);
                return -EINVAL;
        }
...}

In hist_elt_data_free() the elt_data->field_var_str field should be
checked before dereference.

Signed-off-by: Gong Yuanjun <ruc_gongyuanjun@163.com>
---
 kernel/trace/trace_events_hist.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 44db5ba9cabb..73177c9f94b2 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1576,11 +1576,11 @@ static void hist_elt_data_free(struct hist_elt_data *elt_data)
 {
 	unsigned int i;
 
-	for (i = 0; i < elt_data->n_field_var_str; i++)
-		kfree(elt_data->field_var_str[i]);
-
-	kfree(elt_data->field_var_str);
-
+	if (elt_data->field_var_str) {
+		for (i = 0; i < elt_data->n_field_var_str; i++)
+			kfree(elt_data->field_var_str[i]);
+		kfree(elt_data->field_var_str);
+	}
 	kfree(elt_data->comm);
 	kfree(elt_data);
 }
-- 
2.17.1

