Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8396224AF26
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 08:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgHTGTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 02:19:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgHTGTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 02:19:02 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07K63jEr003252;
        Thu, 20 Aug 2020 02:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=z8n2g633NtPLlzNWQt1PQg9jiBAurfwqzlV8RDXRyt0=;
 b=QbcpYlCDnlEhcGJtK6cuLk3hPv6gpEt1iWJ4kO3+jUMEgg3YihbVY5i+OkfNAnj5vdEe
 ANyu0aipOosoUPQiL/GMC9accQAsu9V6CqvnvCuKpS/DarKzodYmPLMIfpB+T/jtXRKd
 HbSy+miXKfaIk/JQnTbWEzCpB/Ox/3bULbFsvpUWGB6OB4dufj1iXc5Vuec1brlz5TS7
 LTR2VD2rGucckjO7cGzVT7/T/AZnIvU0pNN/WsOyBPT6OwSp7pnE9THrzdHiNfysgI6z
 uH3sLwGsGg67PJzrX7bKVQYWUU1E53QndZF0wdXoendX0d7yPR+9C6eqe5PyGwXBgnhK lw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3310f01rsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Aug 2020 02:18:52 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07K6CiMT010651;
        Thu, 20 Aug 2020 06:18:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 330tbvsftp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Aug 2020 06:18:50 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07K6ImNU31785248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Aug 2020 06:18:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E392A404D;
        Thu, 20 Aug 2020 06:18:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7608A4040;
        Thu, 20 Aug 2020 06:18:46 +0000 (GMT)
Received: from hegdevasant.in.ibm.com (unknown [9.85.93.150])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Aug 2020 06:18:46 +0000 (GMT)
From:   Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2] powerpc/pseries: Do not initiate shutdown when system is running on UPS
Date:   Thu, 20 Aug 2020 11:48:44 +0530
Message-Id: <20200820061844.306460-1-hegdevasant@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 suspectscore=1
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200052
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As per PAPR we have to look for both EPOW sensor value and event modifier to
identify type of event and take appropriate action.

Sensor value = 3 (EPOW_SYSTEM_SHUTDOWN) schedule system to be shutdown after
                  OS defined delay (default 10 mins).

EPOW Event Modifier for sensor value = 3:
   We have to initiate immediate shutdown for most of the event modifier except
   value = 2 (system running on UPS).

Checking with firmware document its clear that we have to wait for predefined
time before initiating shutdown. If power is restored within time we should
cancel the shutdown process. I think commit 79872e35 accidently enabled
immediate poweroff for EPOW_SHUTDOWN_ON_UPS event.

We have user space tool (rtas_errd) on LPAR to monitor for EPOW_SHUTDOWN_ON_UPS.
Once it gets event it initiates shutdown after predefined time. Also starts
monitoring for any new EPOW events. If it receives "Power restored" event
before predefined time it will cancel the shutdown. Otherwise after
predefined time it will shutdown the system.

Fixes: 79872e35 (powerpc/pseries: All events of EPOW_SYSTEM_SHUTDOWN must initiate shutdown)
Cc: stable@vger.kernel.org # v4.0+
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
---
Changes in v2:
  - Updated patch description based on mpe, Tyrel comment.

-Vasant
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

