Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E1240D903
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 13:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238203AbhIPLq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 07:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237952AbhIPLq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 07:46:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A91C560F3A;
        Thu, 16 Sep 2021 11:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631792707;
        bh=AJ1KkjnvIE+QcVe8giadY2v9LfVNqivpphrKWxtOCnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTbMlY1PIzEPqsf1ldf7QdzysqvgTUXvKc9nxPHvNHWJuB0ekHhHebu6SBa5mJffF
         iUhsKq9Oip5/bdQnUz7zH7edRF1vEs34y1CowPCcHQf4pghRdJ0KuKupLKQYg30s5W
         7dHrBZ2b5zfurxrmG+FMI5BSX+bkolRUWmcW3Ki4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.147
Date:   Thu, 16 Sep 2021 13:44:56 +0200
Message-Id: <163179268620542@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <16317926868288@kroah.com>
References: <16317926868288@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 48d0c03acfc5..98227dae3494 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 146
+SUBLEVEL = 147
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index bc3ab98855cf..25e81b1a59a5 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1744,17 +1744,7 @@ static int nbd_dev_add(int index)
 	refcount_set(&nbd->refs, 1);
 	INIT_LIST_HEAD(&nbd->list);
 	disk->major = NBD_MAJOR;
-
-	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since first_minor will be truncated to
-	 * byte in __device_add_disk().
-	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor > 0xff) {
-		err = -EINVAL;
-		goto out_free_idr;
-	}
-
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
 	sprintf(disk->disk_name, "nbd%d", index);
diff --git a/include/linux/time64.h b/include/linux/time64.h
index f6059c505986..5eab3f263518 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -33,9 +33,7 @@ struct itimerspec64 {
 #define TIME64_MIN			(-TIME64_MAX - 1)
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
-#define KTIME_MIN			(-KTIME_MAX - 1)
 #define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
-#define KTIME_SEC_MIN			(KTIME_MIN / NSEC_PER_SEC)
 
 /*
  * Limits for settimeofday():
@@ -134,13 +132,10 @@ static inline bool timespec64_valid_settod(const struct timespec64 *ts)
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
index 30e061b210b7..eacb0ca30193 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1201,6 +1201,8 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clkid,
 			}
 		}
 
+		if (!*newval)
+			return;
 		*newval += now;
 	}
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index bdd330527cfa..c50e3e8afbd3 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1691,14 +1691,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
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
