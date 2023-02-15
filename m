Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC23697B6D
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 13:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjBOMGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 07:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjBOMGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 07:06:19 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9780E38032
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 04:05:37 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FBDaZ1004650;
        Wed, 15 Feb 2023 12:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Ezz7x3A/ieIM56Kh7EYCtMBIlEorDtrxRmWKHhkJzJA=;
 b=BInskqxicIVWWkkYgHqQARHYe3zAc34mYPrCSLCuF2u6sfdlBKXxH10J6yfYp+22wztH
 2sSJihs9kQWJZr/TcdvuFVtGbMbOqPERjR31BYE3mMp00QJezVPJYTV1pP0pHZ2Jxc5z
 s5ChOC5daN684M3pzAr7eB7wUSvb+HwYAfXICShM3RBD4C9IaRIaxcKejLJgDzpHFKw7
 y/817OfNlG0D8KkX/aEUCxpInAHQmeEFvuqZ/M4VGe4yvxyYnzVjygPW8C3xufvYGBx6
 LdzJljTng6FfAaJorjo7TyiqqkXXK0IHeV60fOy6on838qaHNSf0xnvWzWTRa53QCTTa bg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nrxb1h4r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 12:05:11 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31EK8uYK017578;
        Wed, 15 Feb 2023 12:05:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6nae2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 12:05:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31FC52m924314590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 12:05:02 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BDE92004F;
        Wed, 15 Feb 2023 12:05:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E84C20043;
        Wed, 15 Feb 2023 12:05:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 12:05:01 +0000 (GMT)
From:   Sumanth Korikkar <sumanthk@linux.ibm.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        debian-s390@lists.debian.org, debian-kernel@lists.debian.org
Cc:     svens@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        sumanthk@linux.ibm.com, Ulrich.Weigand@de.ibm.com,
        dipak.zope1@ibm.com
Subject: [PATCH 0/1] s390: fix endless loop in do_signal
Date:   Wed, 15 Feb 2023 13:04:12 +0100
Message-Id: <20230215120413.949348-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jOQPLFuqx9lsEJPfOal6cE-WZDbUxnKV
X-Proofpoint-GUID: jOQPLFuqx9lsEJPfOal6cE-WZDbUxnKV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_06,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 mlxlogscore=860 spamscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This patch fixes the issue for s390  stable kernel starting  5.10.162.
The issue was specifically seen after stable version 5.10.162:
Following commits can trigger it:
1. stable commit id - 788d0824269b ("io_uring: import 5.15-stable
io_uring") can trigger this problem.
2. upstream commit id - 75309018a24d ("s390: add support for
TIF_NOTIFY_SIGNAL")

Problem:
qemu and user processes could stall when TIF_NOTIFY_SIGNAL is set from
io_uring work.

Affected users:
The issue was first raised by the debian team, where the s390
bullseye build systems are affected.

Upstream commit Id:
* The attached patch has no upstream commit. However, the stable kernel
5.10.162+ uses upstream commit id - 75309018a24d ("s390: add support for
TIF_NOTIFY_SIGNAL"), which would need this fix
* Starting from v5.12, there are s390 generic entry commits 
56e62a737028 ("s390: convert to generic entry")  and its relevant fixes,
which are recommended and should address these problems.

Kernel version to be applied:
stable kernel 5.10.162+

Thanks.
Sumanth

Sumanth Korikkar (1):
  s390/signal: fix endless loop in do_signal

 arch/s390/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.37.2

