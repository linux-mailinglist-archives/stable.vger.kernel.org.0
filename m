Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7F62B619E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbgKQNUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730764AbgKQNUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:20:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9FD024631;
        Tue, 17 Nov 2020 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619248;
        bh=WRRFcS8HW06GjyG4XnjywfcmKjugjc+4n/ozvN6bTNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ealvU2VoLAcDuriulHUEzggyUdXz7C5oRu5l2xj9wPSSi7YX+BTh1rXezJ16t6Q7q
         Ad/gfqXhYLNSvyE1+isEwJhW9kNjwc2B0YZIP9b+AjAK3r1PYG23+ncDKC9sTYOpVi
         N6gQfbpbP9sCf2m2onGp/sn7NpYjSDACUqfIXQ34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 048/101] tick/common: Touch watchdog in tick_unfreeze() on all CPUs
Date:   Tue, 17 Nov 2020 14:05:15 +0100
Message-Id: <20201117122115.431893723@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <zhang.lyra@gmail.com>

commit 5167c506d62dd9ffab73eba23c79b0a8845c9fe1 upstream.

Suspend to IDLE invokes tick_unfreeze() on resume. tick_unfreeze() on the
first resuming CPU resumes timekeeping, which also has the side effect of
resetting the softlockup watchdog on this CPU.

But on the secondary CPUs the watchdog is not reset in the resume /
unfreeze() path, which can result in false softlockup warnings on those
CPUs depending on the time spent in suspend.

Prevent this by clearing the softlock watchdog in the unfreeze path also
on the secondary resuming CPUs.

[ tglx: Massaged changelog ]

Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200110083902.27276-1-chunyan.zhang@unisoc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/hrtimer.h>
 #include <linux/interrupt.h>
+#include <linux/nmi.h>
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
@@ -520,6 +521,7 @@ void tick_unfreeze(void)
 		trace_suspend_resume(TPS("timekeeping_freeze"),
 				     smp_processor_id(), false);
 	} else {
+		touch_softlockup_watchdog();
 		tick_resume_local();
 	}
 


