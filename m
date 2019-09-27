Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B551AC04A3
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 13:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfI0Lxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 07:53:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8132 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbfI0Lxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Sep 2019 07:53:42 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8RBkl2Q142230
        for <stable@vger.kernel.org>; Fri, 27 Sep 2019 07:53:41 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v9epwxmq4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 27 Sep 2019 07:53:41 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <groug@kaod.org>;
        Fri, 27 Sep 2019 12:53:38 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 27 Sep 2019 12:53:34 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8RBrXKQ24445092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 11:53:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F326AAE057;
        Fri, 27 Sep 2019 11:53:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 992F4AE055;
        Fri, 27 Sep 2019 11:53:32 +0000 (GMT)
Received: from bahia.lan (unknown [9.145.172.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Sep 2019 11:53:32 +0000 (GMT)
Subject: [PATCH v2 0/6] KVM: PPC: Book3S: HV: XIVE: Allocate less VPs in OPAL
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Date:   Fri, 27 Sep 2019 13:53:32 +0200
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19092711-4275-0000-0000-0000036BC507
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092711-4276-0000-0000-0000387E46F9
Message-Id: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-27_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=315 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909270112
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This brings some fixes and allows to start more VMs with an in-kernel
XIVE or XICS-on-XIVE device.

Changes since v1 (https://patchwork.ozlabs.org/cover/1166099/):
- drop a useless patch
- add a patch to show VP ids in debugfs
- update some changelogs
- fix buggy check in patch 5
- Cc: stable 

--
Greg

---

Greg Kurz (6):
      KVM: PPC: Book3S HV: XIVE: Set kvm->arch.xive when VPs are allocated
      KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already in use
      KVM: PPC: Book3S HV: XIVE: Show VP id in debugfs
      KVM: PPC: Book3S HV: XIVE: Compute the VP id in a common helper
      KVM: PPC: Book3S HV: XIVE: Make VP block size configurable
      KVM: PPC: Book3S HV: XIVE: Allow userspace to set the # of VPs


 Documentation/virt/kvm/devices/xics.txt |   14 +++
 Documentation/virt/kvm/devices/xive.txt |    8 ++
 arch/powerpc/include/uapi/asm/kvm.h     |    3 +
 arch/powerpc/kvm/book3s_xive.c          |  142 ++++++++++++++++++++++++-------
 arch/powerpc/kvm/book3s_xive.h          |   17 ++++
 arch/powerpc/kvm/book3s_xive_native.c   |   40 +++------
 6 files changed, 167 insertions(+), 57 deletions(-)

