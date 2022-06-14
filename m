Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C002254A6DB
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355418AbiFNCca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356451AbiFNCbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:31:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBFD433B6;
        Mon, 13 Jun 2022 19:12:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5F2FB816A3;
        Tue, 14 Jun 2022 02:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1774C341C0;
        Tue, 14 Jun 2022 02:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172688;
        bh=mqbC7bVhIM0dnxYNVzszPMiYzv0AKKldGP1tDyqt/kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cO3R5He039RvxjjhaZ7WHC9BCuGtY+dX4UY2XlrB337aqJQPomAf4qWjMzQ6W1uQE
         HFGUq3koV136+KyO3qjwS4VbU8l2M2HGaPIrAHWgeSlc9RbbYRz9WgXLqHgVGsSTNt
         S2Jl0KoEUzt0MBDlfsNRC7IyKw5tHxHszmU4f0QHlhS9qRiMrVas1me/5Q76EcLrxE
         gBIFoxW4gZFod5sDapmDq1GJmRJalPdcGlsdJ2G8xGUu+GLdQjrNNabw30qFyrTxNG
         tjvc7PgKKAEQ3aNqf6nmhVRFToZCtWH99pkMh7VZbboBynzp3MtaNpH8jdOMjg3enj
         7UiECvnIQDcpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Seth Forshee <sforshee@digitalocean.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        peterz@infradead.org, luto@kernel.org
Subject: [PATCH MANUALSEL 5.18 5/6] entry/kvm: Exit to user mode when TIF_NOTIFY_SIGNAL is set
Date:   Mon, 13 Jun 2022 22:11:14 -0400
Message-Id: <20220614021116.1101331-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614021116.1101331-1-sashal@kernel.org>
References: <20220614021116.1101331-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Forshee <sforshee@digitalocean.com>

[ Upstream commit 3e684903a8574ffc9475fdf13c4780a7adb506ad ]

A livepatch transition may stall indefinitely when a kvm vCPU is heavily
loaded. To the host, the vCPU task is a user thread which is spending a
very long time in the ioctl(KVM_RUN) syscall. During livepatch
transition, set_notify_signal() will be called on such tasks to
interrupt the syscall so that the task can be transitioned. This
interrupts guest execution, but when xfer_to_guest_mode_work() sees that
TIF_NOTIFY_SIGNAL is set but not TIF_SIGPENDING it concludes that an
exit to user mode is unnecessary, and guest execution is resumed without
transitioning the task for the livepatch.

This handling of TIF_NOTIFY_SIGNAL is incorrect, as set_notify_signal()
is expected to break tasks out of interruptible kernel loops and cause
them to return to userspace. Change xfer_to_guest_mode_work() to handle
TIF_NOTIFY_SIGNAL the same as TIF_SIGPENDING, signaling to the vCPU run
loop that an exit to userpsace is needed. Any pending task_work will be
run when get_signal() is called from exit_to_user_mode_loop(), so there
is no longer any need to run task work from xfer_to_guest_mode_work().

Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
Message-Id: <20220504180840.2907296-1-sforshee@digitalocean.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/entry/kvm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index 9d09f489b60e..2e0f75bcb7fd 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -9,12 +9,6 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 		int ret;
 
 		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
-			clear_notify_signal();
-			if (task_work_pending(current))
-				task_work_run();
-		}
-
-		if (ti_work & _TIF_SIGPENDING) {
 			kvm_handle_signal_exit(vcpu);
 			return -EINTR;
 		}
-- 
2.35.1

