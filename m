Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9FFC31BD
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 12:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbfJAKuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 06:50:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730122AbfJAKuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 06:50:14 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x91Ah0PM076594
        for <stable@vger.kernel.org>; Tue, 1 Oct 2019 06:50:12 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vc40ktucr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 06:50:12 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <maier@linux.ibm.com>;
        Tue, 1 Oct 2019 11:50:10 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 1 Oct 2019 11:50:07 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x91Ao6iU45088796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Oct 2019 10:50:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1721EAE05A;
        Tue,  1 Oct 2019 10:50:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE31AAE058;
        Tue,  1 Oct 2019 10:50:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Oct 2019 10:50:05 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v2] zfcp: fix reaction on bit error theshold notification with adapter close
Date:   Tue,  1 Oct 2019 12:49:49 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <yq1d0fhw2ex.fsf@oracle.com>
References: <yq1d0fhw2ex.fsf@oracle.com>
X-TM-AS-GCONF: 00
x-cbid: 19100110-4275-0000-0000-0000036CD799
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100110-4276-0000-0000-0000387F6188
Message-Id: <20191001104949.42810-1-maier@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-01_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910010100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On excessive bit errors for the FCP channel ingress fibre path, the channel
notifies us. Previously, we only emitted a kernel message and a trace record.
Since performance can become suboptimal with I/O timeouts due to
bit errors, we now stop using an FCP device by default on channel
notification so multipath on top can timely failover to other paths.
A new module parameter zfcp.ber_stop can be used to get zfcp old behavior.

User explanation of new kernel message:
 * Description:
 * The FCP channel reported that its bit error threshold has been exceeded.
 * These errors might result from a problem with the physical components
 * of the local fibre link into the FCP channel.
 * The problem might be damage or malfunction of the cable or
 * cable connection between the FCP channel and
 * the adjacent fabric switch port or the point-to-point peer.
 * Find details about the errors in the HBA trace for the FCP device.
 * The zfcp device driver closed down the FCP device
 * to limit the performance impact from possible I/O command timeouts.
 * User action:
 * Check for problems on the local fibre link, ensure that fibre optics are
 * clean and functional, and all cables are properly plugged.
 * After the repair action, you can manually recover the FCP device by
 * writing "0" into its "failed" sysfs attribute.
 * If recovery through sysfs is not possible, set the CHPID of the device
 * offline and back online on the service element.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org> #2.6.30+
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
---

Martin, James,

an important zfcp fix for v5.4-rc.
It applies to Martin's 5.4/scsi-fixes or to James' fixes branch.

Changes since v1:
* Martin's review comments: describe code change and new module parameter


 drivers/s390/scsi/zfcp_fsf.c | 16 +++++++++++++---
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index e31c6b47af97..1e279220f073 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -29,6 +29,11 @@
 
 struct kmem_cache *zfcp_fsf_qtcb_cache;
 
+static bool ber_stop = true;
+module_param(ber_stop, bool, 0600);
+MODULE_PARM_DESC(ber_stop,
+		 "Shuts down FCP devices for FCP channels that report a bit-error count in excess of its threshold (default on)");
+
 static void zfcp_fsf_request_timeout_handler(struct timer_list *t)
 {
 	struct zfcp_fsf_req *fsf_req = from_timer(fsf_req, t, timer);
@@ -238,10 +243,15 @@ static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
 	case FSF_STATUS_READ_SENSE_DATA_AVAIL:
 		break;
 	case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-		dev_warn(&adapter->ccw_device->dev,
-			 "The error threshold for checksum statistics "
-			 "has been exceeded\n");
 		zfcp_dbf_hba_bit_err("fssrh_3", req);
+		if (ber_stop) {
+			dev_warn(&adapter->ccw_device->dev,
+				 "All paths over this FCP device are disused because of excessive bit errors\n");
+			zfcp_erp_adapter_shutdown(adapter, 0, "fssrh_b");
+		} else {
+			dev_warn(&adapter->ccw_device->dev,
+				 "The error threshold for checksum statistics has been exceeded\n");
+		}
 		break;
 	case FSF_STATUS_READ_LINK_DOWN:
 		zfcp_fsf_status_read_link_down(req);
-- 
2.17.1

