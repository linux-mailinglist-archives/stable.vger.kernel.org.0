Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85E9655A3D
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 14:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiLXNcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Dec 2022 08:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiLXNcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Dec 2022 08:32:07 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C147CB874;
        Sat, 24 Dec 2022 05:32:05 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gv5-20020a17090b11c500b00223f01c73c3so9384340pjb.0;
        Sat, 24 Dec 2022 05:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ezbgi7pFZDSI5daM/rTTeMIyWE+f6CFg+hkqxOhS5a8=;
        b=IyPBkh5/wfZylagV2DGKZke+JEXbgYVmRWlpgW8zvnOKQp2RSHyA7e27SxdTtOBWX9
         /oBwuHUOHGRHuIcYkrCX/3j0ptHg8zM0rOMfBuua0xfCTvJXMw5YU177KfTPV3S5nhXc
         JH4jSbGdkdnBo0WOa4EhIQdieIGontdarhWUMuu0T62nsyVTGcW4FDQRfdGP4kq0vJBg
         XY5bg8sajJj/liKHKQ5vs758KTw3ig2FKatZSA2uhgB5IzpERzpXBkjAvHV2ee5/8gbQ
         LooEHm/8LtNSeTGQLVpmk61H0HoPi8NbIOZnib8Mpe3gFqPsWASP8PZWgBqP6qMuFnYs
         Uw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ezbgi7pFZDSI5daM/rTTeMIyWE+f6CFg+hkqxOhS5a8=;
        b=m2zsJDrWElZP6MrQozjbznRNGoFB8Rw6l7wqHj6pnvx1TBH3zBMwfZifKaTd94/mkv
         UHL0ASLatw+BRJhpYF96x4JDAhvXxeJtFWGhAHWv3Vn+ntPhPrgJhaaTwb12ZtD5UZUQ
         pjuvCuHtK5eX4bZ+YdI+ar9fE/y/LYFKXNqjHMyQBknipLa1/OeGHkpoCrWV9r5rMjfH
         sTAAgodgYlCPP5+p2N/Ei/SSU6nx8kqbOUpani7OteBzDIplrRAX7+UbyTShkHV/ZLMG
         bCs0qShr4vARfBWhZyAhppP7i6cRY2IFLM9EAEYDkV6gokpnYDsDkqQkj195wy4wbx89
         Zf+A==
X-Gm-Message-State: AFqh2kol+h5ceZZeydUZSlvo3m1wcm9PwLuK8TqLROgXQ/t3lIGu9DRf
        5R/LxXFLeVomongLAJ3ajtQ=
X-Google-Smtp-Source: AMrXdXt2hDH2u5l4yIySVrZgomRZt8gsNdAeHJBMgH/eQy2sFsOU7TsXEF/cAdwORulNuohnOz3IDw==
X-Received: by 2002:a05:6a20:8e0b:b0:ad:a0c2:53ee with SMTP id y11-20020a056a208e0b00b000ada0c253eemr21432585pzj.12.1671888725153;
        Sat, 24 Dec 2022 05:32:05 -0800 (PST)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id k24-20020a63f018000000b00478fbfd5276sm3716301pgh.15.2022.12.24.05.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Dec 2022 05:32:04 -0800 (PST)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>, stable@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: Fix panic due to wrong pageattr of im->image
Date:   Sat, 24 Dec 2022 21:31:46 +0800
Message-Id: <20221224133146.780578-1-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 kernel/bpf/trampoline.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 11f5ec0b8016..d0ed7d6f5eec 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -488,6 +488,10 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
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
-- 
2.37.2

