Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC584225F8
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 14:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbhJEMKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 08:10:40 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3933 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbhJEMKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 08:10:40 -0400
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HNx9X6B9Yz67b9p;
        Tue,  5 Oct 2021 20:05:20 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 14:08:47 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <hca@linux.ibm.com>, <gor@linux.ibm.com>, <borntraeger@de.ibm.com>
CC:     <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] s390: Fix strrchr() implementation
Date:   Tue, 5 Oct 2021 14:08:36 +0200
Message-ID: <20211005120836.60630-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix two problems found in the strrchr() implementation for s390
architectures: evaluate empty strings (return the string address instead of
NULL, if '\0' is passed as second argument); evaluate the first character
of non-empty strings (the current implementation stops at the second).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Heiko Carstens <hca@linux.ibm.com> (incorrect behavior with empty strings)
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 arch/s390/lib/string.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/s390/lib/string.c b/arch/s390/lib/string.c
index cfcdf76d6a95..8127e110d154 100644
--- a/arch/s390/lib/string.c
+++ b/arch/s390/lib/string.c
@@ -259,14 +259,13 @@ EXPORT_SYMBOL(strcmp);
 #ifdef __HAVE_ARCH_STRRCHR
 char *strrchr(const char *s, int c)
 {
-       size_t len = __strend(s) - s;
-
-       if (len)
-	       do {
-		       if (s[len] == (char) c)
-			       return (char *) s + len;
-	       } while (--len > 0);
-       return NULL;
+	size_t len = __strend(s) - s;
+
+	do {
+		if (s[len] == (char) c)
+			return (char *) s + len;
+	} while (--len >= 0);
+	return NULL;
 }
 EXPORT_SYMBOL(strrchr);
 #endif
-- 
2.32.0

