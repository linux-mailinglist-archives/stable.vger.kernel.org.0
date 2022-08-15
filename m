Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A167D594CAC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244252AbiHPA7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244032AbiHPAyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:54:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12E819C378;
        Mon, 15 Aug 2022 13:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A1633CE12DE;
        Mon, 15 Aug 2022 20:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E55C4314B;
        Mon, 15 Aug 2022 20:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596455;
        bh=DLGiwA63AXXNhPRPrN+7nn6lZx8gref/YXMUo+ADIzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Fiz1HuPu0NMgS2G2opq0hTPpNcMX18tDr1HqoHTLKkOZW4qkHWemL5DfrF8f8O6t
         BU8Q35mb7DCSigDe1tAqtPSDC8lr/9s7P9AE0mmX7AfamLYLlfPUODaskYM6Pnq/+i
         cnjUaCfk8e0IcJgzo/OK2SinbvRjb2gNDb5AxOKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.19 1051/1157] posix-cpu-timers: Cleanup CPU timers before freeing them during exec
Date:   Mon, 15 Aug 2022 20:06:47 +0200
Message-Id: <20220815180522.099633730@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit e362359ace6f87c201531872486ff295df306d13 upstream.

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
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220809170751.164716-1-cascardo@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1301,6 +1301,9 @@ int begin_new_exec(struct linux_binprm *
 	bprm->mm = NULL;
 
 #ifdef CONFIG_POSIX_TIMERS
+	spin_lock_irq(&me->sighand->siglock);
+	posix_cpu_timers_exit(me);
+	spin_unlock_irq(&me->sighand->siglock);
 	exit_itimers(me);
 	flush_itimer_signals();
 #endif


