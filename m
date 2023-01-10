Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCDE6648C4
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239043AbjAJSOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238872AbjAJSNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:13:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B923D1CC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF311B81908
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D389C433D2;
        Tue, 10 Jan 2023 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374311;
        bh=4oQpc33VE4R5IPFFjvsxk9UEnDWKggABIpooxfhfuP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLnsoxA+Tn4lDW6qsShB0yEBshIpHiClmq5SMgNU3j/EwWlAtIXwjEDNtyk1vvctw
         h9Exo4SVvSsp9h/PEJ/J3EqSSMQ+40qBH8Zj+A7bdC+qymKK98AzxhmPy38gMQyXXo
         QaGW9IOxaw4+MUB2vF5xz4RhgDsHGkrCRmknHsv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chuang Wang <nashuiliang@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>, Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.0 125/148] bpf: Fix panic due to wrong pageattr of im->image
Date:   Tue, 10 Jan 2023 19:03:49 +0100
Message-Id: <20230110180021.155021878@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Chuang Wang <nashuiliang@gmail.com>

commit 9ed1d9aeef5842ecacb660fce933613b58af1e00 upstream.

In the scenario where livepatch and kretfunc coexist, the pageattr of
im->image is rox after arch_prepare_bpf_trampoline in
bpf_trampoline_update, and then modify_fentry or register_fentry returns
-EAGAIN from bpf_tramp_ftrace_ops_func, the BPF_TRAMP_F_ORIG_STACK flag
will be configured, and arch_prepare_bpf_trampoline will be re-executed.

At this time, because the pageattr of im->image is rox,
arch_prepare_bpf_trampoline will read and write im->image, which causes
a fault. as follows:

  insmod livepatch-sample.ko    # samples/livepatch/livepatch-sample.c
  bpftrace -e 'kretfunc:cmdline_proc_show {}'

BUG: unable to handle page fault for address: ffffffffa0206000
PGD 322d067 P4D 322d067 PUD 322e063 PMD 1297e067 PTE d428061
Oops: 0003 [#1] PREEMPT SMP PTI
CPU: 2 PID: 270 Comm: bpftrace Tainted: G            E K    6.1.0 #5
RIP: 0010:arch_prepare_bpf_trampoline+0xed/0x8c0
RSP: 0018:ffffc90001083ad8 EFLAGS: 00010202
RAX: ffffffffa0206000 RBX: 0000000000000020 RCX: 0000000000000000
RDX: ffffffffa0206001 RSI: ffffffffa0206000 RDI: 0000000000000030
RBP: ffffc90001083b70 R08: 0000000000000066 R09: ffff88800f51b400
R10: 000000002e72c6e5 R11: 00000000d0a15080 R12: ffff8880110a68c8
R13: 0000000000000000 R14: ffff88800f51b400 R15: ffffffff814fec10
FS:  00007f87bc0dc780(0000) GS:ffff88803e600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa0206000 CR3: 0000000010b70000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
 bpf_trampoline_update+0x25a/0x6b0
 __bpf_trampoline_link_prog+0x101/0x240
 bpf_trampoline_link_prog+0x2d/0x50
 bpf_tracing_prog_attach+0x24c/0x530
 bpf_raw_tp_link_attach+0x73/0x1d0
 __sys_bpf+0x100e/0x2570
 __x64_sys_bpf+0x1c/0x30
 do_syscall_64+0x5b/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

With this patch, when modify_fentry or register_fentry returns -EAGAIN
from bpf_tramp_ftrace_ops_func, the pageattr of im->image will be reset
to nx+rw.

Cc: stable@vger.kernel.org
Fixes: 00963a2e75a8 ("bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)")
Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20221224133146.780578-1-nashuiliang@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/trampoline.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -501,6 +501,10 @@ again:
 		/* reset fops->func and fops->trampoline for re-register */
 		tr->fops->func = NULL;
 		tr->fops->trampoline = 0;
+
+		/* reset im->image memory attr for arch_prepare_bpf_trampoline */
+		set_memory_nx((long)im->image, 1);
+		set_memory_rw((long)im->image, 1);
 		goto again;
 	}
 #endif


