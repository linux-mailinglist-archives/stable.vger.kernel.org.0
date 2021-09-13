Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BFE409004
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243330AbhIMNs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243749AbhIMNqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03B516137E;
        Mon, 13 Sep 2021 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539928;
        bh=qVu/R1PERx92QevYEvJMZewyoqWI0tU6zqzoEYAu/xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y67IXkT5dz8YhD5nGfYn8Jz7z3xB6LIujerjgm9K2fsp/g4KP/FQe+4KDiBwe5TGw
         4jCHKejsKcdpZnc44qP9IjH2+ksf893qZsOHD7VL5VSNBIeEXi1loa+4/Pl+PDIaH7
         NsolaZ21RsaAWYhMf7YXqY6D3G1pExo6t11/XHmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 218/236] time: Handle negative seconds correctly in timespec64_to_ns()
Date:   Mon, 13 Sep 2021 15:15:23 +0200
Message-Id: <20210913131107.782810696@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
@@ -25,7 +25,9 @@ struct itimerspec64 {
 #define TIME64_MIN			(-TIME64_MAX - 1)
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
+#define KTIME_MIN			(-KTIME_MAX - 1)
 #define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#define KTIME_SEC_MIN			(KTIME_MIN / NSEC_PER_SEC)
 
 /*
  * Limits for settimeofday():
@@ -124,10 +126,13 @@ static inline bool timespec64_valid_sett
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
 


