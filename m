Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD641221854
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 01:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGOXUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 19:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgGOXUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 19:20:13 -0400
Received: from lenoir.home (lfbn-ncy-1-317-216.w83-196.abo.wanadoo.fr [83.196.152.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ED7F20658;
        Wed, 15 Jul 2020 23:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594855212;
        bh=JESx7qOGoSMwajK8A+uKWD0Dl16XVysyJGtAAJzP2UU=;
        h=From:To:Cc:Subject:Date:From;
        b=g/k3idTIXDydfxSbSIz+xC7jq0czGH/kuT/yXF7YegNV9OXvgXbLH8iwB7w0a6Fez
         4eg6A+TauLBycBDv3DVWMGID847IfCQ2ZS5lasMWoXnxepj4HWAyxNr3cHmeqF2TT7
         Ecg/+BzsZCL1l7kjg6SNHWbhZzUeyf+zg4V35xek=
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>, stable@vger.kernel.org,
        Anna-Maria Behnsen <anna-maria@linutronix.de>
Subject: [PATCH] timer: Fix wheel index calculation on last level
Date:   Thu, 16 Jul 2020 01:20:06 +0200
Message-Id: <20200715232006.26791-1-frederic@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When an expiration delta falls into the last level of the wheel, we want
to compare that delta against the maximum possible delay and reduce our
delta to fit in if necessary.

However instead of comparing the delta against the maximum, we are
comparing the actual expiry against the maximum. Then instead of fixing
the delta to fit in, we set the maximum delta as the expiry value.

This can result in various undesired outcomes, the worst possible one
being a timer expiring 15 days ahead to fire immediately.

Fixes: 500462a9de65 ("timers: Switch to a non-cascading wheel")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 kernel/time/timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 9a838d38dbe6..df1ff803acc4 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -521,8 +521,8 @@ static int calc_wheel_index(unsigned long expires, unsigned long clk)
 		 * Force expire obscene large timeouts to expire at the
 		 * capacity limit of the wheel.
 		 */
-		if (expires >= WHEEL_TIMEOUT_CUTOFF)
-			expires = WHEEL_TIMEOUT_MAX;
+		if (delta >= WHEEL_TIMEOUT_CUTOFF)
+			expires = clk + WHEEL_TIMEOUT_MAX;
 
 		idx = calc_index(expires, LVL_DEPTH - 1);
 	}
-- 
2.26.2

