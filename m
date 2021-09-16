Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C2B40D8FB
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 13:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhIPLpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 07:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235695AbhIPLpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 07:45:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2937B60F3A;
        Thu, 16 Sep 2021 11:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631792650;
        bh=1rAt9EUpNEzwS7FQYi6wdFC03sMC9tb7D//On5iYqxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+NXZFwnXvoNeLnkcYMvyIBh0WTC4UQQCTX0nVoUP045+QbJfGFERAbQXbzZ2WCuz
         T3XOVn7rBCMPdpdrzHFgOlb9db9vMjHRMsMMnXk8AXDGuFqsicZw3jo2YLpl1qXa+V
         u5x/yWCDAww9tl+YEMc+ErMyLe1XPdANzAchu16A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.13.18
Date:   Thu, 16 Sep 2021 13:43:59 +0200
Message-Id: <16317926168992@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <163179261684117@kroah.com>
References: <163179261684117@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index c79a2c70a22b..ddbd64b92a72 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 13
-SUBLEVEL = 17
+SUBLEVEL = 18
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/include/linux/time64.h b/include/linux/time64.h
index 81b9686a2079..5117cb5b5656 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -25,9 +25,7 @@ struct itimerspec64 {
 #define TIME64_MIN			(-TIME64_MAX - 1)
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
-#define KTIME_MIN			(-KTIME_MAX - 1)
 #define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
-#define KTIME_SEC_MIN			(KTIME_MIN / NSEC_PER_SEC)
 
 /*
  * Limits for settimeofday():
@@ -126,13 +124,10 @@ static inline bool timespec64_valid_settod(const struct timespec64 *ts)
  */
 static inline s64 timespec64_to_ns(const struct timespec64 *ts)
 {
-	/* Prevent multiplication overflow / underflow */
-	if (ts->tv_sec >= KTIME_SEC_MAX)
+	/* Prevent multiplication overflow */
+	if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
 		return KTIME_MAX;
 
-	if (ts->tv_sec <= KTIME_SEC_MIN)
-		return KTIME_MIN;
-
 	return ((s64) ts->tv_sec * NSEC_PER_SEC) + ts->tv_nsec;
 }
 
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index a9f8d25220b1..aa52fc85dbcb 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1346,6 +1346,8 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clkid,
 			}
 		}
 
+		if (!*newval)
+			return;
 		*newval += now;
 	}
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index bf1bb08b94aa..8d455c232154 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1740,14 +1740,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	hci_request_cancel_all(hdev);
 	hci_req_sync_lock(hdev);
 
-	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-	    test_bit(HCI_UP, &hdev->flags)) {
-		/* Execute vendor specific shutdown routine */
-		if (hdev->shutdown)
-			hdev->shutdown(hdev);
-	}
-
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
 		hci_req_sync_unlock(hdev);
