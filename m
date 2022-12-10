Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CBA648EFF
	for <lists+stable@lfdr.de>; Sat, 10 Dec 2022 14:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiLJN6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Dec 2022 08:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiLJN62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Dec 2022 08:58:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6C6183A8;
        Sat, 10 Dec 2022 05:58:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D874B60C2E;
        Sat, 10 Dec 2022 13:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A73C43392;
        Sat, 10 Dec 2022 13:58:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1p40Mz-000ksM-2i;
        Sat, 10 Dec 2022 08:58:25 -0500
Message-ID: <20221210135825.707936469@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 10 Dec 2022 08:58:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <zanussi@kernel.org>, stable@vger.kernel.org,
        Zheng Yejian <zhengyejian1@huawei.com>
Subject: [for-next][PATCH 16/25] tracing: Fix issue of missing one synthetic field
References: <20221210135750.425719934@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yejian <zhengyejian1@huawei.com>

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
---
 kernel/trace/trace_events_synth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index c3b582d19b62..67592eed0be8 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -1282,12 +1282,12 @@ static int __create_synth_event(const char *name, const char *raw_fields)
 				goto err_free_arg;
 			}
 
-			fields[n_fields++] = field;
 			if (n_fields == SYNTH_FIELDS_MAX) {
 				synth_err(SYNTH_ERR_TOO_MANY_FIELDS, 0);
 				ret = -EINVAL;
 				goto err_free_arg;
 			}
+			fields[n_fields++] = field;
 
 			n_fields_this_loop++;
 		}
-- 
2.35.1


