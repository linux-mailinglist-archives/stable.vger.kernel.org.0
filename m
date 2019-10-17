Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855A8DA520
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 07:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392353AbfJQF07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 01:26:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45742 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392044AbfJQF06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 01:26:58 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9H5MKBH091699
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 01:26:57 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vpfcy43nu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 01:26:57 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <sandipan@linux.ibm.com>;
        Thu, 17 Oct 2019 06:26:55 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 17 Oct 2019 06:26:53 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9H5QpK526804464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Oct 2019 05:26:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAABFAE058;
        Thu, 17 Oct 2019 05:26:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F3EAAE053;
        Thu, 17 Oct 2019 05:26:50 +0000 (GMT)
Received: from tpad450.ibmuc.com (unknown [9.199.40.180])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Oct 2019 05:26:50 +0000 (GMT)
From:   Sandipan Das <sandipan@linux.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        mpe@ellerman.id.au, desnesn@linux.ibm.com
Subject: [PATCH stable 4.19 3/3] selftests/powerpc: Fix compile error on tlbie_test due to newer gcc
Date:   Thu, 17 Oct 2019 10:56:44 +0530
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191017052644.7068-1-sandipan@linux.ibm.com>
References: <20191017052644.7068-1-sandipan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19101705-4275-0000-0000-00000372CEC7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101705-4276-0000-0000-00003885E602
Message-Id: <20191017052644.7068-3-sandipan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-17_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910170042
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Desnes A. Nunes do Rosario" <desnesn@linux.ibm.com>

commit 5b216ea1c40cf06eead15054c70e238c9bd4729e upstream.

Newer versions of GCC (>= 9) demand that the size of the string to be
copied must be explicitly smaller than the size of the destination.
Thus, the NULL char has to be taken into account on strncpy.

This will avoid the following compiling error:

  tlbie_test.c: In function 'main':
  tlbie_test.c:639:4: error: 'strncpy' specified bound 100 equals destination size
      strncpy(logdir, optarg, LOGDIR_NAME_SIZE);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors

Cc: stable@vger.kernel.org # v4.19
Signed-off-by: Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191003211010.9711-1-desnesn@linux.ibm.com
[sandipan: Backported to v4.19]
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
---
 tools/testing/selftests/powerpc/mm/tlbie_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/mm/tlbie_test.c b/tools/testing/selftests/powerpc/mm/tlbie_test.c
index 9868a5ddd847..f85a0938ab25 100644
--- a/tools/testing/selftests/powerpc/mm/tlbie_test.c
+++ b/tools/testing/selftests/powerpc/mm/tlbie_test.c
@@ -636,7 +636,7 @@ int main(int argc, char *argv[])
 			nrthreads = strtoul(optarg, NULL, 10);
 			break;
 		case 'l':
-			strncpy(logdir, optarg, LOGDIR_NAME_SIZE);
+			strncpy(logdir, optarg, LOGDIR_NAME_SIZE - 1);
 			break;
 		case 't':
 			run_time = strtoul(optarg, NULL, 10);
-- 
2.21.0

