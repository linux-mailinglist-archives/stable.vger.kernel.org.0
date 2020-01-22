Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79FE71457AD
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 15:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgAVOWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 09:22:41 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39357 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgAVOWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 09:22:39 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so7455567wrt.6;
        Wed, 22 Jan 2020 06:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=esYJabAjEgQ+OJupE3wTIjAvn1sA/T0ZDbrjIrXhr+k=;
        b=RFA64HBbUjHV2WGXea+HfIKNhwiDb4fasmwxzaPEWlT+vjBhAM8FVXI3+LEVeWUKvJ
         q1Xy0N9hOSr1efO/HbT7XJeUFGosw7090YKpsDLS8ULmvKLRa33EYOoSO8NaRyiQVznU
         PXr+XkB6rZCP1FyIfM/FZ57CF7xC0fSXB5Tve1kOn9Z7A0LOMdQzvG9C0gsV2z3hoYex
         Vz0KS8qZIjMMj7D1LZx0x6KnStU/SqS4gSfdzu3CWy2xnsseSzzgGTf5CBr83PCdjybF
         9iwWTTK90hiZcIh77RWd9J8zZ2NuX2T/jH95KaLZJFr75jp7ki8RsI+uci9DBoWjQJrr
         03wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=esYJabAjEgQ+OJupE3wTIjAvn1sA/T0ZDbrjIrXhr+k=;
        b=t0ztN2Gp6U7xHV22F7XKnc3WkM25jyYVHsB1iBHI2b64idwS11oqvq1GnP/hueCqf0
         6t4CUfUqvRqju+WtIiu/+TieeF92Lqb57yOP35gq3lKhlQZPzsjhbj11fw2B7qUb+eBZ
         HQ8vyRz0pGEQ3GfffN6bppGRkReJDX0/4+YlHOjY4h7u8tuanYnjtbZ/z1sK6OA6DkUm
         WuZOADmekN1UPPnbtToVY9VIUIsuA0zTVBroA55O3FDmePTaV6t5x3QDmJ82CqogHKA2
         IuriqkqPyJDYKqs2i9FGrBMq4rqlKYEe84dE0YdWahhsRWCj7zPU9aNsSV0KmY+Yqtk2
         VZLA==
X-Gm-Message-State: APjAAAXLXBACtvYuNoehdyqCGEcVvFWtYV5ncnBWNSAoiQrkIfv94iB5
        1Co5l4+fjf6DTmZgnduRPDX5QPKw
X-Google-Smtp-Source: APXvYqzS3Ld2f5YX9vXRWxiASD+S6dfNkhQTU9CMja25hxOIQ2dZCWYWh/87OWuz7uMEg7TCSMu8og==
X-Received: by 2002:a5d:608a:: with SMTP id w10mr10943148wrt.136.1579702957407;
        Wed, 22 Jan 2020 06:22:37 -0800 (PST)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id x11sm4172282wmg.46.2020.01.22.06.22.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 06:22:36 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mtosatti@redhat.com, stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: reorganize pvclock_gtod_data members
Date:   Wed, 22 Jan 2020 15:22:32 +0100
Message-Id: <1579702953-24184-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579702953-24184-1-git-send-email-pbonzini@redhat.com>
References: <1579702953-24184-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We will need a copy of tk->offs_boot in the next patch.  Store it and
cleanup the struct: instead of storing tk->tkr_xxx.base with the tk->offs_boot
included, store the raw value in struct pvclock_clock and sum tk->offs_boot
in do_monotonic_raw and do_realtime.   tk->tkr_xxx.xtime_nsec also moves
to struct pvclock_clock.

While at it, fix a (usually harmless) typo in do_monotonic_raw, which
was using gtod->clock.shift instead of gtod->raw_clock.shift.

Fixes: 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw clock")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 89621025577a..1b4273cce63c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1532,6 +1532,8 @@ struct pvclock_clock {
 	u64 mask;
 	u32 mult;
 	u32 shift;
+	u64 base_cycles;
+	u64 offset;
 };
 
 struct pvclock_gtod_data {
@@ -1540,11 +1542,8 @@ struct pvclock_gtod_data {
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
@@ -1552,10 +1551,6 @@ struct pvclock_gtod_data {
 static void update_pvclock_gtod(struct timekeeper *tk)
 {
 	struct pvclock_gtod_data *vdata = &pvclock_gtod_data;
-	u64 boot_ns, boot_ns_raw;
-
-	boot_ns = ktime_to_ns(ktime_add(tk->tkr_mono.base, tk->offs_boot));
-	boot_ns_raw = ktime_to_ns(ktime_add(tk->tkr_raw.base, tk->offs_boot));
 
 	write_seqcount_begin(&vdata->seq);
 
@@ -1565,20 +1560,20 @@ static void update_pvclock_gtod(struct timekeeper *tk)
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
@@ -2048,10 +2043,10 @@ static int do_monotonic_raw(s64 *t, u64 *tsc_timestamp)
 
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
 
@@ -2068,7 +2063,7 @@ static int do_realtime(struct timespec64 *ts, u64 *tsc_timestamp)
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
 		ts->tv_sec = gtod->wall_time_sec;
-		ns = gtod->nsec_base;
+		ns = gtod->clock.base_cycles;
 		ns += vgettsc(&gtod->clock, tsc_timestamp, &mode);
 		ns >>= gtod->clock.shift;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-- 
1.8.3.1


