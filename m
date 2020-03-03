Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801DF177F6F
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbgCCRuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:50:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731565AbgCCRup (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:50:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9BD2214D8;
        Tue,  3 Mar 2020 17:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257844;
        bh=mwvdgSaAumLLSTH4CcBe04nOPmVj/nufXabgBS1mi6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/7tfABG36EJEapjjFk9+LG7qwkVdaBm7ZvgnHCtE1WwS6PYpmojXCOicPhW2lP+X
         B+Gg+0VuBRbFPcd6J6KmxQLWsZ5kyXPi49Mxpkk4JMek5/5FfnZtA5iWKxUdakaP1n
         r3O/cwLgNSDWGc8nPBkNqN33RkTFdh+v22ZPBsBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.5 151/176] lib/vdso: Update coarse timekeeper unconditionally
Date:   Tue,  3 Mar 2020 18:43:35 +0100
Message-Id: <20200303174322.100950388@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 9f24c540f7f8eb3a981528da9a9a636a5bdf5987 upstream.

The low resolution parts of the VDSO, i.e.:

  clock_gettime(CLOCK_*_COARSE), clock_getres(), time()

can be used even if there is no VDSO capable clocksource.

But if an architecture opts out of the VDSO data update then this
information becomes stale. This affects ARM when there is no architected
timer available. The lack of update causes userspace to use stale data
forever.

Make the update of the low resolution parts unconditional and only skip
the update of the high resolution parts if the architecture requests it.

Fixes: 44f57d788e7d ("timekeeping: Provide a generic update_vsyscall() implementation")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200114185946.765577901@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/vsyscall.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/kernel/time/vsyscall.c
+++ b/kernel/time/vsyscall.c
@@ -28,11 +28,6 @@ static inline void update_vdso_data(stru
 	vdata[CS_RAW].mult			= tk->tkr_raw.mult;
 	vdata[CS_RAW].shift			= tk->tkr_raw.shift;
 
-	/* CLOCK_REALTIME */
-	vdso_ts		= &vdata[CS_HRES_COARSE].basetime[CLOCK_REALTIME];
-	vdso_ts->sec	= tk->xtime_sec;
-	vdso_ts->nsec	= tk->tkr_mono.xtime_nsec;
-
 	/* CLOCK_MONOTONIC */
 	vdso_ts		= &vdata[CS_HRES_COARSE].basetime[CLOCK_MONOTONIC];
 	vdso_ts->sec	= tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
@@ -70,12 +65,6 @@ static inline void update_vdso_data(stru
 	vdso_ts		= &vdata[CS_HRES_COARSE].basetime[CLOCK_TAI];
 	vdso_ts->sec	= tk->xtime_sec + (s64)tk->tai_offset;
 	vdso_ts->nsec	= tk->tkr_mono.xtime_nsec;
-
-	/*
-	 * Read without the seqlock held by clock_getres().
-	 * Note: No need to have a second copy.
-	 */
-	WRITE_ONCE(vdata[CS_HRES_COARSE].hrtimer_res, hrtimer_resolution);
 }
 
 void update_vsyscall(struct timekeeper *tk)
@@ -84,20 +73,17 @@ void update_vsyscall(struct timekeeper *
 	struct vdso_timestamp *vdso_ts;
 	u64 nsec;
 
-	if (!__arch_update_vdso_data()) {
-		/*
-		 * Some architectures might want to skip the update of the
-		 * data page.
-		 */
-		return;
-	}
-
 	/* copy vsyscall data */
 	vdso_write_begin(vdata);
 
 	vdata[CS_HRES_COARSE].clock_mode	= __arch_get_clock_mode(tk);
 	vdata[CS_RAW].clock_mode		= __arch_get_clock_mode(tk);
 
+	/* CLOCK_REALTIME also required for time() */
+	vdso_ts		= &vdata[CS_HRES_COARSE].basetime[CLOCK_REALTIME];
+	vdso_ts->sec	= tk->xtime_sec;
+	vdso_ts->nsec	= tk->tkr_mono.xtime_nsec;
+
 	/* CLOCK_REALTIME_COARSE */
 	vdso_ts		= &vdata[CS_HRES_COARSE].basetime[CLOCK_REALTIME_COARSE];
 	vdso_ts->sec	= tk->xtime_sec;
@@ -110,7 +96,18 @@ void update_vsyscall(struct timekeeper *
 	nsec		= nsec + tk->wall_to_monotonic.tv_nsec;
 	vdso_ts->sec	+= __iter_div_u64_rem(nsec, NSEC_PER_SEC, &vdso_ts->nsec);
 
-	update_vdso_data(vdata, tk);
+	/*
+	 * Read without the seqlock held by clock_getres().
+	 * Note: No need to have a second copy.
+	 */
+	WRITE_ONCE(vdata[CS_HRES_COARSE].hrtimer_res, hrtimer_resolution);
+
+	/*
+	 * Architectures can opt out of updating the high resolution part
+	 * of the VDSO.
+	 */
+	if (__arch_update_vdso_data())
+		update_vdso_data(vdata, tk);
 
 	__arch_update_vsyscall(vdata, tk);
 


