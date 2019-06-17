Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1953493B2
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbfFQV1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730321AbfFQV1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:27:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E0B2063F;
        Mon, 17 Jun 2019 21:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806819;
        bh=M/rcdrZOVTgevo80xjki8A9zgi3bMp31xcytSsn0PPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0Dfb16VTdQV2xgRs3855KEs3bwe5Tcg5PiC6S/205MnTq5EW1Frru65ZdG8giTgh
         ifZUzWqumCf9GX4cNG6udJf3immcB6kfNBpt1O1sLcb13iJ+UAgmxHrevZ23TUCH7C
         LUwbcCOtO7NVhFzhrOlnyGhWVSuFJ2BpxThzsHOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH 4.19 66/75] timekeeping: Repair ktime_get_coarse*() granularity
Date:   Mon, 17 Jun 2019 23:10:17 +0200
Message-Id: <20190617210755.665716408@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit e3ff9c3678b4d80e22d2557b68726174578eaf52 upstream.

Jason reported that the coarse ktime based time getters advance only once
per second and not once per tick as advertised.

The code reads only the monotonic base time, which advances once per
second. The nanoseconds are accumulated on every tick in xtime_nsec up to
a second and the regular time getters take this nanoseconds offset into
account, but the ktime_get_coarse*() implementation fails to do so.

Add the accumulated xtime_nsec value to the monotonic base time to get the
proper per tick advancing coarse tinme.

Fixes: b9ff604cff11 ("timekeeping: Add ktime_get_coarse_with_offset")
Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1906132136280.1791@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timekeeping.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -812,17 +812,18 @@ ktime_t ktime_get_coarse_with_offset(enu
 	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned int seq;
 	ktime_t base, *offset = offsets[offs];
+	u64 nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 		base = ktime_add(tk->tkr_mono.base, *offset);
+		nsecs = tk->tkr_mono.xtime_nsec >> tk->tkr_mono.shift;
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	return base;
-
+	return base + nsecs;
 }
 EXPORT_SYMBOL_GPL(ktime_get_coarse_with_offset);
 


