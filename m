Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C1E1216CD
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfLPScB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:32:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730660AbfLPSKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:10:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B471206B7;
        Mon, 16 Dec 2019 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519847;
        bh=zvMDwGEEflLv0ci+1PJN1E1X3hZPcRLx42HGE3CfK80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6VcmqrQuWSa0D5GFrzWk5Mg/313Fkz84X7TnbAHO23XBgvgVvr7b3QM+NWdgIQmR
         iDxd07uoKTryaeNfwq/AnSZyaaIGKMz2lyMM2Gx/QCvIlXyR3ik8hSDRJryYSQ9xdd
         crC9PO+EuFP3l78Zb/nWTbn0BHWqJSB5Eq4OwBuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.3 093/180] cpuidle: teo: Fix "early hits" handling for disabled idle states
Date:   Mon, 16 Dec 2019 18:48:53 +0100
Message-Id: <20191216174834.905902973@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 159e48560f51d9c2aa02d762a18cd24f7868ab27 upstream.

The TEO governor uses idle duration "bins" defined in accordance with
the CPU idle states table provided by the driver, so that each "bin"
covers the idle duration range between the target residency of the
idle state corresponding to it and the target residency of the closest
deeper idle state.  The governor collects statistics for each bin
regardless of whether or not the idle state corresponding to it is
currently enabled.

In particular, the "early hits" metric measures the likelihood of a
situation in which the idle duration measured after wakeup falls into
to given bin, but the time till the next timer (sleep length) falls
into a bin corresponding to one of the deeper idle states.  It is
used when the "hits" and "misses" metrics indicate that the state
"matching" the sleep length should not be selected, so that the state
with the maximum "early hits" value is selected instead of it.

If the idle state corresponding to the given bin is disabled, it
cannot be selected and if it turns out to be the one that should be
selected, a shallower idle state needs to be used instead of it.
Nevertheless, the metrics collected for the bin corresponding to it
are still valid and need to be taken into account as though that
state had not been disabled.

As far as the "early hits" metric is concerned, teo_select() tries to
take disabled states into account, but the state index corresponding
to the maximum "early hits" value computed by it may be incorrect.
Namely, it always uses the index of the previous maximum "early hits"
state then, but there may be enabled idle states closer to the
disabled one in question.  In particular, if the current candidate
state (whose index is the idx value) is closer to the disabled one
and the "early hits" value of the disabled state is greater than the
current maximum, the index of the current candidate state (idx)
should replace the "maximum early hits state" index.

Modify the code to handle that case correctly.

Fixes: b26bf6ab716f ("cpuidle: New timer events oriented governor for tickless systems")
Reported-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpuidle/governors/teo.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -285,18 +285,35 @@ static int teo_select(struct cpuidle_dri
 			hits = cpu_data->states[i].hits;
 			misses = cpu_data->states[i].misses;
 
+			if (early_hits >= cpu_data->states[i].early_hits ||
+			    idx < 0)
+				continue;
+
+			/*
+			 * If the current candidate state has been the one with
+			 * the maximum "early hits" metric so far, the "early
+			 * hits" metric of the disabled state replaces the
+			 * current "early hits" count to avoid selecting a
+			 * deeper state with lower "early hits" metric.
+			 */
+			if (max_early_idx == idx) {
+				early_hits = cpu_data->states[i].early_hits;
+				continue;
+			}
+
 			/*
-			 * If the "early hits" metric of a disabled state is
-			 * greater than the current maximum, it should be taken
-			 * into account, because it would be a mistake to select
-			 * a deeper state with lower "early hits" metric.  The
-			 * index cannot be changed to point to it, however, so
-			 * just increase the "early hits" count alone and let
-			 * the index still point to a shallower idle state.
+			 * The current candidate state is closer to the disabled
+			 * one than the current maximum "early hits" state, so
+			 * replace the latter with it, but in case the maximum
+			 * "early hits" state index has not been set so far,
+			 * check if the current candidate state is not too
+			 * shallow for that role.
 			 */
-			if (max_early_idx >= 0 &&
-			    early_hits < cpu_data->states[i].early_hits)
+			if (!(tick_nohz_tick_stopped() &&
+			      drv->states[idx].target_residency < TICK_USEC)) {
 				early_hits = cpu_data->states[i].early_hits;
+				max_early_idx = idx;
+			}
 
 			continue;
 		}


