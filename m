Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59749635616
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237596AbiKWJ0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237429AbiKWJZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:25:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A3F13F2C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:24:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7546661B22
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A75C433C1;
        Wed, 23 Nov 2022 09:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195463;
        bh=yV2QOT6MGDCcTaSh3CAzCJBGTzQqCDEh7xEJW+bRV/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Et7pFh/MbNkYaocc4yn/dGOBTq9UkYb8sK2RJ7CkDpjfjs785OXX8mn8M/UbQrg1s
         Bojmv5nufS8KL8h2/4+9GqKP3MOE2IEwf25Fd4r+0vvl0VD+kXLBqHhuxrQAWfDHTf
         dDmt9RePBGYvbFHnkBu0+tFI9asB714zNyIT3WO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 090/149] tracing: kprobe: Fix potential null-ptr-deref on trace_array in kprobe_event_gen_test_exit()
Date:   Wed, 23 Nov 2022 09:51:13 +0100
Message-Id: <20221123084601.227314967@linuxfoundation.org>
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

commit 22ea4ca9631eb137e64e5ab899e9c89cb6670959 upstream.

When test_gen_kprobe_cmd() failed after kprobe_event_gen_cmd_end(), it
will goto delete, which will call kprobe_event_delete() and release the
corresponding resource. However, the trace_array in gen_kretprobe_test
will point to the invalid resource. Set gen_kretprobe_test to NULL
after called kprobe_event_delete() to prevent null-ptr-deref.

BUG: kernel NULL pointer dereference, address: 0000000000000070
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 0 PID: 246 Comm: modprobe Tainted: G        W
6.1.0-rc1-00174-g9522dc5c87da-dirty #248
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
RIP: 0010:__ftrace_set_clr_event_nolock+0x53/0x1b0
Code: e8 82 26 fc ff 49 8b 1e c7 44 24 0c ea ff ff ff 49 39 de 0f 84 3c
01 00 00 c7 44 24 18 00 00 00 00 e8 61 26 fc ff 48 8b 6b 10 <44> 8b 65
70 4c 8b 6d 18 41 f7 c4 00 02 00 00 75 2f
RSP: 0018:ffffc9000159fe00 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88810971d268 RCX: 0000000000000000
RDX: ffff8881080be600 RSI: ffffffff811b48ff RDI: ffff88810971d058
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffffc9000159fe58 R11: 0000000000000001 R12: ffffffffa0001064
R13: ffffffffa000106c R14: ffff88810971d238 R15: 0000000000000000
FS:  00007f89eeff6540(0000) GS:ffff88813b600000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000070 CR3: 000000010599e004 CR4: 0000000000330ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __ftrace_set_clr_event+0x3e/0x60
 trace_array_set_clr_event+0x35/0x50
 ? 0xffffffffa0000000
 kprobe_event_gen_test_exit+0xcd/0x10b [kprobe_event_gen_test]
 __x64_sys_delete_module+0x206/0x380
 ? lockdep_hardirqs_on_prepare+0xd8/0x190
 ? syscall_enter_from_user_mode+0x1c/0x50
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f89eeb061b7

Link: https://lore.kernel.org/all/20221108015130.28326-3-shangxiaojing@huawei.com/

Fixes: 64836248dda2 ("tracing: Add kprobe event command generation test module")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Cc: stable@vger.kernel.org
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/kprobe_event_gen_test.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -143,6 +143,8 @@ static int __init test_gen_kprobe_cmd(vo
 	kfree(buf);
 	return ret;
  delete:
+	if (trace_event_file_is_valid(gen_kprobe_test))
+		gen_kprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
 	ret = kprobe_event_delete("gen_kprobe_test");
 	goto out;
@@ -206,6 +208,8 @@ static int __init test_gen_kretprobe_cmd
 	kfree(buf);
 	return ret;
  delete:
+	if (trace_event_file_is_valid(gen_kretprobe_test))
+		gen_kretprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
 	ret = kprobe_event_delete("gen_kretprobe_test");
 	goto out;


