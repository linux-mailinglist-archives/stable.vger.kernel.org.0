Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D01157721
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgBJM56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:57:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgBJMlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:22 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F376924650;
        Mon, 10 Feb 2020 12:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338482;
        bh=4Zw4f/er2pIM3aDRMBtI8BCjliq6iN6qQXfBIQhwjUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fn1Tqxvdrt8/+3ReSM93UwCzZOPVwGbUGT3AwmWnLv2CAMk11Esb+RVnETE8aej5G
         S7IaPc1GIFID/Bh2xznj7lf/WbWhlXpCZt/KIiE8ixl7csqjAa9DadoLKbqzFM/I+T
         Cl0H7B0ouh7zS3mjN5YgGHEpJjehcJAnkMvhOAAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 259/367] KVM: x86: reorganize pvclock_gtod_data members
Date:   Mon, 10 Feb 2020 04:32:52 -0800
Message-Id: <20200210122448.554018214@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 917f9475c0a8ab8958db7f22a5d495b9a1d51be6 upstream.

We will need a copy of tk->offs_boot in the next patch.  Store it and
cleanup the struct: instead of storing tk->tkr_xxx.base with the tk->offs_boot
included, store the raw value in struct pvclock_clock and sum it in
do_monotonic_raw and do_realtime.   tk->tkr_xxx.xtime_nsec also moves
to struct pvclock_clock.

While at it, fix a (usually harmless) typo in do_monotonic_raw, which
was using gtod->clock.shift instead of gtod->raw_clock.shift.

Fixes: 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw clock")
Cc: stable@vger.kernel.org
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1580,6 +1580,8 @@ struct pvclock_clock {
 	u64 mask;
 	u32 mult;
 	u32 shift;
+	u64 base_cycles;
+	u64 offset;
 };
 
 struct pvclock_gtod_data {
@@ -1588,11 +1590,8 @@ struct pvclock_gtod_data {
 	struct pvclock_clock clock; /* extract of a clocksource struct */
 	struct pvclock_clock raw_clock; /* extract of a clocksource struct */
 
-	u64		boot_ns_raw;
-	u64		boot_ns;
-	u64		nsec_base;
+	ktime_t		offs_boot;
 	u64		wall_time_sec;
-	u64		monotonic_raw_nsec;
 };
 
 static struct pvclock_gtod_data pvclock_gtod_data;
@@ -1600,10 +1599,6 @@ static struct pvclock_gtod_data pvclock_
 static void update_pvclock_gtod(struct timekeeper *tk)
 {
 	struct pvclock_gtod_data *vdata = &pvclock_gtod_data;
-	u64 boot_ns, boot_ns_raw;
-
-	boot_ns = ktime_to_ns(ktime_add(tk->tkr_mono.base, tk->offs_boot));
-	boot_ns_raw = ktime_to_ns(ktime_add(tk->tkr_raw.base, tk->offs_boot));
 
 	write_seqcount_begin(&vdata->seq);
 
@@ -1613,20 +1608,20 @@ static void update_pvclock_gtod(struct t
 	vdata->clock.mask		= tk->tkr_mono.mask;
 	vdata->clock.mult		= tk->tkr_mono.mult;
 	vdata->clock.shift		= tk->tkr_mono.shift;
+	vdata->clock.base_cycles	= tk->tkr_mono.xtime_nsec;
+	vdata->clock.offset		= tk->tkr_mono.base;
 
 	vdata->raw_clock.vclock_mode	= tk->tkr_raw.clock->archdata.vclock_mode;
 	vdata->raw_clock.cycle_last	= tk->tkr_raw.cycle_last;
 	vdata->raw_clock.mask		= tk->tkr_raw.mask;
 	vdata->raw_clock.mult		= tk->tkr_raw.mult;
 	vdata->raw_clock.shift		= tk->tkr_raw.shift;
-
-	vdata->boot_ns			= boot_ns;
-	vdata->nsec_base		= tk->tkr_mono.xtime_nsec;
+	vdata->raw_clock.base_cycles	= tk->tkr_raw.xtime_nsec;
+	vdata->raw_clock.offset		= tk->tkr_raw.base;
 
 	vdata->wall_time_sec            = tk->xtime_sec;
 
-	vdata->boot_ns_raw		= boot_ns_raw;
-	vdata->monotonic_raw_nsec	= tk->tkr_raw.xtime_nsec;
+	vdata->offs_boot		= tk->offs_boot;
 
 	write_seqcount_end(&vdata->seq);
 }
@@ -2096,10 +2091,10 @@ static int do_monotonic_raw(s64 *t, u64
 
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
-		ns = gtod->monotonic_raw_nsec;
+		ns = gtod->raw_clock.base_cycles;
 		ns += vgettsc(&gtod->raw_clock, tsc_timestamp, &mode);
-		ns >>= gtod->clock.shift;
-		ns += gtod->boot_ns_raw;
+		ns >>= gtod->raw_clock.shift;
+		ns += ktime_to_ns(ktime_add(gtod->raw_clock.offset, gtod->offs_boot));
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 	*t = ns;
 
@@ -2116,7 +2111,7 @@ static int do_realtime(struct timespec64
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
 		ts->tv_sec = gtod->wall_time_sec;
-		ns = gtod->nsec_base;
+		ns = gtod->clock.base_cycles;
 		ns += vgettsc(&gtod->clock, tsc_timestamp, &mode);
 		ns >>= gtod->clock.shift;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));


