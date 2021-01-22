Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051F72FFDA3
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 08:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbhAVHvm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 22 Jan 2021 02:51:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6858 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbhAVHvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 02:51:40 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10M7Yvfl104084;
        Fri, 22 Jan 2021 02:50:36 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367q7vd1g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 02:50:35 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10M7kmpG004110;
        Fri, 22 Jan 2021 07:50:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 367k0p0au4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 07:50:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10M7oPTe31588770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 07:50:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4A9BA4051;
        Fri, 22 Jan 2021 07:50:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92330A4053;
        Fri, 22 Jan 2021 07:50:31 +0000 (GMT)
Received: from smtp.tlslab.ibm.com (unknown [9.101.4.1])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 22 Jan 2021 07:50:31 +0000 (GMT)
Received: from yukon.ibmuc.com (sig-9-145-158-191.de.ibm.com [9.145.158.191])
        by smtp.tlslab.ibm.com (Postfix) with ESMTP id DF7FD2200C9;
        Fri, 22 Jan 2021 08:50:30 +0100 (CET)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        stable@vger.kernel.org
Subject: [PATCH] powerpc/prom: Fix "ibm,arch-vec-5-platform-support" scan
Date:   Fri, 22 Jan 2021 08:50:29 +0100
Message-Id: <20210122075029.797013-1-clg@kaod.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_03:2021-01-21,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 adultscore=0 clxscore=1034 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220036
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The "ibm,arch-vec-5-platform-support" property is a list of pairs of
bytes representing the options and values supported by the platform
firmware. At boot time, Linux scans this list and activates the
available features it recognizes : Radix and XIVE.

A recent change modified the number of entries to loop on and 8 bytes,
4 pairs of { options, values } entries are always scanned. This is
fine on KVM but not on PowerVM which can advertises less. As a
consequence on this platform, Linux reads extra entries pointing to
random data, interprets these as available features and tries to
activate them, leading to a firmware crash in
ibm,client-architecture-support.

Fix that by using the property length of "ibm,arch-vec-5-platform-support".

Cc: stable@vger.kernel.org # v4.20+
Fixes: ab91239942a9 ("powerpc/prom: Remove VLA in prom_check_platform_support()")
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/kernel/prom_init.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index e9d4eb6144e1..ccf77b985c8f 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1331,14 +1331,10 @@ static void __init prom_check_platform_support(void)
 		if (prop_len > sizeof(vec))
 			prom_printf("WARNING: ibm,arch-vec-5-platform-support longer than expected (len: %d)\n",
 				    prop_len);
-		prom_getprop(prom.chosen, "ibm,arch-vec-5-platform-support",
-			     &vec, sizeof(vec));
-		for (i = 0; i < sizeof(vec); i += 2) {
-			prom_debug("%d: index = 0x%x val = 0x%x\n", i / 2
-								  , vec[i]
-								  , vec[i + 1]);
-			prom_parse_platform_support(vec[i], vec[i + 1],
-						    &supported);
+		prom_getprop(prom.chosen, "ibm,arch-vec-5-platform-support", &vec, sizeof(vec));
+		for (i = 0; i < prop_len; i += 2) {
+			prom_debug("%d: index = 0x%x val = 0x%x\n", i / 2, vec[i], vec[i + 1]);
+			prom_parse_platform_support(vec[i], vec[i + 1], &supported);
 		}
 	}
 
-- 
2.26.2

