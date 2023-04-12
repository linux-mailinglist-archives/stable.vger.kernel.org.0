Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508736DEECF
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjDLIpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjDLIow (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E572F7280
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98F39630C5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF15DC4339B;
        Wed, 12 Apr 2023 08:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289064;
        bh=bQNSIlfoowlZAxsVwrWOChNZgJI9gpSXvSPHeUNqQoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeGCRAVHTb4mHtaG1+wt5F/iJeS+AB2naMMlNJMIMxXc2SJ5YgPzs5R8UcE7ZCilU
         2Z2uyJBqL0kWGtyq2VzbZamxcmcJvPMgr0Rm2En4/OGx/6y5qUSl/eKUmm7R0/WnWO
         dDNB8qP5jZCMLQeLm0h/pobSYv45fwtJuTKr3y+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "Tom Zanussi" <zanussi@kernel.org>,
        Tze-nan Wu <Tze-nan.Wu@mediatek.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 123/164] tracing/synthetic: Fix races on freeing last_cmd
Date:   Wed, 12 Apr 2023 10:34:05 +0200
Message-Id: <20230412082841.828353641@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tze-nan Wu <Tze-nan.Wu@mediatek.com>

commit 4ccf11c4e8a8e051499d53a12f502196c97a758e upstream.

Currently, the "last_cmd" variable can be accessed by multiple processes
asynchronously when multiple users manipulate synthetic_events node
at the same time, it could lead to use-after-free or double-free.

This patch add "lastcmd_mutex" to prevent "last_cmd" from being accessed
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

Link: https://lore.kernel.org/linux-trace-kernel/20230321110444.1587-1-Tze-nan.Wu@mediatek.com

Fixes: 27c888da9867 ("tracing: Remove size restriction on synthetic event cmd error logging")
Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: "Tom Zanussi" <zanussi@kernel.org>
Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -44,14 +44,21 @@ enum { ERRORS };
 
 static const char *err_text[] = { ERRORS };
 
+DEFINE_MUTEX(lastcmd_mutex);
 static char *last_cmd;
 
 static int errpos(const char *str)
 {
+	int ret = 0;
+
+	mutex_lock(&lastcmd_mutex);
 	if (!str || !last_cmd)
-		return 0;
+		goto out;
 
-	return err_pos(last_cmd, str);
+	ret = err_pos(last_cmd, str);
+ out:
+	mutex_unlock(&lastcmd_mutex);
+	return ret;
 }
 
 static void last_cmd_set(const char *str)
@@ -59,18 +66,22 @@ static void last_cmd_set(const char *str
 	if (!str)
 		return;
 
+	mutex_lock(&lastcmd_mutex);
 	kfree(last_cmd);
-
 	last_cmd = kstrdup(str, GFP_KERNEL);
+	mutex_unlock(&lastcmd_mutex);
 }
 
 static void synth_err(u8 err_type, u16 err_pos)
 {
+	mutex_lock(&lastcmd_mutex);
 	if (!last_cmd)
-		return;
+		goto out;
 
 	tracing_log_err(NULL, "synthetic_events", last_cmd, err_text,
 			err_type, err_pos);
+ out:
+	mutex_unlock(&lastcmd_mutex);
 }
 
 static int create_synth_event(const char *raw_command);


