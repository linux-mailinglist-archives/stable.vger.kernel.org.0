Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BC52650E4
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 22:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgIJUf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 16:35:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4712 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgIJUd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 16:33:27 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AKVq3n007916
        for <stable@vger.kernel.org>; Thu, 10 Sep 2020 13:33:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ylkNWm6vTtLh/RoObbSI3QJcpP1ZOVZUqQdI4iq5gF4=;
 b=HOD+FKMKVZdqCqNyoMo8gqxAYDuDef+gBli435XEvWfZXU3mjALhBN52Od+sHpHgDKea
 kxBnoDQhDjGKEZxj/c51rmpK3vNc0tJXGvl0pHX+UyBpb7lg6fQSXojRq+msAliCaLfB
 UyUSiY1cTysCXAxx/yOHpousdTzR/BVa1rg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33f8bfdevt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 10 Sep 2020 13:33:24 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Sep 2020 13:33:23 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 4659C62E5379; Thu, 10 Sep 2020 13:33:18 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Song Liu <songliubraving@fb.com>, <stable@vger.kernel.org>
Subject: [PATCH bpf-next] bpf: fix comment for helper bpf_current_task_under_cgroup()
Date:   Thu, 10 Sep 2020 13:33:14 -0700
Message-ID: <20200910203314.70018-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_09:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=682 suspectscore=13 clxscore=1011
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009100184
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This should be "current" not "skb".

Fixes: c6b5fb8690fa ("bpf: add documentation for eBPF helpers (42-50)")
Cc: <stable@vger.kernel.org>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/uapi/linux/bpf.h       | 4 ++--
 tools/include/uapi/linux/bpf.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 90359cab501d1..7dd314176df76 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1447,8 +1447,8 @@ union bpf_attr {
  * 	Return
  * 		The return value depends on the result of the test, and can be:
  *
- * 		* 0, if the *skb* task belongs to the cgroup2.
- * 		* 1, if the *skb* task does not belong to the cgroup2.
+ *		* 0, if current task belongs to the cgroup2.
+ *		* 1, if current task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
  * long bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 90359cab501d1..7dd314176df76 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1447,8 +1447,8 @@ union bpf_attr {
  * 	Return
  * 		The return value depends on the result of the test, and can be:
  *
- * 		* 0, if the *skb* task belongs to the cgroup2.
- * 		* 1, if the *skb* task does not belong to the cgroup2.
+ *		* 0, if current task belongs to the cgroup2.
+ *		* 1, if current task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
  * long bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
--=20
2.24.1

