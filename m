Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEA81F1D93
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 18:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbgFHQln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 12:41:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14124 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730571AbgFHQln (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 12:41:43 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058GXntX134362;
        Mon, 8 Jun 2020 12:41:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g7p4cdmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 12:41:21 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 058GYor0144497;
        Mon, 8 Jun 2020 12:41:20 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g7p4cdkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 12:41:20 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 058GeJ9p010781;
        Mon, 8 Jun 2020 16:41:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 31g2s81rea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 16:41:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 058GfFq226083364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 16:41:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E521E5204E;
        Mon,  8 Jun 2020 16:41:14 +0000 (GMT)
Received: from oc3871087118.ibm.com (unknown [9.145.56.93])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0A02F52050;
        Mon,  8 Jun 2020 16:41:14 +0000 (GMT)
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v2] lib: fix bitmap_parse() on 64-bit big endian archs
Date:   Mon,  8 Jun 2020 18:41:11 +0200
Message-Id: <1591634471-17647-1-git-send-email-agordeev@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_14:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 malwarescore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=999 impostorscore=0 suspectscore=1 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080117
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 2d6261583be0 ("lib: rework bitmap_parse()") does not
take into account order of halfwords on 64-bit big endian
architectures. As result (at least) Receive Packet Steering,
IRQ affinity masks and runtime kernel test "test_bitmap" get
broken on s390.

Fixes: 2d6261583be0 ("lib: rework bitmap_parse()")
Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "Tobin C . Harding" <tobin@kernel.org>
Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 lib/bitmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 89260aa342d6..80d26b183248 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -739,6 +739,7 @@ int bitmap_parse(const char *start, unsigned int buflen,
 	const char *end = strnchrnul(start, buflen, '\n') - 1;
 	int chunks = BITS_TO_U32(nmaskbits);
 	u32 *bitmap = (u32 *)maskp;
+	int chunk = 0;
 	int unset_bit;
 
 	while (1) {
@@ -749,9 +750,14 @@ int bitmap_parse(const char *start, unsigned int buflen,
 		if (!chunks--)
 			return -EOVERFLOW;
 
-		end = bitmap_get_x32_reverse(start, end, bitmap++);
+#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
+		end = bitmap_get_x32_reverse(start, end, &bitmap[chunk ^ 1]);
+#else
+		end = bitmap_get_x32_reverse(start, end, &bitmap[chunk]);
+#endif
 		if (IS_ERR(end))
 			return PTR_ERR(end);
+		chunk++;
 	}
 
 	unset_bit = (BITS_TO_U32(nmaskbits) - chunks) * 32;
-- 
2.23.0

