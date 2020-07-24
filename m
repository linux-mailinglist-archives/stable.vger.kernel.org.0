Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E9822BAF0
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 02:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgGXAVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 20:21:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41105 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbgGXAVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 20:21:32 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200724002129epoutp02861036681b634ec7a4abad713f04e60e~kiFpX0ZIS1521015210epoutp02d
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 00:21:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200724002129epoutp02861036681b634ec7a4abad713f04e60e~kiFpX0ZIS1521015210epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595550089;
        bh=iRE8yoiUeWQPc0mQXMAxrH0UqxBmT1m5KtC7jB604js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m340nN6SU9BdmGBSO6j6JYf820MOSuEqzCVlV9BkpEdk4o3xgsKUNQEA0LXF+8kC5
         jJ28lSyFsZhypn/f5DqvkVmVGnfO7EJs4b35I6UE6+JtiqIqiTI68Dzg0wqwVh8PAS
         39oM9Gec1ZAItbuoT/ZbcyEYNqXc/K0XgMDmbXis=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20200724002127epcas1p4ff58726311838c3788830e87aad3ac1b~kiFnNXjMU3036830368epcas1p4T;
        Fri, 24 Jul 2020 00:21:27 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.162]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4BCVHV0L4CzMqYkk; Fri, 24 Jul
        2020 00:21:26 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.D0.18978.5892A1F5; Fri, 24 Jul 2020 09:21:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200724002124epcas1p2b7fe53394e20e4dccc23e61e2a82b828~kiFkfF_ww2758927589epcas1p2K;
        Fri, 24 Jul 2020 00:21:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200724002124epsmtrp12b9c244e09acd35b68dd52554b36f604~kiFkayS5p3234632346epsmtrp1D;
        Fri, 24 Jul 2020 00:21:24 +0000 (GMT)
X-AuditID: b6c32a35-603ff70000004a22-f9-5f1a2985ea81
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.30.08303.4892A1F5; Fri, 24 Jul 2020 09:21:24 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200724002124epsmtip21a36add9b227975a83c5bca449a244ec~kiFkSBsHr0522305223epsmtip2s;
        Fri, 24 Jul 2020 00:21:24 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, Ilya Ponetayev <i.ponetaev@ndmsystems.com>,
        Chen Minqiang <ptpt52@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7.y 4/4] exfat: fix name_hash computation on big endian
 systems
Date:   Fri, 24 Jul 2020 09:15:44 +0900
Message-Id: <20200724001544.30862-5-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724001544.30862-1-namjae.jeon@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsWy7bCmgW6rplS8waSlohbNi9ezWaz+9Ynd
        4sf0eov93z8zWmxac43NYsHGR4wObB47Z91l99i0qpPNY//cNeweqzunMnr0bVnF6PF5k1wA
        W1SOTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
        ZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScAkODAr3ixNzi0rx0veT8XCtDAwMjU6DK
        hJyM1x8WMhb8469YtPMQSwPjXN4uRk4OCQETiXW9X5m7GLk4hAR2MEpcaJvDAuF8YpS4uGs3
        G4TzmVHi9MU9zDAtb7ruQFXtYpSYd2UvI1zLm6s7mboYOTjYBLQl/mwRBWkQETCUuPH5GlgD
        s8BERolTV14xgiSEBYIlzt85xQpiswioSnxd840RpJdXwEZi4atoiGXyEqs3HABbzClgK7H8
        71EWiPgxdonVsxghbBeJDc/2QMWFJV4d38IOYUtJvOxvYwcZKSFQLfFxP9T9HYwSL77bQtjG
        EjfXb2AFKWEW0JRYv0sfIqwosfP3XLDpzAJ8Eu++9rBCTOGV6GgTgihRlei7dJgJwpaW6Gr/
        ALXUQ+LGmuvQYJvAKHHo53HWCYxysxA2LGBkXMUollpQnJueWmxYYIgcX5sYwYlMy3QH48S3
        H/QOMTJxMB5ilOBgVhLh1WEUjxfiTUmsrEotyo8vKs1JLT7EaAoMuYnMUqLJ+cBUmlcSb2hq
        ZGxsbGFiZm5maqwkzvvvLHu8kEB6YklqdmpqQWoRTB8TB6dUA9MDy6Lbi497qOmoKj6LepaW
        ++zAXL4LyyTXW+uY/E4V5pBdpOAh+CY3/FbypWWFR6ZyqT6bqhR6PdE1ei2bEfvLXz8dPaWE
        hC4bL9x69PVuY8FV7s/1XjaFnNjsIbx9y+nT7S3pfTyzwg57TJ2RfMB9x56+2+kGW/9q9WqF
        LVjSqsWVZpHepG2/X3Jmnt7Vg10tjq2XmQ9/CK8/dMKP7YbOeb/jQlt43vXqnFPePvlZk14r
        m4RXjTTLhgnLb3yx5fQxrP7HLtB/hJOVr8G3f/W9mKz3mjLcB2vn3M2dWc/60Tee7yQru9HH
        bYlXXnO0C4ivKbDruv8lR+3hIftODd+mjRwFrVUzGl/tbvv7TImlOCPRUIu5qDgRAPdqwSLt
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsWy7bCSvG6LplS8Qe9bXovmxevZLFb/+sRu
        8WN6vcX+758ZLTatucZmsWDjI0YHNo+ds+6ye2xa1cnmsX/uGnaP1Z1TGT36tqxi9Pi8SS6A
        LYrLJiU1J7MstUjfLoEr4/WHhYwF//grFu08xNLAOJe3i5GTQ0LAROJN1x2WLkYuDiGBHYwS
        +14tZ4NISEscO3GGuYuRA8gWljh8uBii5gOjxLrzvYwgcTYBbYk/W0RBTBEBY4n2r2UgJcwC
        Uxkl7v68wAoyRlggUOJ2xyFmEJtFQFXi65pvYK28AjYSC19FQ2ySl1i94QBYCaeArcTyv0dZ
        QGwhoJKZ33cyTmDkW8DIsIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzjctLR2MO5Z
        9UHvECMTB+MhRgkOZiURXh1G8Xgh3pTEyqrUovz4otKc1OJDjNIcLErivF9nLYwTEkhPLEnN
        Tk0tSC2CyTJxcEo1MPk+y536dZqWx/oJm42YXjLvYFNZopWzu/q9YJj8muPfZ8fc8121vFAy
        S+DcyVnxtkf6dUIfxXKIi93Lub1UUPxE5rfIiXk/ikz1qxye/pXadn7DpRn31FmrY+8I7M+7
        1S6m+/TAkmvLNxpElBbcfBv08+mMEmXVZxJuJ7q//93JL3t4gs6UdTtnz2z2XMkXUN0VGbRy
        Ummjw5V7WfcOuq/7nFle27KzM8RQcuGmsv5XZu2c7kv/h0YIzrPrNf2+1GfClw+nqph3FWmx
        HcgWXFc2oYRXXUH6UH6ZbO7KSf4Lv9R1HLgVflap9yNTnPWZBdJn3ereWH+RMnS/LlXz5TBX
        3ST+CgORs9HGzVJP/JVYijMSDbWYi4oTAXxuH/2mAgAA
X-CMS-MailID: 20200724002124epcas1p2b7fe53394e20e4dccc23e61e2a82b828
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200724002124epcas1p2b7fe53394e20e4dccc23e61e2a82b828
References: <20200724001544.30862-1-namjae.jeon@samsung.com>
        <CGME20200724002124epcas1p2b7fe53394e20e4dccc23e61e2a82b828@epcas1p2.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Ponetayev <i.ponetaev@ndmsystems.com>

[ Upstream commit db415f7aae07cadcabd5d2a659f8ad825c905299 ]

On-disk format for name_hash field is LE, so it must be explicitly
transformed on BE system for proper result.

Fixes: 370e812b3ec1 ("exfat: add nls operations")
Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Chen Minqiang <ptpt52@gmail.com>
Signed-off-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/nls.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 6d1c3ae130ff..a647f8127f3b 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -495,7 +495,7 @@ static int exfat_utf8_to_utf16(struct super_block *sb,
 		struct exfat_uni_name *p_uniname, int *p_lossy)
 {
 	int i, unilen, lossy = NLS_NAME_NO_LOSSY;
-	unsigned short upname[MAX_NAME_LENGTH + 1];
+	__le16 upname[MAX_NAME_LENGTH + 1];
 	unsigned short *uniname = p_uniname->name;
 
 	WARN_ON(!len);
@@ -523,7 +523,7 @@ static int exfat_utf8_to_utf16(struct super_block *sb,
 		    exfat_wstrchr(bad_uni_chars, *uniname))
 			lossy |= NLS_NAME_LOSSY;
 
-		upname[i] = exfat_toupper(sb, *uniname);
+		upname[i] = cpu_to_le16(exfat_toupper(sb, *uniname));
 		uniname++;
 	}
 
@@ -614,7 +614,7 @@ static int exfat_nls_to_ucs2(struct super_block *sb,
 		struct exfat_uni_name *p_uniname, int *p_lossy)
 {
 	int i = 0, unilen = 0, lossy = NLS_NAME_NO_LOSSY;
-	unsigned short upname[MAX_NAME_LENGTH + 1];
+	__le16 upname[MAX_NAME_LENGTH + 1];
 	unsigned short *uniname = p_uniname->name;
 	struct nls_table *nls = EXFAT_SB(sb)->nls_io;
 
@@ -628,7 +628,7 @@ static int exfat_nls_to_ucs2(struct super_block *sb,
 		    exfat_wstrchr(bad_uni_chars, *uniname))
 			lossy |= NLS_NAME_LOSSY;
 
-		upname[unilen] = exfat_toupper(sb, *uniname);
+		upname[unilen] = cpu_to_le16(exfat_toupper(sb, *uniname));
 		uniname++;
 		unilen++;
 	}
-- 
2.17.1

