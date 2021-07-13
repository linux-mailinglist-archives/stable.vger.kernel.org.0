Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8A73C6B9C
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 09:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbhGMHpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 03:45:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234548AbhGMHpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 03:45:30 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D7XuPn061320;
        Tue, 13 Jul 2021 03:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=kPEoSNC3+9NeuP52sd4WrijMgjy3yioYcn0or+J92CA=;
 b=VmNCuNdw/Qwwf3GBSibnG5O+kI+j1dfM6eNH9eNwaqZ0LhjDZv+xv1gtqaIFmNoXYSOn
 FXNwKEbMzf3dK8gW7WnChi6adgl/QUsgvel/4kVfG7kikRgcSmRZAqm33qDICU/tHALO
 7P/wfN+CXrqRUlFEOHnLaQRMhwRd31BtR2LA+YshHtLxTRIDh0ee9A4f+E0t3lQn8BDs
 SHx0IZ9nGGBXYcY6kMZfwqk1TGNFhJ+cD1xGnldL0Q4SMR6lbaLh8pznPgYx+W+PEuVH
 bgWIYJp3MwWpVmYyix+/jsfsxNbAproiqeXR/xHKmbv4qJRhmLNog2aOH84swPqsgMrD wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39qrf7v8fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 03:42:34 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16D7XwsO061483;
        Tue, 13 Jul 2021 03:42:33 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39qrf7v8dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 03:42:33 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16D7XIHa022584;
        Tue, 13 Jul 2021 07:42:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 39q36894sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 07:42:30 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16D7gRdx22872370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 07:42:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C26E55204E;
        Tue, 13 Jul 2021 07:42:27 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.199.32.99])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3F6EB52054;
        Tue, 13 Jul 2021 07:42:22 +0000 (GMT)
From:   Kajol Jain <kjain@linux.ibm.com>
To:     will@kernel.org, hao.wu@intel.com, mark.rutland@arm.com
Cc:     trix@redhat.com, yilun.xu@intel.com, mdf@kernel.org,
        linux-fpga@vger.kernel.org, maddy@linux.ibm.com,
        atrajeev@linux.vnet.ibm.com, kjain@linux.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        rnsastry@linux.ibm.com, linux-perf-users@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3] fpga: dfl: fme: Fix cpu hotplug issue in performance reporting
Date:   Tue, 13 Jul 2021 13:12:16 +0530
Message-Id: <20210713074216.208391-1-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FVqvcLVKiLkkyKw4ZEKdT5VwXxDvg-YH
X-Proofpoint-GUID: FLEPZacoJTH9gAwYfc9AKxx11NF3afn9
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-13_03:2021-07-13,2021-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130047
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The performance reporting driver added cpu hotplug
feature but it didn't add pmu migration call in cpu
offline function.
This can create an issue incase the current designated
cpu being used to collect fme pmu data got offline,
as based on current code we are not migrating fme pmu to
new target cpu. Because of that perf will still try to
fetch data from that offline cpu and hence we will not
get counter data.

Patch fixed this issue by adding pmu_migrate_context call
in fme_perf_offline_cpu function.

Fixes: 724142f8c42a ("fpga: dfl: fme: add performance reporting support")
Tested-by: Xu Yilun <yilun.xu@intel.com>
Acked-by: Wu Hao <hao.wu@intel.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Cc: stable@vger.kernel.org
---
 drivers/fpga/dfl-fme-perf.c | 2 ++
 1 file changed, 2 insertions(+)

---
Changelog:
v2 -> v3:
- Added Acked-by tag
- Removed comment as suggested by Wu Hao
- Link to patch v2: https://lkml.org/lkml/2021/7/9/143

v1 -> v2:
- Add stable@vger.kernel.org in cc list
- Link to patch v1: https://lkml.org/lkml/2021/6/28/275

RFC -> PATCH v1
- Remove RFC tag
- Did nits changes on subject and commit message as suggested by Xu Yilun
- Added Tested-by tag
- Link to rfc patch: https://lkml.org/lkml/2021/6/28/112
---

diff --git a/drivers/fpga/dfl-fme-perf.c b/drivers/fpga/dfl-fme-perf.c
index 4299145ef347..587c82be12f7 100644
--- a/drivers/fpga/dfl-fme-perf.c
+++ b/drivers/fpga/dfl-fme-perf.c
@@ -953,6 +953,8 @@ static int fme_perf_offline_cpu(unsigned int cpu, struct hlist_node *node)
 		return 0;
 
 	priv->cpu = target;
+	perf_pmu_migrate_context(&priv->pmu, cpu, target);
+
 	return 0;
 }
 
-- 
2.31.1

