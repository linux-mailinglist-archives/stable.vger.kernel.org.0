Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4156158DCD5
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 19:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245319AbiHIRJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 13:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245220AbiHIRJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 13:09:02 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0E423BDF;
        Tue,  9 Aug 2022 10:09:01 -0700 (PDT)
Received: from localhost.localdomain (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id E41443F100;
        Tue,  9 Aug 2022 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660064940;
        bh=ze03xbUn78LgfJuUNKBQC8X3WibtV+sxEkKu8Gimsms=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=EhmyyTKZ/QJB9cIsfZFTVMaOrn3p4V6YsWSI4GrzMgFS1hCxx+Fs/wyIKYzYewgYV
         aDifqbzhUlzANm+/3pVTMtLlC6fWEe9kYWJCj8c1TVNOiH/zu+uXfAeFpXM5P+6x+C
         xAOAzfIWZMIeVGAHSpYyPPs7LRD8dOKnELXMHE+Nzc9Dur0CW+rDUt0oHVfKtowElX
         Hzn5d2t58IluQi7KaM0baIgiAyshflezDnUHkP1TJWprlDX0x36eFK3FuDrTrKgzFR
         UxwjlyEfg3kZeVTr7tTcRdWw/Vt7FBnjzGu+1V9W3D0rXJYpLc3TKT8yJT/DzVUzc8
         XzHJSw126s7GQ==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eric Biederman <ebiederm@xmission.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [PATCH] posix-cpu-timers: Cleanup CPU timers before freeing them during exec
Date:   Tue,  9 Aug 2022 14:07:51 -0300
Message-Id: <20220809170751.164716-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 55e8c8eb2c7b ("posix-cpu-timers: Store a reference to a pid not a
task") started looking up tasks by PID when deleting a CPU timer.

When a non-leader thread calls execve, it will switch PIDs with the leader
process. Then, as it calls exit_itimers, posix_cpu_timer_del cannot find
the task because the timer still points out to the old PID.

That means that armed timers won't be disarmed, that is, they won't be
removed from the timerqueue_list. exit_itimers will still release their
memory, and when that list is later processed, it leads to a
use-after-free.

Clean up the timers from the de-threaded task before freeing them. This
prevents a reported use-after-free.

Fixes: 55e8c8eb2c7b ("posix-cpu-timers: Store a reference to a pid not a task")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
---
 fs/exec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 778123259e42..1c6b477dad69 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1301,6 +1301,9 @@ int begin_new_exec(struct linux_binprm * bprm)
 	bprm->mm = NULL;
 
 #ifdef CONFIG_POSIX_TIMERS
+	spin_lock_irq(&me->sighand->siglock);
+	posix_cpu_timers_exit(me);
+	spin_unlock_irq(&me->sighand->siglock);
 	exit_itimers(me);
 	flush_itimer_signals();
 #endif
-- 
2.34.1

