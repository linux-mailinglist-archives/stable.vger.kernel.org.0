Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F40375A08
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 20:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhEFSPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 14:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbhEFSPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 14:15:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3251FC061574;
        Thu,  6 May 2021 11:14:37 -0700 (PDT)
Date:   Thu, 06 May 2021 18:14:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620324874;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zWm/0xkgZ0SYrP+b6r9NYNOXqltOlwtRI04t6RYylqk=;
        b=xtjIgE6mvKwIRcfflj5/yaqwOkEsS5k5wdiBynDL+oJzWlVqFiYWqbqUQOkH3So06cmFaP
        J+hRnmBkalXKaOFrP8tXKWlTrlfDVRvPca9xilPD/+qEtL5pFCCVXl8Hkz7EgRtVd4HleV
        datI17B3EYXRikiDTNEEgQUjlKkLEbhtjyUfKBFjUcmx73E90bElWvoOWlhNrmsP0IBQMV
        nnfpvOniWS8uXz/UAh5LjXFr1p6UKH1bN/i0d3QGQTdW7I4oZr9SQPOrnMSw6jjAl7KtoX
        EebUT/sahhohKyDV3g8Wo+4xeEOoZEr9wBin2iF8rH8LO+Whw7mCXHNUHSwIiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620324874;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zWm/0xkgZ0SYrP+b6r9NYNOXqltOlwtRI04t6RYylqk=;
        b=kEp/sfUVkF6wLOr35Pr0eyJzAwPO8I3tWMtsSY82m4BsXqZxlPrkeeYKd3I/r0diMcoRh4
        qZx61IXuSOFHKJDg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] Revert 337f13046ff0 ("futex: Allow
 FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210422194704.834797921@linutronix.de>
References: <20210422194704.834797921@linutronix.de>
MIME-Version: 1.0
Message-ID: <162032487332.29796.830376668857482717.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     4fbf5d6837bf81fd7a27d771358f4ee6c4f243f8
Gitweb:        https://git.kernel.org/tip/4fbf5d6837bf81fd7a27d771358f4ee6c4f243f8
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 22 Apr 2021 21:44:18 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 06 May 2021 20:12:40 +02:00

Revert 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")

The FUTEX_WAIT operand has historically a relative timeout which means that
the clock id is irrelevant as relative timeouts on CLOCK_REALTIME are not
subject to wall clock changes and therefore are mapped by the kernel to
CLOCK_MONOTONIC for simplicity.

If a caller would set FUTEX_CLOCK_REALTIME for FUTEX_WAIT the timeout is
still treated relative vs. CLOCK_MONOTONIC and then the wait arms that
timeout based on CLOCK_REALTIME which is broken and obviously has never
been used or even tested.

Reject any attempt to use FUTEX_CLOCK_REALTIME with FUTEX_WAIT again.

The desired functionality can be achieved with FUTEX_WAIT_BITSET and a
FUTEX_BITSET_MATCH_ANY argument.

Fixes: 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210422194704.834797921@linutronix.de

---
 kernel/futex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c98b825..4740200 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3710,8 +3710,7 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 
 	if (op & FUTEX_CLOCK_REALTIME) {
 		flags |= FLAGS_CLOCKRT;
-		if (cmd != FUTEX_WAIT && cmd != FUTEX_WAIT_BITSET && \
-		    cmd != FUTEX_WAIT_REQUEUE_PI)
+		if (cmd != FUTEX_WAIT_BITSET &&	cmd != FUTEX_WAIT_REQUEUE_PI)
 			return -ENOSYS;
 	}
 
