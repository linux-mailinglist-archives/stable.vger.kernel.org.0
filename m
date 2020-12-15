Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F2B2DAA9A
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 11:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgLOKGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 05:06:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725890AbgLOKGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 05:06:39 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BFA1K23176476;
        Tue, 15 Dec 2020 05:05:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vg5nrvOnbBXg3RgxIUAr+F3NUfz7AVogdR11eVRzOtw=;
 b=E3sYiFkPkk6iPrpxN4gcAlqF68odThuy9LxRQZBGtXPGmnj9CmQrzU3GwQx+mevFom2X
 D5g0JD9v0WqyJ7dnKq8x5XK76at5LDduXNvq2j8sseWv/GnSkSDrzPG5sw57S/0UvYW5
 b2/6yIUHetY+I2ZRlSH3Tc2JGRkatMavufR3LLgLN+B1kK6x7eD+7/VuFqom3w1XivxS
 oJsK6ZU50exciKukdVW/ppUKlBwZpXZ136XCPkVvhGb8m/4GoZwbA/hlBYKsBorhPFNn
 g7JsBI8yoyCepUvN+Lkz2LHYZHfzjFKAsUbir3a4mAIxW/onRc0DxV0pA9cnn6dZCCVJ 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35esxd2egb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 05:05:32 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BFA2CEX180944;
        Tue, 15 Dec 2020 05:05:31 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35esxd2efd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 05:05:31 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BF9vRvj000727;
        Tue, 15 Dec 2020 10:05:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8cm2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 10:05:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BFA49mv63439168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 10:04:09 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38288A405C;
        Tue, 15 Dec 2020 10:04:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA538A4060;
        Tue, 15 Dec 2020 10:04:06 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.199.60.199])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Dec 2020 10:04:06 +0000 (GMT)
From:   Harish <harish@linux.ibm.com>
To:     shuah@kernel.org, akpm@linux-foundation.org,
        sandipan@linux.ibm.com, jhubbard@nvidia.com, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, bgeffon@google.com,
        almasrymina@google.com, suxingxing@loongson.cn
Cc:     Harish <harish@linux.ibm.com>, linux-kselftest@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] selftests/vm: Fix building protection keys test
Date:   Tue, 15 Dec 2020 15:34:02 +0530
Message-Id: <20201215100402.257376-1-harish@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_08:2020-12-11,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1011 mlxlogscore=999
 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150067
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch d8cbe8bfa7d tries to include a ARCH check for powerpc,
however ARCH is not defined in the Makefile before including
lib.mk. This makes test building to skip on both x86 and powerpc.
Fix the arch check by replacing it using machine type as it is
already defined and used in the test.

Fixes: d8cbe8bfa7d ("tools/testing/selftests/vm: fix build error")
Signed-off-by: Harish <harish@linux.ibm.com>
---

Changes from v1:
 - Add cause for test skip
 - Handle x86_64 architecture
 - Minor fixes to handle ppc64/ppc64le
 - Add Fixes tag
---
 tools/testing/selftests/vm/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 691893afc15d..e63f31632708 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm selftests
 uname_M := $(shell uname -m 2>/dev/null || echo not)
-MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/')
+MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/ppc64/')
 
 # Without this, failed build products remain, with up-to-date timestamps,
 # thus tricking Make (and you!) into believing that All Is Well, in subsequent
@@ -39,7 +39,7 @@ TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 TEST_GEN_FILES += khugepaged
 
-ifeq ($(ARCH),x86_64)
+ifeq ($(MACHINE),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_32bit_program.c -m32)
 CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_64bit_program.c)
 CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_program.c -no-pie)
@@ -61,13 +61,13 @@ TEST_GEN_FILES += $(BINARIES_64)
 endif
 else
 
-ifneq (,$(findstring $(ARCH),powerpc))
+ifneq (,$(findstring $(MACHINE),ppc64))
 TEST_GEN_FILES += protection_keys
 endif
 
 endif
 
-ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64))
+ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sh64 sparc64 x86_64))
 TEST_GEN_FILES += va_128TBswitch
 TEST_GEN_FILES += virtual_address_range
 TEST_GEN_FILES += write_to_hugetlbfs
@@ -82,7 +82,7 @@ include ../lib.mk
 
 $(OUTPUT)/hmm-tests: LDLIBS += -lhugetlbfs -lpthread
 
-ifeq ($(ARCH),x86_64)
+ifeq ($(MACHINE),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
 BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
 
-- 
2.26.2

