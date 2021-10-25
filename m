Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC834391E8
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 11:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhJYJDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 05:03:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32070 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231940AbhJYJCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 05:02:54 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P6uZMt015760
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 05:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mQSJHbuxSb/WzwWaTRw5T1O0ZSUSQMlTsKlEd7kylW4=;
 b=mmYIWNw6CwAq1LoZeYvjVYY33iBwyic4AguanganPu6469MBTCmq9DNfiw7v914YH30b
 a35IYVYyH+d8vnebwr25YxyJZadpvsWVaq97/vce/6E2OEz2AaflvahQTjjYq4ffc3ya
 GRRZcA1NonEafMMClr2oIffQdvgMtXpRKvVOgjpW8o9G3gqw6c6w2cqBcD8LGqmPxOew
 +caER6A7/P5G09abs4krO1KL6i2MJIHC+CmwBUKzgczJlRBjYmibXp78PnOG+VIPUriS
 h1kN1UnlD8a68OWBrAzUDiQkji5tlvytt7xL8FOFbTDAd4lxWz9hYRmuwbnUo3Akv/i9 IQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bvyj44wnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 05:00:31 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P8wfO8013524
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 09:00:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bv9njbvc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 09:00:30 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P8sLqX43909390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 08:54:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83D7742061;
        Mon, 25 Oct 2021 09:00:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 635A742049;
        Mon, 25 Oct 2021 09:00:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:00:26 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 5.10 0/1] s390/pci: fix zpci_zdev_put() on reserve
Date:   Mon, 25 Oct 2021 11:00:25 +0200
Message-Id: <20211025090026.3392254-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: knHIoaSGxSVnCQoaCOTIJieAhK_SBVV3
X-Proofpoint-ORIG-GUID: knHIoaSGxSVnCQoaCOTIJieAhK_SBVV3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_02,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=666
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250050
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Hi Sasha,

Please take this backport of the upstream commit a46044a92add ("s390/pci: fix
zpci_zdev_put() on reserve") for the v5.10 stable series. Unlike the v5.14
series we do *NOT* include commit 023cc3cb1e4b ("s390/pci: cleanup resources only if
necessary") either as a separate commit subsumed. We don't yet have the
zdev->has_resource attribute that was added as part of v5.13 and do not need it
for this fix.

Thanks,
Niklas

Niklas Schnelle (1):
  s390/pci: fix zpci_zdev_put() on reserve

 arch/s390/include/asm/pci.h        |  3 ++
 arch/s390/pci/pci.c                | 45 ++++++++++++++++++++++++++----
 arch/s390/pci/pci_event.c          |  4 +--
 drivers/pci/hotplug/s390_pci_hpc.c |  9 +-----
 4 files changed, 46 insertions(+), 15 deletions(-)

-- 
2.25.1

