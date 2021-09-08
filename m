Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995A7403CD8
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 17:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349666AbhIHPvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 11:51:14 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52988 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349660AbhIHPvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 11:51:13 -0400
Date:   Wed, 08 Sep 2021 15:50:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631116204;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7t9TbDcVf8dPQh6cAvl+s+/BeeyFeZw4VocU+Hrytok=;
        b=pUK76Wrv3r5p30GnB1ROuGZl47ydMAnfCOttM2yvrI6EGTJT08kWMHq81yucfCeU6q4Kit
        1hGvrkpidqlpihysHoWtS4Cceyl+teKtM2kALO6dgKHGyrDjLE9iRTjv78dmjjAl67HLAY
        3mKp6nBT4tYTiy7BpUBjAIe2okmcYNRggLOwZib0lqcSiZtuYAihuSahj6dzXVUe0+CbAf
        3T6QDCLQnk2ZfVdoZDOT18Ul2KzV2EQjqgvEah9z8kmqHCsZFAdnMcTvVzsNKCIWtvAsC7
        xTLP3YEvGdzv3aFM7cCqBLNQB7zT8Mg9F4BNFsq4zAL99tZ3MgplLq+DVR66/Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631116204;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7t9TbDcVf8dPQh6cAvl+s+/BeeyFeZw4VocU+Hrytok=;
        b=rXralnTHJaVQBiP89xLwqLqqs3hRVD/S3BDl2M8fGBZ7HauR3iTq9nsmSAreMD67L+NCqC
        Spzxkg1pNCmQwBCg==
From:   "tip-bot2 for Lukas Hannen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] time: Handle negative seconds correctly in
 timespec64_to_ns()
Cc:     Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3CAM6PR01MB541637BD6F336B8FFB72AF80EEC69=40AM6PR01MB?=
 =?utf-8?q?5416=2Eeurprd01=2Eprod=2Eexchangelabs=2Ecom=3E?=
References: =?utf-8?q?=3CAM6PR01MB541637BD6F336B8FFB72AF80EEC69=40AM6PR01M?=
 =?utf-8?q?B5416=2Eeurprd01=2Eprod=2Eexchangelabs=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <163111620295.25758.18154572095175068828.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     39ff83f2f6cc5cc1458dfcea9697f96338210beb
Gitweb:        https://git.kernel.org/tip/39ff83f2f6cc5cc1458dfcea9697f96338210beb
Author:        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
AuthorDate:    Wed, 25 Aug 2021 10:12:43 
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 08 Sep 2021 17:44:26 +02:00

time: Handle negative seconds correctly in timespec64_to_ns()

timespec64_ns() prevents multiplication overflows by comparing the seconds
value of the timespec to KTIME_SEC_MAX. If the value is greater or equal it
returns KTIME_MAX.

But that check casts the signed seconds value to unsigned which makes the
comparision true for all negative values and therefore return wrongly
KTIME_MAX.

Negative second values are perfectly valid and required in some places,
e.g. ptp_clock_adjtime().

Remove the cast and add a check for the negative boundary which is required
to prevent undefined behaviour due to multiplication underflow.

Fixes: cb47755725da ("time: Prevent undefined behaviour in timespec64_to_ns()")'
Signed-off-by: Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/AM6PR01MB541637BD6F336B8FFB72AF80EEC69@AM6PR01MB5416.eurprd01.prod.exchangelabs.com
---
 include/linux/time64.h |  9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/time64.h b/include/linux/time64.h
index 5117cb5..81b9686 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -25,7 +25,9 @@ struct itimerspec64 {
 #define TIME64_MIN			(-TIME64_MAX - 1)
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
+#define KTIME_MIN			(-KTIME_MAX - 1)
 #define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#define KTIME_SEC_MIN			(KTIME_MIN / NSEC_PER_SEC)
 
 /*
  * Limits for settimeofday():
@@ -124,10 +126,13 @@ static inline bool timespec64_valid_settod(const struct timespec64 *ts)
  */
 static inline s64 timespec64_to_ns(const struct timespec64 *ts)
 {
-	/* Prevent multiplication overflow */
-	if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
+	/* Prevent multiplication overflow / underflow */
+	if (ts->tv_sec >= KTIME_SEC_MAX)
 		return KTIME_MAX;
 
+	if (ts->tv_sec <= KTIME_SEC_MIN)
+		return KTIME_MIN;
+
 	return ((s64) ts->tv_sec * NSEC_PER_SEC) + ts->tv_nsec;
 }
 
