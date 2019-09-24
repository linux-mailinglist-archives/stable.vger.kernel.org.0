Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A27FBCC14
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439162AbfIXQGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:06:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439158AbfIXQGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 12:06:37 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8OFkkXZ104055
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 12:06:36 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v7n6pknye-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 12:06:35 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <maier@linux.ibm.com>;
        Tue, 24 Sep 2019 17:06:33 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Sep 2019 17:06:32 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8OG6UaZ21299342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 16:06:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6865A4204B;
        Tue, 24 Sep 2019 16:06:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11B6642047;
        Tue, 24 Sep 2019 16:06:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Sep 2019 16:06:30 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH] zfcp: fix reaction on bit error theshold notification with adapter close
Date:   Tue, 24 Sep 2019 18:06:16 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19092416-0008-0000-0000-0000031A6E51
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092416-0009-0000-0000-00004A3902C3
Message-Id: <20190924160616.15301-1-maier@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-24_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909240147
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kernel message explanation:

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


 drivers/s390/scsi/zfcp_fsf.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 296bbc3c4606..cf63916814cc 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -27,6 +27,11 @@
 
 struct kmem_cache *zfcp_fsf_qtcb_cache;
 
+static bool ber_stop = true;
+module_param(ber_stop, bool, 0600);
+MODULE_PARM_DESC(ber_stop,
+		 "Shuts down FCP devices for FCP channels that report a bit-error count in excess of its threshold (default on)");
+
 static void zfcp_fsf_request_timeout_handler(struct timer_list *t)
 {
 	struct zfcp_fsf_req *fsf_req = from_timer(fsf_req, t, timer);
@@ -236,10 +241,15 @@ static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
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

