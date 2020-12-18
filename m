Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA952DE3E0
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 15:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgLROTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 09:19:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725883AbgLROS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 09:18:59 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BIECwCW154079;
        Fri, 18 Dec 2020 09:18:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aKpVq/XXmlbmksUUEQfZRzUNkWSdVwgJWNs4QCIYb+g=;
 b=nI5N54pkILIUWO0+CSWtEeTDjgUtNWAWt/0npRSu/Oq56JHn6NyyScdNGCMnm3/P+SdQ
 /Em0YSOo5llQa5hbwE8aLyfQQgqV2OLcpoReFj7WtpwdJW/IKW/u50ubagIIpUUEH6Q2
 DlPmc/RICla61G0tgPHa4l/fhwSMtiFaUx/lLupebOP6ihALdqkkQeV4Ln4VQsPkmsBr
 JZPEg6YuKSn3MqE0BU0KSpFfg1+FfqQFFEx+/jQWHECb8cgnF+J9y2B3CepmAZwSpZhL
 +1oYVi2qYdbxitll5VaF+SdgDWD0oaluE2g8mMKaB2Ci8hFZDX117zEQ/v4wg1W1lms0 Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35gx01850p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 09:18:17 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BIEDn4F155745;
        Fri, 18 Dec 2020 09:18:17 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35gx018501-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 09:18:17 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BIEIFSh012363;
        Fri, 18 Dec 2020 14:18:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 35cng889na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 14:18:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BIEICcK37224838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 14:18:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A298DA405B;
        Fri, 18 Dec 2020 14:18:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 453EDA4064;
        Fri, 18 Dec 2020 14:18:12 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.12.102])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Dec 2020 14:18:12 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 1/4] s390/kvm: VSIE: stop leaking host addresses
Date:   Fri, 18 Dec 2020 15:18:08 +0100
Message-Id: <20201218141811.310267-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201218141811.310267-1-imbrenda@linux.ibm.com>
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_09:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1011 mlxscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012180095
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The addresses in the SIE control block of the host should not be
forwarded to the guest. They are only meaningful to the host, and
moreover it would be a clear security issue.

Subsequent patches will actually put the right values in the guest SIE
control block.

Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested virtualization")
Cc: stable@vger.kernel.org
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 4f3cbf6003a9..ada49583e530 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -416,11 +416,6 @@ static void unshadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		memcpy((void *)((u64)scb_o + 0xc0),
 		       (void *)((u64)scb_s + 0xc0), 0xf0 - 0xc0);
 		break;
-	case ICPT_PARTEXEC:
-		/* MVPG only */
-		memcpy((void *)((u64)scb_o + 0xc0),
-		       (void *)((u64)scb_s + 0xc0), 0xd0 - 0xc0);
-		break;
 	}
 
 	if (scb_s->ihcpu != 0xffffU)
-- 
2.26.2

