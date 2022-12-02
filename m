Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EFE64086B
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 15:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbiLBO3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 09:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiLBO3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 09:29:49 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24064DC84A
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 06:29:48 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d1so8019155wrs.12
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 06:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L5MpI10edvhSDVpoDMO+AW5YAFSO4C4Q9GbgQQqD53M=;
        b=hojgdayAGOBXvWMag5tPgbgyJNWLh3PpHqByN3DdZZJo1RIuYiFPT0Yyrz4xESsrkl
         1Zm9yflyopABhOiCjLlPqlrCgXe2wPhxvs8CWmVlqfuUo553T6CKsQaNY19PY1fc0aR5
         GU39yNytz9VDfr8zq2Vt3BAettF6EmvaWpeJY0ZNT3NSDEkLuRvr5Ft1VGqz9pHRS9nD
         vcSo5HhrRvOYCgAl9RTVvwXeHFUb28VJ6aO0gIWmbX6udoAESxIM4YO/S2CeCTXoTLzK
         MOXHo/M1W/pIfNTx58KAMeQQZ05lTmf4UvWIOuEE2x+P1dB6RR3NCKLF0CSM0auOD26W
         I+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L5MpI10edvhSDVpoDMO+AW5YAFSO4C4Q9GbgQQqD53M=;
        b=GgnTX2AZX1dZvLcxmpAdCApy4Wkc0oeni/WMfmHXj9bsfWJMuEMHsQxpzGqc+UCw6M
         VSdLhKPVhP7rLCZ/RkOKTV26mpNqLey6tg7blRBtGs8IdH2AjQhZZYr0v5KSjMBc1hvb
         9Jq4p/VePs0wp65neARPyP1rjgUZEXJWw+qq7EeDnC1rEvfCsQt/ruhL9j+9RSa6RLOj
         alPoXc6DRs4mDgjRjLleZ/Jdw3b+7k4PnblwuAoGylsiM/eBw99UO3KnSo4gvFXOaHhP
         NrqurT7hPuW+RSmxr/YwUIWF7T03nXB8nsIp/T+qBNWJuFLvPuytDv4vlK/dCLtfvmif
         x6Lw==
X-Gm-Message-State: ANoB5plGm8oA2vg7LLj6v+BfdlapqTmkcGnPEVzCcu1/ckXps7lOdR/d
        cQcZCYekhaHIMr9oj8na2mIwpyKVZsU=
X-Google-Smtp-Source: AA0mqf71xS68FGyLDxHp65B2rVLf+o6u/Ly5Hnpk2PlpaBJUJbEJuOxdKgzoAIL5DYRFM+2y/lexIQ==
X-Received: by 2002:adf:eb8a:0:b0:22e:31b2:ecb9 with SMTP id t10-20020adfeb8a000000b0022e31b2ecb9mr44879434wrn.693.1669991386488;
        Fri, 02 Dec 2022 06:29:46 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:2dd3])
        by smtp.gmail.com with ESMTPSA id n187-20020a1ca4c4000000b003d005aab31asm8956946wme.40.2022.12.02.06.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 06:29:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Lin Ma <linma@zju.edu.cn>
Subject: [PATCH stable-5.15 5/5] io_uring/poll: fix poll_refs race with cancelation
Date:   Fri,  2 Dec 2022 14:27:15 +0000
Message-Id: <886a17368c8fd21e58b9d5d47ead7d1f45fe5ebf.1669990799.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669990799.git.asml.silence@gmail.com>
References: <cover.1669990799.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ upstream commit 12ad3d2d6c5b0131a6052de91360849e3e154846 ]

There is an interesting race condition of poll_refs which could result
in a NULL pointer dereference. The crash trace is like:

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 30781 Comm: syz-executor.2 Not tainted 6.0.0-g493ffd6605b2 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:io_poll_remove_entry io_uring/poll.c:154 [inline]
RIP: 0010:io_poll_remove_entries+0x171/0x5b4 io_uring/poll.c:190
Code: ...
RSP: 0018:ffff88810dfefba0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000040000
RDX: ffffc900030c4000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: 0000000000000008 R08: ffffffff9764d3dd R09: fffffbfff3836781
R10: fffffbfff3836781 R11: 0000000000000000 R12: 1ffff11003422d60
R13: ffff88801a116b04 R14: ffff88801a116ac0 R15: dffffc0000000000
FS:  00007f9c07497700(0000) GS:ffff88811a600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffb5c00ea98 CR3: 0000000105680005 CR4: 0000000000770ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 io_apoll_task_func+0x3f/0xa0 io_uring/poll.c:299
 handle_tw_list io_uring/io_uring.c:1037 [inline]
 tctx_task_work+0x37e/0x4f0 io_uring/io_uring.c:1090
 task_work_run+0x13a/0x1b0 kernel/task_work.c:177
 get_signal+0x2402/0x25a0 kernel/signal.c:2635
 arch_do_signal_or_restart+0x3b/0x660 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0xc2/0x160 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x58/0x160 kernel/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The root cause for this is a tiny overlooking in
io_poll_check_events() when cocurrently run with poll cancel routine
io_poll_cancel_req().

The interleaving to trigger use-after-free:

CPU0                                       |  CPU1
                                           |
io_apoll_task_func()                       |  io_poll_cancel_req()
 io_poll_check_events()                    |
  // do while first loop                   |
  v = atomic_read(...)                     |
  // v = poll_refs = 1                     |
  ...                                      |  io_poll_mark_cancelled()
                                           |   atomic_or()
                                           |   // poll_refs =
IO_POLL_CANCEL_FLAG | 1
                                           |
  atomic_sub_return(...)                   |
  // poll_refs = IO_POLL_CANCEL_FLAG       |
  // loop continue                         |
                                           |
                                           |  io_poll_execute()
                                           |   io_poll_get_ownership()
                                           |   // poll_refs =
IO_POLL_CANCEL_FLAG | 1
                                           |   // gets the ownership
  v = atomic_read(...)                     |
  // poll_refs not change                  |
                                           |
  if (v & IO_POLL_CANCEL_FLAG)             |
   return -ECANCELED;                      |
  // io_poll_check_events return           |
  // will go into                          |
  // io_req_complete_failed() free req     |
                                           |
                                           |  io_apoll_task_func()
                                           |  // also go into
io_req_complete_failed()

And the interleaving to trigger the kernel WARNING:

CPU0                                       |  CPU1
                                           |
io_apoll_task_func()                       |  io_poll_cancel_req()
 io_poll_check_events()                    |
  // do while first loop                   |
  v = atomic_read(...)                     |
  // v = poll_refs = 1                     |
  ...                                      |  io_poll_mark_cancelled()
                                           |   atomic_or()
                                           |   // poll_refs =
IO_POLL_CANCEL_FLAG | 1
                                           |
  atomic_sub_return(...)                   |
  // poll_refs = IO_POLL_CANCEL_FLAG       |
  // loop continue                         |
                                           |
  v = atomic_read(...)                     |
  // v = IO_POLL_CANCEL_FLAG               |
                                           |  io_poll_execute()
                                           |   io_poll_get_ownership()
                                           |   // poll_refs =
IO_POLL_CANCEL_FLAG | 1
                                           |   // gets the ownership
                                           |
  WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))   |
  // v & IO_POLL_REF_MASK = 0 WARN         |
                                           |
                                           |  io_apoll_task_func()
                                           |  // also go into
io_req_complete_failed()

By looking up the source code and communicating with Pavel, the
implementation of this atomic poll refs should continue the loop of
io_poll_check_events() just to avoid somewhere else to grab the
ownership. Therefore, this patch simply adds another AND operation to
make sure the loop will stop if it finds the poll_refs is exactly equal
to IO_POLL_CANCEL_FLAG. Since io_poll_cancel_req() grabs ownership and
will finally make its way to io_req_complete_failed(), the req will
be reclaimed as expected.

Fixes: aa43477b0402 ("io_uring: poll rework")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
[axboe: tweak description and code style]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 11dcad170594..c2fdde6fdda3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5512,7 +5512,8 @@ static int io_poll_check_events(struct io_kiocb *req)
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
+	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs) &
+					IO_POLL_REF_MASK);
 
 	return 1;
 }
-- 
2.38.1

