Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E21865D52E
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbjADOMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239636AbjADOLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:11:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E795327C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:10:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 620A3CE17DE
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C9AC433D2;
        Wed,  4 Jan 2023 14:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841444;
        bh=+sk+IJ45a33NruMfCJPUAIsv7gn0zafmQZvjwmS0a7c=;
        h=Subject:To:Cc:From:Date:From;
        b=JtulUnjXahd+yEKqC2MKG6TGpHRo4gKZ85cZqOYnWOVsfCdIWs0rpHctuTvIcllh4
         iwjWfG4tR4w+QfecGdohxKrc83Zz++tJFG4nOTRt4PCnx/ndYZypqxg7MFvQFtJFAP
         VoP7G6rQeeJj3aEPKXdlUe9ezXOxKbZbAHrp8h7o=
Subject: FAILED: patch "[PATCH] tracing: Fix issue of missing one synthetic field" failed to apply to 5.15-stable tree
To:     zhengyejian1@huawei.com, mhiramat@kernel.org, rostedt@goodmis.org,
        zanussi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:10:33 +0100
Message-ID: <16728414332518@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ff4837f7fe59 ("tracing: Fix issue of missing one synthetic field")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ff4837f7fe59ff018eca4705a70eca5e0b486b97 Mon Sep 17 00:00:00 2001
From: Zheng Yejian <zhengyejian1@huawei.com>
Date: Wed, 7 Dec 2022 17:15:57 +0800
Subject: [PATCH] tracing: Fix issue of missing one synthetic field

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

