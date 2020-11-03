Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F892A5350
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733142AbgKCU7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbgKCU7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A53A42053B;
        Tue,  3 Nov 2020 20:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437188;
        bh=6kclw7NjpySyc7uw7GBrdqMgAv3hQb9hE1Q/lAP1phI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGou7ksd8s1dx4jRmUmuUKk/I0e4Y3+fz3oKgWzXZkLp8rkGcRSQolNUTVUkkFN98
         dhA7ujVBafQfzNDZ++qAuCf49bEOjkwdbKyMWeB6pi8VfR7jgIt38pn1UJa+6hDBvp
         SuuOt/hdia/AzkNIvYqX3TS6auPl5q3ANTarALQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 157/214] s390/stp: add locking to sysfs functions
Date:   Tue,  3 Nov 2020 21:36:45 +0100
Message-Id: <20201103203305.506428725@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit b3bd02495cb339124f13135d51940cf48d83e5cb upstream.

The sysfs function might race with stp_work_fn. To prevent that,
add the required locking. Another issue is that the sysfs functions
are checking the stp_online flag, but this flag just holds the user
setting whether STP is enabled. Add a flag to clock_sync_flag whether
stp_info holds valid data and use that instead.

Cc: stable@vger.kernel.org
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/time.c |  118 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 85 insertions(+), 33 deletions(-)

--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -354,8 +354,9 @@ static DEFINE_PER_CPU(atomic_t, clock_sy
 static DEFINE_MUTEX(clock_sync_mutex);
 static unsigned long clock_sync_flags;
 
-#define CLOCK_SYNC_HAS_STP	0
-#define CLOCK_SYNC_STP		1
+#define CLOCK_SYNC_HAS_STP		0
+#define CLOCK_SYNC_STP			1
+#define CLOCK_SYNC_STPINFO_VALID	2
 
 /*
  * The get_clock function for the physical clock. It will get the current
@@ -592,6 +593,22 @@ void stp_queue_work(void)
 	queue_work(time_sync_wq, &stp_work);
 }
 
+static int __store_stpinfo(void)
+{
+	int rc = chsc_sstpi(stp_page, &stp_info, sizeof(struct stp_sstpi));
+
+	if (rc)
+		clear_bit(CLOCK_SYNC_STPINFO_VALID, &clock_sync_flags);
+	else
+		set_bit(CLOCK_SYNC_STPINFO_VALID, &clock_sync_flags);
+	return rc;
+}
+
+static int stpinfo_valid(void)
+{
+	return stp_online && test_bit(CLOCK_SYNC_STPINFO_VALID, &clock_sync_flags);
+}
+
 static int stp_sync_clock(void *data)
 {
 	struct clock_sync_data *sync = data;
@@ -613,8 +630,7 @@ static int stp_sync_clock(void *data)
 			if (rc == 0) {
 				sync->clock_delta = clock_delta;
 				clock_sync_global(clock_delta);
-				rc = chsc_sstpi(stp_page, &stp_info,
-						sizeof(struct stp_sstpi));
+				rc = __store_stpinfo();
 				if (rc == 0 && stp_info.tmd != 2)
 					rc = -EAGAIN;
 			}
@@ -659,7 +675,7 @@ static void stp_work_fn(struct work_stru
 	if (rc)
 		goto out_unlock;
 
-	rc = chsc_sstpi(stp_page, &stp_info, sizeof(struct stp_sstpi));
+	rc = __store_stpinfo();
 	if (rc || stp_info.c == 0)
 		goto out_unlock;
 
@@ -696,10 +712,14 @@ static ssize_t stp_ctn_id_show(struct de
 				struct device_attribute *attr,
 				char *buf)
 {
-	if (!stp_online)
-		return -ENODATA;
-	return sprintf(buf, "%016llx\n",
-		       *(unsigned long long *) stp_info.ctnid);
+	ssize_t ret = -ENODATA;
+
+	mutex_lock(&stp_work_mutex);
+	if (stpinfo_valid())
+		ret = sprintf(buf, "%016llx\n",
+			      *(unsigned long long *) stp_info.ctnid);
+	mutex_unlock(&stp_work_mutex);
+	return ret;
 }
 
 static DEVICE_ATTR(ctn_id, 0400, stp_ctn_id_show, NULL);
@@ -708,9 +728,13 @@ static ssize_t stp_ctn_type_show(struct
 				struct device_attribute *attr,
 				char *buf)
 {
-	if (!stp_online)
-		return -ENODATA;
-	return sprintf(buf, "%i\n", stp_info.ctn);
+	ssize_t ret = -ENODATA;
+
+	mutex_lock(&stp_work_mutex);
+	if (stpinfo_valid())
+		ret = sprintf(buf, "%i\n", stp_info.ctn);
+	mutex_unlock(&stp_work_mutex);
+	return ret;
 }
 
 static DEVICE_ATTR(ctn_type, 0400, stp_ctn_type_show, NULL);
@@ -719,9 +743,13 @@ static ssize_t stp_dst_offset_show(struc
 				   struct device_attribute *attr,
 				   char *buf)
 {
-	if (!stp_online || !(stp_info.vbits & 0x2000))
-		return -ENODATA;
-	return sprintf(buf, "%i\n", (int)(s16) stp_info.dsto);
+	ssize_t ret = -ENODATA;
+
+	mutex_lock(&stp_work_mutex);
+	if (stpinfo_valid() && (stp_info.vbits & 0x2000))
+		ret = sprintf(buf, "%i\n", (int)(s16) stp_info.dsto);
+	mutex_unlock(&stp_work_mutex);
+	return ret;
 }
 
 static DEVICE_ATTR(dst_offset, 0400, stp_dst_offset_show, NULL);
@@ -730,9 +758,13 @@ static ssize_t stp_leap_seconds_show(str
 					struct device_attribute *attr,
 					char *buf)
 {
-	if (!stp_online || !(stp_info.vbits & 0x8000))
-		return -ENODATA;
-	return sprintf(buf, "%i\n", (int)(s16) stp_info.leaps);
+	ssize_t ret = -ENODATA;
+
+	mutex_lock(&stp_work_mutex);
+	if (stpinfo_valid() && (stp_info.vbits & 0x8000))
+		ret = sprintf(buf, "%i\n", (int)(s16) stp_info.leaps);
+	mutex_unlock(&stp_work_mutex);
+	return ret;
 }
 
 static DEVICE_ATTR(leap_seconds, 0400, stp_leap_seconds_show, NULL);
@@ -741,9 +773,13 @@ static ssize_t stp_stratum_show(struct d
 				struct device_attribute *attr,
 				char *buf)
 {
-	if (!stp_online)
-		return -ENODATA;
-	return sprintf(buf, "%i\n", (int)(s16) stp_info.stratum);
+	ssize_t ret = -ENODATA;
+
+	mutex_lock(&stp_work_mutex);
+	if (stpinfo_valid())
+		ret = sprintf(buf, "%i\n", (int)(s16) stp_info.stratum);
+	mutex_unlock(&stp_work_mutex);
+	return ret;
 }
 
 static DEVICE_ATTR(stratum, 0400, stp_stratum_show, NULL);
@@ -752,9 +788,13 @@ static ssize_t stp_time_offset_show(stru
 				struct device_attribute *attr,
 				char *buf)
 {
-	if (!stp_online || !(stp_info.vbits & 0x0800))
-		return -ENODATA;
-	return sprintf(buf, "%i\n", (int) stp_info.tto);
+	ssize_t ret = -ENODATA;
+
+	mutex_lock(&stp_work_mutex);
+	if (stpinfo_valid() && (stp_info.vbits & 0x0800))
+		ret = sprintf(buf, "%i\n", (int) stp_info.tto);
+	mutex_unlock(&stp_work_mutex);
+	return ret;
 }
 
 static DEVICE_ATTR(time_offset, 0400, stp_time_offset_show, NULL);
@@ -763,9 +803,13 @@ static ssize_t stp_time_zone_offset_show
 				struct device_attribute *attr,
 				char *buf)
 {
-	if (!stp_online || !(stp_info.vbits & 0x4000))
-		return -ENODATA;
-	return sprintf(buf, "%i\n", (int)(s16) stp_info.tzo);
+	ssize_t ret = -ENODATA;
+
+	mutex_lock(&stp_work_mutex);
+	if (stpinfo_valid() && (stp_info.vbits & 0x4000))
+		ret = sprintf(buf, "%i\n", (int)(s16) stp_info.tzo);
+	mutex_unlock(&stp_work_mutex);
+	return ret;
 }
 
 static DEVICE_ATTR(time_zone_offset, 0400,
@@ -775,9 +819,13 @@ static ssize_t stp_timing_mode_show(stru
 				struct device_attribute *attr,
 				char *buf)
 {
-	if (!stp_online)
-		return -ENODATA;
-	return sprintf(buf, "%i\n", stp_info.tmd);
+	ssize_t ret = -ENODATA;
+
+	mutex_lock(&stp_work_mutex);
+	if (stpinfo_valid())
+		ret = sprintf(buf, "%i\n", stp_info.tmd);
+	mutex_unlock(&stp_work_mutex);
+	return ret;
 }
 
 static DEVICE_ATTR(timing_mode, 0400, stp_timing_mode_show, NULL);
@@ -786,9 +834,13 @@ static ssize_t stp_timing_state_show(str
 				struct device_attribute *attr,
 				char *buf)
 {
-	if (!stp_online)
-		return -ENODATA;
-	return sprintf(buf, "%i\n", stp_info.tst);
+	ssize_t ret = -ENODATA;
+
+	mutex_lock(&stp_work_mutex);
+	if (stpinfo_valid())
+		ret = sprintf(buf, "%i\n", stp_info.tst);
+	mutex_unlock(&stp_work_mutex);
+	return ret;
 }
 
 static DEVICE_ATTR(timing_state, 0400, stp_timing_state_show, NULL);


