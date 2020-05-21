Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D101DD8E4
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 22:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgEUUxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 16:53:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52782 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728778AbgEUUxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 16:53:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LKpsJb133890;
        Thu, 21 May 2020 20:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Ogud8yih6ya3Tg8fEr/UNbZL5KsSyWKJmPKOQAWvElw=;
 b=qqd2exmncDxYKFo40T5sBtejpGzOaTCr4swxzlSA709opqALw3lgnnylQ0Mkrn+UwofP
 7hsmSAPpyCsTfOT5r6NzXK5klMsp5Eo9qr2prRjyxj32QDGCKY5GbLoQShmHWr/xgSb6
 Q/IYlmy2+ZJbB2lFUmlzzwNGwguMj1U6XsZ1DAwvbcZIpuI8/Pf0va33glwsJVJ4OIQs
 /uzzYx1GzC1g06yJdfZuG3Vgl15Cf/8tgUvMYIWl3Ow7SJTB/venMoor+iv30JsAsOp8
 JlThT8zPwRqfNXnTa5ln779xCWa2MK/TJJLhM0yoq/PvE44FyQy1LY/VoJbzH5b1VD96 aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284maphu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 20:51:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LKiZHx046579;
        Thu, 21 May 2020 20:51:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gm9wyw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 20:51:53 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04LKppvd002510;
        Thu, 21 May 2020 20:51:51 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 13:51:51 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mathias Krause <minipli@googlemail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [stable-4.4 2/5] sched/fair, cpumask: Export for_each_cpu_wrap()
Date:   Thu, 21 May 2020 16:51:42 -0400
Message-Id: <20200521205145.1953392-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521205145.1953392-1-daniel.m.jordan@oracle.com>
References: <20200521205145.1953392-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005210154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005210155
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit c743f0a5c50f2fcbc628526279cfa24f3dabe182 ]

More users for for_each_cpu_wrap() have appeared. Promote the construct
to generic cpumask interface.

The implementation is slightly modified to reduce arguments.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Lauro Ramos Venancio <lvenanci@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: lwang@redhat.com
Link: http://lkml.kernel.org/r/20170414122005.o35me2h5nowqkxbv@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[dj: include only what's added to the cpumask interface, 4.4 doesn't
     have them in the scheduler]
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 include/linux/cpumask.h | 17 +++++++++++++++++
 lib/cpumask.c           | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index bb3a4bb35183..1322883e7b46 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -232,6 +232,23 @@ unsigned int cpumask_local_spread(unsigned int i, int node);
 		(cpu) = cpumask_next_zero((cpu), (mask)),	\
 		(cpu) < nr_cpu_ids;)
 
+extern int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap);
+
+/**
+ * for_each_cpu_wrap - iterate over every cpu in a mask, starting at a specified location
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask: the cpumask poiter
+ * @start: the start location
+ *
+ * The implementation does not assume any bit in @mask is set (including @start).
+ *
+ * After the loop, cpu is >= nr_cpu_ids.
+ */
+#define for_each_cpu_wrap(cpu, mask, start)					\
+	for ((cpu) = cpumask_next_wrap((start)-1, (mask), (start), false);	\
+	     (cpu) < nr_cpumask_bits;						\
+	     (cpu) = cpumask_next_wrap((cpu), (mask), (start), true))
+
 /**
  * for_each_cpu_and - iterate over every cpu in both masks
  * @cpu: the (optionally unsigned) integer iterator
diff --git a/lib/cpumask.c b/lib/cpumask.c
index 5a70f6196f57..24f06e7abf92 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -42,6 +42,38 @@ int cpumask_any_but(const struct cpumask *mask, unsigned int cpu)
 	return i;
 }
 
+/**
+ * cpumask_next_wrap - helper to implement for_each_cpu_wrap
+ * @n: the cpu prior to the place to search
+ * @mask: the cpumask pointer
+ * @start: the start point of the iteration
+ * @wrap: assume @n crossing @start terminates the iteration
+ *
+ * Returns >= nr_cpu_ids on completion
+ *
+ * Note: the @wrap argument is required for the start condition when
+ * we cannot assume @start is set in @mask.
+ */
+int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap)
+{
+	int next;
+
+again:
+	next = cpumask_next(n, mask);
+
+	if (wrap && n < start && next >= start) {
+		return nr_cpumask_bits;
+
+	} else if (next >= nr_cpumask_bits) {
+		wrap = true;
+		n = -1;
+		goto again;
+	}
+
+	return next;
+}
+EXPORT_SYMBOL(cpumask_next_wrap);
+
 /* These are not inline because of header tangles. */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 /**
-- 
2.26.2

