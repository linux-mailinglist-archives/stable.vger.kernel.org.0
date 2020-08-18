Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BAF248361
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 12:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgHRKy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 06:54:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgHRKy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 06:54:56 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IAX2b1166433;
        Tue, 18 Aug 2020 06:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=BQl/JGyV+PSzIzrQReFot0bt5FBZzRabmBo6TzKnm3E=;
 b=FHiyEpVJ3PxhyUHlZfDL29qR+ThRrlPmtZx/L4hb4Zz0l3s+N8OknONOuLZCuigcagls
 wyU76D/2yuu0gwXe+IT4fjljonEJF0cnbBkEg0YTFlgq5UFjSPl3/iI6XbJ2POeqQ4lp
 2rzapnQ5zCzs03CYogSkZ8DgpT8qyys7kXkiHcU7exkMER+UQ8kjRVgHldXhfLAxxNU4
 +Owg9ZXdaHK4TEmx1jP3wl2PwgW8ttqM0gZWPZNm8jLsz1SXMl68ftIxqQbOceeKh3El
 QwL0dkO1Qt6BMYKUnt0Av2izq/WWOziWbgV0ERppvffASVbqHExap2CSI4K/sSybF1Hm IA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r5nw39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 06:54:48 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07IAnqgZ007301;
        Tue, 18 Aug 2020 10:54:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3304bbrav4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 10:54:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07IAsien9372132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 10:54:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5227A404D;
        Tue, 18 Aug 2020 10:54:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2D57A4059;
        Tue, 18 Aug 2020 10:54:42 +0000 (GMT)
Received: from hegdevasant.in.ibm.com (unknown [9.199.53.210])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Aug 2020 10:54:42 +0000 (GMT)
From:   Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] powerpc/pseries: Do not initiate shutdown when system is running on UPS
Date:   Tue, 18 Aug 2020 16:24:24 +0530
Message-Id: <20200818105424.234108-1-hegdevasant@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_06:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 impostorscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1011 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As per PAPR specification whenever system is running on UPS we have to
wait for predefined time (default 10mins) before initiating shutdown.

We have user space tool (rtas_errd) to monitor for EPOW events and
initiate shutdown after predefined time. Hence do not initiate shutdown
whenever we get EPOW_SHUTDOWN_ON_UPS event.

Fixes: 79872e35 (powerpc/pseries: All events of EPOW_SYSTEM_SHUTDOWN must initiate shutdown)
Cc: stable@vger.kernel.org # v4.0+
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/ras.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index f3736fcd98fc..13c86a292c6d 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -184,7 +184,6 @@ static void handle_system_shutdown(char event_modifier)
 	case EPOW_SHUTDOWN_ON_UPS:
 		pr_emerg("Loss of system power detected. System is running on"
 			 " UPS/battery. Check RTAS error log for details\n");
-		orderly_poweroff(true);
 		break;
 
 	case EPOW_SHUTDOWN_LOSS_OF_CRITICAL_FUNCTIONS:
-- 
2.26.2

