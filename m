Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECABA23BF66
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 20:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgHDSgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 14:36:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55544 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726394AbgHDSgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 14:36:00 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 074IX03m075156
        for <stable@vger.kernel.org>; Tue, 4 Aug 2020 14:35:59 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32qcbx1bs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 14:35:59 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 074IGp3N017517
        for <stable@vger.kernel.org>; Tue, 4 Aug 2020 18:35:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 32mynh3k5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 18:35:57 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 074IZskn12714392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Aug 2020 18:35:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73FBE5205A;
        Tue,  4 Aug 2020 18:35:54 +0000 (GMT)
Received: from oc3871087118.ibm.com (unknown [9.145.173.59])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2CEB952050;
        Tue,  4 Aug 2020 18:35:54 +0000 (GMT)
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     linux390-list@tuxmaker.boeblingen.de.ibm.com
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        <stable@vger.kernel.org>, Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v2 1/3] s390/numa: set node distance to LOCAL_DISTANCE
Date:   Tue,  4 Aug 2020 20:35:49 +0200
Message-Id: <c87c17b99a710d1752a189180582afb6ced9efeb.1596565862.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1596565862.git.agordeev@linux.ibm.com>
References: <cover.1596565862.git.agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-04_04:2020-08-03,2020-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 impostorscore=0
 suspectscore=1 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=738
 phishscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008040133
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The node distance is hardcoded to 0, which causes a trouble
for some user-level applications. In particular, "libnuma"
expects the distance of a node to itself as LOCAL_DISTANCE.
This update removes the offending node distance override.

Cc: <stable@vger.kernel.org> # v5.6+
Cc: Heiko Carstens <hca@linux.ibm.com>
Fixes: 701dc81e7412 ("s390/mm: remove fake numa support")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/include/asm/topology.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index fbb5075..3a0ac0c 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -86,12 +86,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
 
-#define node_distance(a, b) __node_distance(a, b)
-static inline int __node_distance(int a, int b)
-{
-	return 0;
-}
-
 #else /* !CONFIG_NUMA */
 
 #define numa_node_id numa_node_id
-- 
1.8.3.1

