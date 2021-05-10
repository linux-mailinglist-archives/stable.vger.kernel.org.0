Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD213786E5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhEJLL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235172AbhEJLFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AA2561464;
        Mon, 10 May 2021 10:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644129;
        bh=Zhgo775RobH0jK80dlY/sZcAE/GAS/5EMxlJHidUkpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwuBPhAMR/cKVRa40awF0xTehgRIrasVOCJCHyIpn+gz0gjtxzjjmMzqciintFzjk
         B1c6BCFz0hN7vwuotWQMd8unpIz2c8scqh9nKIz6kGjl14sZ4iFLBtDM7MNPcbucw/
         bKdDH7fcK28lPS+FlzlCY6d+D/VzKnCsUBQI3hRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.11 300/342] futex: Do not apply time namespace adjustment on FUTEX_LOCK_PI
Date:   Mon, 10 May 2021 12:21:30 +0200
Message-Id: <20210510102020.015918637@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit cdf78db4070967869e4d027c11f4dd825d8f815a upstream.

FUTEX_LOCK_PI does not require to have the FUTEX_CLOCK_REALTIME bit set
because it has been using CLOCK_REALTIME based absolute timeouts
forever. Due to that, the time namespace adjustment which is applied when
FUTEX_CLOCK_REALTIME is not set, will wrongly take place for FUTEX_LOCK_PI
and wreckage the timeout.

Exclude it from that procedure.

Fixes: c2f7d08cccf4 ("futex: Adjust absolute futex timeouts with per time namespace offset")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210422194704.984540159@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3782,7 +3782,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uad
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
-		else if (!(op & FUTEX_CLOCK_REALTIME))
+		else if (cmd != FUTEX_LOCK_PI && !(op & FUTEX_CLOCK_REALTIME))
 			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
@@ -3976,7 +3976,7 @@ SYSCALL_DEFINE6(futex_time32, u32 __user
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
-		else if (!(op & FUTEX_CLOCK_REALTIME))
+		else if (cmd != FUTEX_LOCK_PI && !(op & FUTEX_CLOCK_REALTIME))
 			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}


