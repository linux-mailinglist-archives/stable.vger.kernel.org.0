Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC7A43919C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 10:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhJYIol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 04:44:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232151AbhJYIok (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 04:44:40 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P6B0j7002297
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 04:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=x9XO6NAp/U9ph+aZ6edFg3PfoRKGH6HNca3PiKpsnZM=;
 b=HyVOLexOOU4vhjTi22dCYjkkH5/NOJD5IBsDJYXTUclGE8kU6COP2D2QHlN/0630qjeB
 dIHS2bFWPm/6MZtbCspMDtg8qkCn6V+R97agPFjjZLlBVZbQ1Sbfyi9qHVcMEqLa6KFw
 yls1tabcamXphJSO8u4/N/B+in8pCV33ViV/iygFvrxHeBlhqkiQFng6ykuK5upOgsnl
 uI9T7SKiQ0SGFPUA3TwlAi3MhuMW+WFBKB760NH6S7l1ClgIc6jLmlcawa3BmpvA2xFK
 kVaWlFML3jVhbWzZU2HwbtIr6k0tontAFV0iIN7yzOMPwedjkrJ8awjMjDydedeRoTqC Mg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bvy9q4nrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 04:42:17 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P8Ylql010776
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 08:42:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3bva19kk02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 08:42:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P8gCqH54395328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 08:42:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F97A4C058;
        Mon, 25 Oct 2021 08:42:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EE664C052;
        Mon, 25 Oct 2021 08:42:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 08:42:12 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH v2 5.14 0/2] s390/pci: fix zpci_zdev_put() on reserve
Date:   Mon, 25 Oct 2021 10:42:10 +0200
Message-Id: <20211025084212.3366683-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UB79T2OTskkzcF8Zyf1Bfh5p5tFuaSI_
X-Proofpoint-GUID: UB79T2OTskkzcF8Zyf1Bfh5p5tFuaSI_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_02,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 mlxlogscore=712 clxscore=1011 suspectscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250050
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Hi Sasha,

Please take this backport of the upstream commit a46044a92add ("s390/pci: fix
zpci_zdev_put() on reserve") for the v5.14 stable series. After adding the
prerequisite commit 02368b7cf6c7 ("s390/pci: cleanup resources only if
necessary") both it and the original upstream patch apply cleanly. I have also
tested them with the original problem situation on top of v5.14.14 and
confirmed the issue to be fixed.

Thanks,
Niklas

Changes since v2:
- Correct upstream commit hash

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

