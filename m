Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BBC6355E8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbiKWJ0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237583AbiKWJZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:25:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E921DD100
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:24:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4423B81EA9
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7553C433D6;
        Wed, 23 Nov 2022 09:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195454;
        bh=DJXZ58Qia/mujVLNLhDP8xMbLJ6eJy/f2sTwrkgyJAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zvn6cJDqlABi+OQFQdO5eiOXDkc2uZqXHE4aRCU6ixKHFK8f0W8iX/Jfrs+zsAsPN
         ig82Ejx3Z6nzyezYjdSeNTudL+qD67KhKO2DfpVAEjDtvkZBPNJYIDpJjPf9qHM6d1
         DwQfGYvlXH51iOX7+N/suBy+ZZ45sWW0V/3dsdPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, mhiramat@kernel.org, zanussi@kernel.org,
        fengguang.wu@intel.com, Shang XiaoJing <shangxiaojing@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 087/149] tracing: Fix memory leak in test_gen_synth_cmd() and test_empty_synth_event()
Date:   Wed, 23 Nov 2022 09:51:10 +0100
Message-Id: <20221123084601.107762734@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shang XiaoJing <shangxiaojing@huawei.com>

commit a4527fef9afe5c903c718d0cd24609fe9c754250 upstream.

test_gen_synth_cmd() only free buf in fail path, hence buf will leak
when there is no failure. Add kfree(buf) to prevent the memleak. The
same reason and solution in test_empty_synth_event().

unreferenced object 0xffff8881127de000 (size 2048):
  comm "modprobe", pid 247, jiffies 4294972316 (age 78.756s)
  hex dump (first 32 bytes):
    20 67 65 6e 5f 73 79 6e 74 68 5f 74 65 73 74 20   gen_synth_test
    20 70 69 64 5f 74 20 6e 65 78 74 5f 70 69 64 5f   pid_t next_pid_
  backtrace:
    [<000000004254801a>] kmalloc_trace+0x26/0x100
    [<0000000039eb1cf5>] 0xffffffffa00083cd
    [<000000000e8c3bc8>] 0xffffffffa00086ba
    [<00000000c293d1ea>] do_one_initcall+0xdb/0x480
    [<00000000aa189e6d>] do_init_module+0x1cf/0x680
    [<00000000d513222b>] load_module+0x6a50/0x70a0
    [<000000001fd4d529>] __do_sys_finit_module+0x12f/0x1c0
    [<00000000b36c4c0f>] do_syscall_64+0x3f/0x90
    [<00000000bbf20cf3>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
unreferenced object 0xffff8881127df000 (size 2048):
  comm "modprobe", pid 247, jiffies 4294972324 (age 78.728s)
  hex dump (first 32 bytes):
    20 65 6d 70 74 79 5f 73 79 6e 74 68 5f 74 65 73   empty_synth_tes
    74 20 20 70 69 64 5f 74 20 6e 65 78 74 5f 70 69  t  pid_t next_pi
  backtrace:
    [<000000004254801a>] kmalloc_trace+0x26/0x100
    [<00000000d4db9a3d>] 0xffffffffa0008071
    [<00000000c31354a5>] 0xffffffffa00086ce
    [<00000000c293d1ea>] do_one_initcall+0xdb/0x480
    [<00000000aa189e6d>] do_init_module+0x1cf/0x680
    [<00000000d513222b>] load_module+0x6a50/0x70a0
    [<000000001fd4d529>] __do_sys_finit_module+0x12f/0x1c0
    [<00000000b36c4c0f>] do_syscall_64+0x3f/0x90
    [<00000000bbf20cf3>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://lkml.kernel.org/r/20221117012346.22647-2-shangxiaojing@huawei.com

Cc: <mhiramat@kernel.org>
Cc: <zanussi@kernel.org>
Cc: <fengguang.wu@intel.com>
Cc: stable@vger.kernel.org
Fixes: 9fe41efaca08 ("tracing: Add synth event generation test module")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/synth_event_gen_test.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/kernel/trace/synth_event_gen_test.c
+++ b/kernel/trace/synth_event_gen_test.c
@@ -120,15 +120,13 @@ static int __init test_gen_synth_cmd(voi
 
 	/* Now generate a gen_synth_test event */
 	ret = synth_event_trace_array(gen_synth_test, vals, ARRAY_SIZE(vals));
- out:
+ free:
+	kfree(buf);
 	return ret;
  delete:
 	/* We got an error after creating the event, delete it */
 	synth_event_delete("gen_synth_test");
- free:
-	kfree(buf);
-
-	goto out;
+	goto free;
 }
 
 /*
@@ -227,15 +225,13 @@ static int __init test_empty_synth_event
 
 	/* Now trace an empty_synth_test event */
 	ret = synth_event_trace_array(empty_synth_test, vals, ARRAY_SIZE(vals));
- out:
+ free:
+	kfree(buf);
 	return ret;
  delete:
 	/* We got an error after creating the event, delete it */
 	synth_event_delete("empty_synth_test");
- free:
-	kfree(buf);
-
-	goto out;
+	goto free;
 }
 
 static struct synth_field_desc create_synth_test_fields[] = {


