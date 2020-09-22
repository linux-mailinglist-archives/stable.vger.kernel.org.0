Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFA9273B7B
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 09:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgIVHNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 03:13:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728526AbgIVHNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 03:13:09 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08M74vE0046218
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 03:13:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=LshJs0D0hwiq6qWAeHedsfSEkUb+3wdNpCO4iqfsF7I=;
 b=DqCqfFSF9jPUomwl8onf8hgu1ML6ocuLw9L4jhP/Y/MqSfAGYdA5ScYK3HgQHJwt/vjW
 shrGDkbMN1l4n69oWvu2Tu4/tzXWVoiX0EIT1Ct2kRttjIIDUKS+/bqofKixaUXm2EpW
 ZgMbCpvbJAsRrzuHPoBemEVaFoMglxotmFZspOryFQxjNoal+aDy47Vl6NIuwQ2ZQYYX
 S0qbecW6NFENZj8KEoMykPRppvf98PeafCJTZg4b+nBGs8D+TpGzoSW7UxHbCiBE8REd
 eWtRkgl21TuHf9cBPRMZbsUIYTY1ud6tIbBHMf0/gXgfCaoGnTLnB5r8AgI0wralIW2r 3Q== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qb0saq0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 03:13:08 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08M77dh9022880
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 07:13:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 33n98gsfac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 07:13:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08M7D3pH25231668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 07:13:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72ECD42045;
        Tue, 22 Sep 2020 07:13:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A5EC4203F;
        Tue, 22 Sep 2020 07:13:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 22 Sep 2020 07:13:03 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55390)
        id 0DD48E052B; Tue, 22 Sep 2020 09:13:03 +0200 (CEST)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     linux390-list@tuxmaker.boeblingen.de.ibm.com
Cc:     Sven Schnelle <svens@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v5 1/6] s390/stp: add locking to sysfs functions
Date:   Tue, 22 Sep 2020 09:12:50 +0200
Message-Id: <20200922071255.30399-2-svens@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200922071255.30399-1-svens@linux.ibm.com>
References: <20200922071255.30399-1-svens@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_05:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 mlxlogscore=811 clxscore=1011 adultscore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=1 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220056
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The sysfs function might race with stp_work_fn. To prevent that,
add the required locking. Another issue is that the sysfs functions
are checking the stp_online flag, but this flag just holds the user
setting whether STP is enabled. Add a flag to clock_sync_flag whether
stp_info holds valid data and use that instead.

Reference-ID: KRN1904
Cc: stable@vger.kernel.org
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
---
 arch/s390/kernel/time.c | 118 +++++++++++++++++++++++++++++-----------
 1 file changed, 85 insertions(+), 33 deletions(-)

diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index bc806e1547d6..bee380340bad 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -299,8 +299,9 @@ static DEFINE_PER_CPU(atomic_t, clock_sync_word);
 static DEFINE_MUTEX(clock_sync_mutex);
 static unsigned long clock_sync_flags;
 
-#define CLOCK_SYNC_HAS_STP	0
-#define CLOCK_SYNC_STP		1
+#define CLOCK_SYNC_HAS_STP		0
+#define CLOCK_SYNC_STP			1
+#define CLOCK_SYNC_STPINFO_VALID	2
 
 /*
  * The get_clock function for the physical clock. It will get the current
@@ -535,6 +536,22 @@ void stp_queue_work(void)
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
@@ -557,8 +574,7 @@ static int stp_sync_clock(void *data)
 			if (rc == 0) {
 				sync->clock_delta = clock_delta;
 				clock_sync_global(clock_delta);
-				rc = chsc_sstpi(stp_page, &stp_info,
-						sizeof(struct stp_sstpi));
+				rc = __store_stpinfo();
 				if (rc == 0 && stp_info.tmd != 2)
 					rc = -EAGAIN;
 			}
@@ -604,7 +620,7 @@ static void stp_work_fn(struct work_struct *work)
 	if (rc)
 		goto out_unlock;
 
-	rc = chsc_sstpi(stp_page, &stp_info, sizeof(struct stp_sstpi));
+	rc = __store_stpinfo();
 	if (rc || stp_info.c == 0)
 		goto out_unlock;
 
@@ -641,10 +657,14 @@ static ssize_t ctn_id_show(struct device *dev,
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
 
 static DEVICE_ATTR_RO(ctn_id);
@@ -653,9 +673,13 @@ static ssize_t ctn_type_show(struct device *dev,
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
 
 static DEVICE_ATTR_RO(ctn_type);
@@ -664,9 +688,13 @@ static ssize_t dst_offset_show(struct device *dev,
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
 
 static DEVICE_ATTR_RO(dst_offset);
@@ -675,9 +703,13 @@ static ssize_t leap_seconds_show(struct device *dev,
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
 
 static DEVICE_ATTR_RO(leap_seconds);
@@ -686,9 +718,13 @@ static ssize_t stratum_show(struct device *dev,
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
 
 static DEVICE_ATTR_RO(stratum);
@@ -697,9 +733,13 @@ static ssize_t time_offset_show(struct device *dev,
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
 
 static DEVICE_ATTR_RO(time_offset);
@@ -708,9 +748,13 @@ static ssize_t time_zone_offset_show(struct device *dev,
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
 
 static DEVICE_ATTR_RO(time_zone_offset);
@@ -719,9 +763,13 @@ static ssize_t timing_mode_show(struct device *dev,
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
 
 static DEVICE_ATTR_RO(timing_mode);
@@ -730,9 +778,13 @@ static ssize_t timing_state_show(struct device *dev,
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
 
 static DEVICE_ATTR_RO(timing_state);
-- 
2.17.1

