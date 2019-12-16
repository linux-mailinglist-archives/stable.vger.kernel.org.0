Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB227121521
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbfLPSSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:18:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731843AbfLPSSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:18:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C510206EC;
        Mon, 16 Dec 2019 18:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520322;
        bh=FiJY5Cv5GJiKEqH6L/TS6/VaGfBO6OmzHNkEvcQgrLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgmmIkkBM8lvAhBNAeFUZCn3B/0+Do6rlE2EEk5wXP4WVM33w/QnhoxJX7k6qWkTU
         WvTWMXDNXtcEmon7DD4vygsQwMadFKxoKm4tnxzWhOPZnxdzqAC9pI55kg8o6XX1CU
         SOMfhSKM2Zfd4J/epZq3TnsrGKNhqzbLL8qPcQv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 107/177] cpuidle: teo: Consider hits and misses metrics of disabled states
Date:   Mon, 16 Dec 2019 18:49:23 +0100
Message-Id: <20191216174841.665051580@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e43dcf20215f0287ea113102617ca04daa76b70e upstream.

The TEO governor uses idle duration "bins" defined in accordance with
the CPU idle states table provided by the driver, so that each "bin"
covers the idle duration range between the target residency of the
idle state corresponding to it and the target residency of the closest
deeper idle state.  The governor collects statistics for each bin
regardless of whether or not the idle state corresponding to it is
currently enabled.

In particular, the "hits" and "misses" metrics measure the likelihood
of a situation in which both the time till the next timer (sleep
length) and the idle duration measured after wakeup fall into the
given bin.  Namely, if the "hits" value is greater than the "misses"
one, that situation is more likely than the one in which the sleep
length falls into the given bin, but the idle duration measured after
wakeup falls into a bin corresponding to one of the shallower idle
states.

If the idle state corresponding to the given bin is disabled, it
cannot be selected and if it turns out to be the one that should be
selected, a shallower idle state needs to be used instead of it.
Nevertheless, the metrics collected for the bin corresponding to it
are still valid and need to be taken into account as though that
state had not been disabled.

For this reason, make teo_select() always use the "hits" and "misses"
values of the idle duration range that the sleep length falls into
even if the specific idle state corresponding to it is disabled and
if the "hits" values is greater than the "misses" one, select the
closest enabled shallower idle state in that case.

Fixes: b26bf6ab716f ("cpuidle: New timer events oriented governor for tickless systems")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpuidle/governors/teo.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -233,7 +233,7 @@ static int teo_select(struct cpuidle_dri
 {
 	struct teo_cpu *cpu_data = per_cpu_ptr(&teo_cpus, dev->cpu);
 	int latency_req = cpuidle_governor_latency_req(dev->cpu);
-	unsigned int duration_us, early_hits;
+	unsigned int duration_us, hits, misses, early_hits;
 	int max_early_idx, constraint_idx, idx, i;
 	ktime_t delta_tick;
 
@@ -247,6 +247,8 @@ static int teo_select(struct cpuidle_dri
 	cpu_data->sleep_length_ns = tick_nohz_get_sleep_length(&delta_tick);
 	duration_us = ktime_to_us(cpu_data->sleep_length_ns);
 
+	hits = 0;
+	misses = 0;
 	early_hits = 0;
 	max_early_idx = -1;
 	constraint_idx = drv->state_count;
@@ -265,6 +267,17 @@ static int teo_select(struct cpuidle_dri
 				continue;
 
 			/*
+			 * This state is disabled, so the range of idle duration
+			 * values corresponding to it is covered by the current
+			 * candidate state, but still the "hits" and "misses"
+			 * metrics of the disabled state need to be used to
+			 * decide whether or not the state covering the range in
+			 * question is good enough.
+			 */
+			hits = cpu_data->states[i].hits;
+			misses = cpu_data->states[i].misses;
+
+			/*
 			 * If the "early hits" metric of a disabled state is
 			 * greater than the current maximum, it should be taken
 			 * into account, because it would be a mistake to select
@@ -280,8 +293,11 @@ static int teo_select(struct cpuidle_dri
 			continue;
 		}
 
-		if (idx < 0)
+		if (idx < 0) {
 			idx = i; /* first enabled state */
+			hits = cpu_data->states[i].hits;
+			misses = cpu_data->states[i].misses;
+		}
 
 		if (s->target_residency > duration_us)
 			break;
@@ -290,6 +306,8 @@ static int teo_select(struct cpuidle_dri
 			constraint_idx = i;
 
 		idx = i;
+		hits = cpu_data->states[i].hits;
+		misses = cpu_data->states[i].misses;
 
 		if (early_hits < cpu_data->states[i].early_hits &&
 		    !(tick_nohz_tick_stopped() &&
@@ -307,8 +325,7 @@ static int teo_select(struct cpuidle_dri
 	 * "early hits" metric, but if that cannot be determined, just use the
 	 * state selected so far.
 	 */
-	if (cpu_data->states[idx].hits <= cpu_data->states[idx].misses &&
-	    max_early_idx >= 0) {
+	if (hits <= misses && max_early_idx >= 0) {
 		idx = max_early_idx;
 		duration_us = drv->states[idx].target_residency;
 	}


