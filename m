Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8137E5BE7
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfJZN0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbfJZNVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:21:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40FE820867;
        Sat, 26 Oct 2019 13:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096109;
        bh=S1JkXx2xG+K1cof7ctG8SEgGR9X0WxecjSeAqIOsE38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qagUN+j37J34p+W+F6mb1n+hzZ+92991EylQ74JyrfhiaDft4Kk10OPR4vedJo3nq
         Mpux9i5fSy9mKPIL3loCsV41F7Q7qdFz9wiapnLX4kgDVnmYQerwEriLFLYjlUUk0q
         tiTEepYDPwKwOHoEghYGdfixMp77Vn3ZLDxX0el0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 21/33] hrtimer: Annotate lockless access to timer->base
Date:   Sat, 26 Oct 2019 09:20:58 -0400
Message-Id: <20191026132110.4026-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132110.4026-1-sashal@kernel.org>
References: <20191026132110.4026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ff229eee3d897f52bd001c841f2d3cce8853ecdc ]

Followup to commit dd2261ed45aa ("hrtimer: Protect lockless access
to timer->base")

lock_hrtimer_base() fetches timer->base without lock exclusion.

Compiler is allowed to read timer->base twice (even if considered dumb)
which could end up trying to lock migration_base and return
&migration_base.

  base = timer->base;
  if (likely(base != &migration_base)) {

       /* compiler reads timer->base again, and now (base == &migration_base)

       raw_spin_lock_irqsave(&base->cpu_base->lock, *flags);
       if (likely(base == timer->base))
            return base; /* == &migration_base ! */

Similarly the write sides must use WRITE_ONCE() to avoid store tearing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191008173204.180879-1-edumazet@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index d00e85ac10d66..e7ef0d830c093 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -143,7 +143,7 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
 	struct hrtimer_clock_base *base;
 
 	for (;;) {
-		base = timer->base;
+		base = READ_ONCE(timer->base);
 		if (likely(base != &migration_base)) {
 			raw_spin_lock_irqsave(&base->cpu_base->lock, *flags);
 			if (likely(base == timer->base))
@@ -235,7 +235,7 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 			return base;
 
 		/* See the comment in lock_hrtimer_base() */
-		timer->base = &migration_base;
+		WRITE_ONCE(timer->base, &migration_base);
 		raw_spin_unlock(&base->cpu_base->lock);
 		raw_spin_lock(&new_base->cpu_base->lock);
 
@@ -244,10 +244,10 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 			raw_spin_unlock(&new_base->cpu_base->lock);
 			raw_spin_lock(&base->cpu_base->lock);
 			new_cpu_base = this_cpu_base;
-			timer->base = base;
+			WRITE_ONCE(timer->base, base);
 			goto again;
 		}
-		timer->base = new_base;
+		WRITE_ONCE(timer->base, new_base);
 	} else {
 		if (new_cpu_base != this_cpu_base &&
 		    hrtimer_check_target(timer, new_base)) {
-- 
2.20.1

