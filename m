Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC202C5F30
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 05:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392405AbgK0EPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 23:15:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21744 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388685AbgK0EPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 23:15:03 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AR4F2VC025137
        for <stable@vger.kernel.org>; Thu, 26 Nov 2020 20:15:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=nd8TtOAa9xHhX+Sd5SU6lTBEa7NEXDyESd69KLboYpI=;
 b=hBMWXQGdxqjQKsOn3eNr13b0n8cvY2Z/Ozmr4SI5UEfqXCJ3sMbj1EGPgmEP9+d915DX
 lHiAmCWTFBdET9G4iqNL6HtqfkdyC3bcfNSQvIyY/mX4vFpUP94MuW6bHfhHxgLtCKBF
 EYtxF4X9Onn5V7aYPu8pIVmO4BPNW6uWySk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 352s3n05nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 26 Nov 2020 20:15:02 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 26 Nov 2020 20:14:26 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 1FDC9176D279; Thu, 26 Nov 2020 20:14:13 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC:     Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Roman Gushchin <guro@fb.com>, <stable@vger.kernel.org>
Subject: [PATCH] mm: memcg/slab: fix obj_cgroup_charge() return value handling
Date:   Thu, 26 Nov 2020 20:14:05 -0800
Message-ID: <20201127041405.3459198-1-guro@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_01:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=2
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 clxscore=1011
 spamscore=0 mlxlogscore=722 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011270023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches
for all allocations") introduced a regression into the handling of the
obj_cgroup_charge() return value. If a non-zero value is returned
(indicating of exceeding one of memory.max limits), the allocation
should fail, instead of falling back to non-accounted mode.

To make the code more readable, move memcg_slab_pre_alloc_hook()
and memcg_slab_post_alloc_hook() calling conditions into bodies
of these hooks.

Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for=
 all allocations")
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: stable@vger.kernel.org
---
 mm/slab.h | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 59aeb0d9f11b..5dc89d8fb05e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -257,22 +257,32 @@ static inline size_t obj_full_size(struct kmem_cach=
e *s)
 	return s->size + sizeof(struct obj_cgroup *);
 }
=20
-static inline struct obj_cgroup *memcg_slab_pre_alloc_hook(struct kmem_c=
ache *s,
-							   size_t objects,
-							   gfp_t flags)
+/*
+ * Returns true if the allocation should fail.
+ */
+static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+					     struct obj_cgroup **objcgp,
+					     size_t objects, gfp_t flags)
 {
 	struct obj_cgroup *objcg;
=20
+	if (!memcg_kmem_enabled())
+		return false;
+
+	if (!(flags & __GFP_ACCOUNT) && !(s->flags & SLAB_ACCOUNT))
+		return false;
+
 	objcg =3D get_obj_cgroup_from_current();
 	if (!objcg)
-		return NULL;
+		return false;
=20
 	if (obj_cgroup_charge(objcg, flags, objects * obj_full_size(s))) {
 		obj_cgroup_put(objcg);
-		return NULL;
+		return true;
 	}
=20
-	return objcg;
+	*objcgp =3D objcg;
+	return false;
 }
=20
 static inline void mod_objcg_state(struct obj_cgroup *objcg,
@@ -298,7 +308,7 @@ static inline void memcg_slab_post_alloc_hook(struct =
kmem_cache *s,
 	unsigned long off;
 	size_t i;
=20
-	if (!objcg)
+	if (!memcg_kmem_enabled() || !objcg)
 		return;
=20
 	flags &=3D ~__GFP_ACCOUNT;
@@ -382,11 +392,11 @@ static inline void memcg_free_page_obj_cgroups(stru=
ct page *page)
 {
 }
=20
-static inline struct obj_cgroup *memcg_slab_pre_alloc_hook(struct kmem_c=
ache *s,
-							   size_t objects,
-							   gfp_t flags)
+static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+					     struct obj_cgroup **objcgp,
+					     size_t objects, gfp_t flags)
 {
-	return NULL;
+	return false;
 }
=20
 static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
@@ -494,9 +504,8 @@ static inline struct kmem_cache *slab_pre_alloc_hook(=
struct kmem_cache *s,
 	if (should_failslab(s, flags))
 		return NULL;
=20
-	if (memcg_kmem_enabled() &&
-	    ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
-		*objcgp =3D memcg_slab_pre_alloc_hook(s, size, flags);
+	if (memcg_slab_pre_alloc_hook(s, objcgp, size, flags))
+		return NULL;
=20
 	return s;
 }
@@ -515,8 +524,7 @@ static inline void slab_post_alloc_hook(struct kmem_c=
ache *s,
 					 s->flags, flags);
 	}
=20
-	if (memcg_kmem_enabled())
-		memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
+	memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
 }
=20
 #ifndef CONFIG_SLOB
--=20
2.26.2

