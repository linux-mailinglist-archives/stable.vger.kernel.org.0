Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C256BE0A3
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 06:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjCQFbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 01:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCQFbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 01:31:22 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE53B5A99;
        Thu, 16 Mar 2023 22:31:19 -0700 (PDT)
X-UUID: efadbe02c48411ed91027fb02e0f1d65-20230317
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=B0oWSAqYH3d4rxQTXEiSY0Y15GtFNYgYD2YcLGwJd3A=;
        b=GuP51zBdOowuCYrz23UP0QbVtjheq+3uxCfc+GvMA7tA+fwHwfFNmsmFLxJe9uSmeSoVDl9uVhfodJmIG4GO1SoH7cnG/uE3exX19rwr/JbdYmGpvO+dxYCo5TU50JX+qu1+TK6UpKutcw68u/t9PzKpUbjn6mtP/U/MD+XGwg8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.21,REQID:5c0186f2-fe5c-4f3a-b22c-fd3d2e832211,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:83295aa,CLOUDID:c98b87b3-beed-4dfc-bd9c-e1b22fa6ccc4,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: efadbe02c48411ed91027fb02e0f1d65-20230317
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <cheng-jui.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 784308367; Fri, 17 Mar 2023 13:31:15 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 17 Mar 2023 13:31:14 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 17 Mar 2023 13:31:14 +0800
From:   Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "Tom Zanussi" <zanussi@kernel.org>
CC:     <Bobule.chang@mediatek.com>, <wsd_upstream@mediatek.com>,
        Tze-nan Wu <Tze-nan.Wu@mediatek.com>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH] tracing: Fix use-after-free and double-free on last_cmd
Date:   Fri, 17 Mar 2023 13:30:44 +0800
Message-ID: <20230317053044.13828-1-cheng-jui.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tze-nan Wu" <Tze-nan.Wu@mediatek.com>

Currently, the last_cmd variable can be accessed by multiple processes
asynchronously when multiple users manipulate synthetic_events node
at the same time, it could lead to use-after-free or double-free.

This patch add lastcmd_mutex to prevent last_cmd from being accessed
asynchronously.

================================================================

It's easy to reproduce in the KASAN environment by running the two
scripts below in different shells.

script 1:
        while :
        do
                echo -n -e '\x88' > /sys/kernel/tracing/synthetic_events
        done

script 2:
        while :
        do
                echo -n -e '\xb0' > /sys/kernel/tracing/synthetic_events
        done

================================================================
double-free scenario:

    process A                       process B
-------------------               ---------------
1.kstrdup last_cmd
                                  2.free last_cmd
3.free last_cmd(double-free)

================================================================
use-after-free scenario:

    process A                       process B
-------------------               ---------------
1.kstrdup last_cmd
                                  2.free last_cmd
3.tracing_log_err(use-after-free)

================================================================

Appendix 1. KASAN report double-free:

BUG: KASAN: double-free in kfree+0xdc/0x1d4
Free of addr ***** by task sh/4879
Call trace:
        ...
        kfree+0xdc/0x1d4
        create_or_delete_synth_event+0x60/0x1e8
        trace_parse_run_command+0x2bc/0x4b8
        synth_events_write+0x20/0x30
        vfs_write+0x200/0x830
        ...

Allocated by task 4879:
        ...
        kstrdup+0x5c/0x98
        create_or_delete_synth_event+0x6c/0x1e8
        trace_parse_run_command+0x2bc/0x4b8
        synth_events_write+0x20/0x30
        vfs_write+0x200/0x830
        ...

Freed by task 5464:
        ...
        kfree+0xdc/0x1d4
        create_or_delete_synth_event+0x60/0x1e8
        trace_parse_run_command+0x2bc/0x4b8
        synth_events_write+0x20/0x30
        vfs_write+0x200/0x830
        ...

================================================================
Appendix 2. KASAN report use-after-free:

BUG: KASAN: use-after-free in strlen+0x5c/0x7c
Read of size 1 at addr ***** by task sh/5483
sh: CPU: 7 PID: 5483 Comm: sh
        ...
        __asan_report_load1_noabort+0x34/0x44
        strlen+0x5c/0x7c
        tracing_log_err+0x60/0x444
        create_or_delete_synth_event+0xc4/0x204
        trace_parse_run_command+0x2bc/0x4b8
        synth_events_write+0x20/0x30
        vfs_write+0x200/0x830
        ...

Allocated by task 5483:
        ...
        kstrdup+0x5c/0x98
        create_or_delete_synth_event+0x80/0x204
        trace_parse_run_command+0x2bc/0x4b8
        synth_events_write+0x20/0x30
        vfs_write+0x200/0x830
        ...

Freed by task 5480:
        ...
        kfree+0xdc/0x1d4
        create_or_delete_synth_event+0x74/0x204
        trace_parse_run_command+0x2bc/0x4b8
        synth_events_write+0x20/0x30
        vfs_write+0x200/0x830
        ...

Fixes: 27c888da9867 ("tracing: Remove size restriction on synthetic event cmd error logging")
Cc: stable@vger.kernel.org
Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
---
 kernel/trace/trace_events_synth.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 46d0abb32d0f..ce438eccab2e 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -42,16 +42,25 @@ enum { ERRORS };
 #undef C
 #define C(a, b)		b
 
+static DEFINE_MUTEX(lastcmd_mutex);
+
 static const char *err_text[] = { ERRORS };
 
 static char *last_cmd;
 
 static int errpos(const char *str)
 {
-	if (!str || !last_cmd)
-		return 0;
+	int ret = 0;
+
+	mutex_lock(&lastcmd_mutex);
+	if (!str || !last_cmd) {
+		mutex_unlock(&lastcmd_mutex);
+		return ret;
+	}
 
-	return err_pos(last_cmd, str);
+	ret = err_pos(last_cmd, str);
+	mutex_unlock(&lastcmd_mutex);
+	return ret;
 }
 
 static void last_cmd_set(const char *str)
@@ -59,18 +68,24 @@ static void last_cmd_set(const char *str)
 	if (!str)
 		return;
 
+	mutex_lock(&lastcmd_mutex);
 	kfree(last_cmd);
 
 	last_cmd = kstrdup(str, GFP_KERNEL);
+	mutex_unlock(&lastcmd_mutex);
 }
 
 static void synth_err(u8 err_type, u16 err_pos)
 {
-	if (!last_cmd)
+	mutex_lock(&lastcmd_mutex);
+	if (!last_cmd) {
+		mutex_unlock(&lastcmd_mutex);
 		return;
+	}
 
 	tracing_log_err(NULL, "synthetic_events", last_cmd, err_text,
 			err_type, err_pos);
+	mutex_unlock(&lastcmd_mutex);
 }
 
 static int create_synth_event(const char *raw_command);
-- 
2.18.0

