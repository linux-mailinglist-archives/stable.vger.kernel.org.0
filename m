Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D47408DBC
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240575AbhIMN26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241374AbhIMN0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:26:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BA1960FA0;
        Mon, 13 Sep 2021 13:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539380;
        bh=xYUUG1GYepWWzLoXPYBfuiP6JRYKZibY1PSpA4aIk7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sf7d39JzQLFepS1YNAYwBE130QXWTxPeZWVXLSWiSciCS1JgfdDMl+toawslD+rAA
         aih9OC7w71PCR7YJU3ESwk2pEcz+ZHBfk74/bLTeW9DG0U8uz+l2ssiRAhifqtDy3W
         NcQsS7jydMT1wTsjuXrc4wVrNqSCEhy7H2kZRn3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 131/144] time: Handle negative seconds correctly in timespec64_to_ns()
Date:   Mon, 13 Sep 2021 15:15:12 +0200
Message-Id: <20210913131052.308441540@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>

commit 39ff83f2f6cc5cc1458dfcea9697f96338210beb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/time64.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -33,7 +33,9 @@ struct itimerspec64 {
 #define TIME64_MIN			(-TIME64_MAX - 1)
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
+#define KTIME_MIN			(-KTIME_MAX - 1)
 #define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#define KTIME_SEC_MIN			(KTIME_MIN / NSEC_PER_SEC)
 
 /*
  * Limits for settimeofday():
@@ -132,10 +134,13 @@ static inline bool timespec64_valid_sett
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
 


