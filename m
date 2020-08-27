Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB12253F6D
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgH0Hn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:43:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33564 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726851AbgH0Hn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 03:43:29 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R7VZiX086372;
        Thu, 27 Aug 2020 03:43:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Jgbq9Z25NmKfcVc5oGcluAe1p0AxxXFRlIVCVeQguxs=;
 b=c3i1Rvq3AKFpbWlyZOs0csse7e1dHCHiybskbZ8fekYhdjLfF+7T5vIZauJ/bpt+jyej
 MB8jQaAN4WIjRjp0eCECkWIMTZME9fdOnB4cjSQ8MEEQAOQ/d8Cw92mmSXQu0AyYN5mO
 N5PRhMe9bZOhWtqsTT+Rn++SXjAXR6ceaayuWXyuuoDIYrktp/3TvIA0VJvJfZwlEySB
 bjo6YI8MtEqEfSD3wQc7xNXjcRw36pa38wEdjPX82FCoT/O9szwSAyz3HOaeIudf+urK
 MEdnZ/JQJwgWrzl2sKjYdFg1rfZ3sjxJcTuXhSKmSbDnt4Pltnl8lAPwCzEjaRWThk7d Mg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3366fmbqvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 03:43:21 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R7hJHx000306;
        Thu, 27 Aug 2020 07:43:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 335a2t8ymr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 07:43:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R7hHCW32571802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 07:43:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 465AFA4051;
        Thu, 27 Aug 2020 07:43:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BF8EA4040;
        Thu, 27 Aug 2020 07:43:16 +0000 (GMT)
Received: from hegdevasant.in.ibm.com (unknown [9.77.194.247])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 07:43:16 +0000 (GMT)
From:   Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
To:     stable@vger.kernel.org
Cc:     Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH stable v4.4] powerpc/pseries: Do not initiate shutdown when system is running on UPS
Date:   Thu, 27 Aug 2020 13:13:07 +0530
Message-Id: <20200827074307.522970-1-hegdevasant@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_02:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270053
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 90a9b102eddf6a3f987d15f4454e26a2532c1c98 upstream.

As per PAPR we have to look for both EPOW sensor value and event
modifier to identify the type of event and take appropriate action.

In LoPAPR v1.1 section 10.2.2 includes table 136 "EPOW Action Codes":

  SYSTEM_SHUTDOWN 3

  The system must be shut down. An EPOW-aware OS logs the EPOW error
  log information, then schedules the system to be shut down to begin
  after an OS defined delay internal (default is 10 minutes.)

Then in section 10.3.2.2.8 there is table 146 "Platform Event Log
Format, Version 6, EPOW Section", which includes the "EPOW Event
Modifier":

  For EPOW sensor value = 3
  0x01 = Normal system shutdown with no additional delay
  0x02 = Loss of utility power, system is running on UPS/Battery
  0x03 = Loss of system critical functions, system should be shutdown
  0x04 = Ambient temperature too high
  All other values = reserved

We have a user space tool (rtas_errd) on LPAR to monitor for
EPOW_SHUTDOWN_ON_UPS. Once it gets an event it initiates shutdown
after predefined time. It also starts monitoring for any new EPOW
events. If it receives "Power restored" event before predefined time
it will cancel the shutdown. Otherwise after predefined time it will
shutdown the system.

Commit 79872e35469b ("powerpc/pseries: All events of
EPOW_SYSTEM_SHUTDOWN must initiate shutdown") changed our handling of
the "on UPS/Battery" case, to immediately shutdown the system. This
breaks existing setups that rely on the userspace tool to delay
shutdown and let the system run on the UPS.

Fixes: 79872e35469b ("powerpc/pseries: All events of EPOW_SYSTEM_SHUTDOWN must initiate shutdown")
Cc: stable@vger.kernel.org # v4.0+
Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
[mpe: Massage change log and add PAPR references]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200820061844.306460-1-hegdevasant@linux.vnet.ibm.com
Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
---
Hi,
  Please apply this patch to linux-stable-v4.4 branch. Its already applied to
  other required stable branches.

-Vasant

 arch/powerpc/platforms/pseries/ras.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index 9e817c1b7808..1fa8e492ce27 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -90,7 +90,6 @@ static void handle_system_shutdown(char event_modifier)
 		pr_emerg("Loss of power reported by firmware, system is "
 			"running on UPS/battery");
 		pr_emerg("Check RTAS error log for details");
-		orderly_poweroff(true);
 		break;
 
 	case EPOW_SHUTDOWN_LOSS_OF_CRITICAL_FUNCTIONS:
-- 
2.26.2

