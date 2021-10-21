Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0094363D9
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 16:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhJUOQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 10:16:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230283AbhJUOQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 10:16:03 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEBN8W004021
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 10:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=+OJkS2NPj6fDa+8ax+Qhrjcbxx48Gv9dLQ/i8s4knc0=;
 b=mPyJSQNW8IQFpvWPsT3IInN0GGfp/7fn3KoWHantpF6IEF8XtxUoJzF4XvMtlReFUD+8
 IBCmv3dvCZssvv5TXDeGjfguGS3yFc2p/bwzuDC/WZp72SshO4shMm65PQxjRYs++MLF
 NAgp49YdftIEGghSwOPctv/r/+yL5KyC+ibZbX+fl8ABz4DgIShrBcc+jkHlPF2366T7
 vha+HJdKoMYR1KUlBFl2za+mVrDTQX7rwt/IHJHsVMeDz4MjMdu1CfvnuZt2Ix0nWQiO
 2v5BP5hbSoSXGJC0Rr+8oFK/4Kw+VfIGkiyP8c8IrBcp1YR7EeUoG3YMZR+aygMe7wC8 Pg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bu8kkj0gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 10:13:47 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LE8JO5004213
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 14:13:45 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3bqpcampuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 14:13:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LEDgmM1966674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:13:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E8BBAE05A;
        Thu, 21 Oct 2021 14:13:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 036D8AE055;
        Thu, 21 Oct 2021 14:13:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 14:13:41 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 5.14 0/2] s390/pci: fix zpci_zdev_put() on reserve
Date:   Thu, 21 Oct 2021 16:13:39 +0200
Message-Id: <20211021141341.344756-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Rl9deOtBZxs0ZfBMsMv4E_TUmKr3ppUp
X-Proofpoint-GUID: Rl9deOtBZxs0ZfBMsMv4E_TUmKr3ppUp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 mlxlogscore=713 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210076
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Hi Sasha,

Please take this backport of the upstream commit a46044a92add ("s390/pci: fix
zpci_zdev_put() on reserve") for the v5.14 stable series. After adding the
prerequisite commit 023cc3cb1e4b ("s390/pci: cleanup resources only if
necessary") both it and the original upstream patch apply cleanly. I have also
tested them with the original problem situation on top of v5.14.14 and
confirmed the issue to be fixed.

Thanks,
Niklas

Niklas Schnelle (2):
  s390/pci: cleanup resources only if necessary
  s390/pci: fix zpci_zdev_put() on reserve

 arch/s390/include/asm/pci.h        |  2 ++
 arch/s390/pci/pci.c                | 48 ++++++++++++++++++++++++++----
 arch/s390/pci/pci_event.c          |  4 +--
 drivers/pci/hotplug/s390_pci_hpc.c |  9 +-----
 4 files changed, 47 insertions(+), 16 deletions(-)

-- 
2.25.1

