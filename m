Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D84604179
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiJSKoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbiJSKoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:44:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED3F9411F;
        Wed, 19 Oct 2022 03:20:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21B12B823B8;
        Wed, 19 Oct 2022 08:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DEDC433C1;
        Wed, 19 Oct 2022 08:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169621;
        bh=A/aO55xe4WmqYijgeMiod1WeF6BH4BkxrGnVD4eeRn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckLRt+RgrNYpZGkQiOVFDUISVJJzZtKvFNdNcCubbQemJmgsnngGVW+CXQqP4t2BI
         ukyNZ2kcvhiOIjrRs0TVJYBJRaKW6mCvvoxPIacgMfJHO0fEwfqF35QvI2b4Z+c40q
         n8gxx3+TDsahGV9cea9jRCCudBsOIomUMpZm/3yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pu Lehui <pulehui@huawei.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 302/862] bpf, cgroup: Reject prog_attach_flags array when effective query
Date:   Wed, 19 Oct 2022 10:26:29 +0200
Message-Id: <20221019083303.339950744@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 0e426a3ae030a9e891899370229e117158b35de6 ]

Attach flags is only valid for attached progs of this layer cgroup,
but not for effective progs. For querying with EFFECTIVE flags,
exporting attach flags does not make sense. So when effective query,
we reject prog_attach_flags array and don't need to populate it.
Also we limit attach_flags to output 0 during effective query.

Fixes: b79c9fc9551b ("bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/r/20220921104604.2340580-2-pulehui@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       |  7 +++++--
 kernel/bpf/cgroup.c            | 28 ++++++++++++++++++----------
 tools/include/uapi/linux/bpf.h |  7 +++++--
 3 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 59a217ca2dfd..4eff7fc7ae58 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1233,7 +1233,7 @@ enum {
 
 /* Query effective (directly attached + inherited from ancestor cgroups)
  * programs that will be executed for events within a cgroup.
- * attach_flags with this flag are returned only for directly attached programs.
+ * attach_flags with this flag are always returned 0.
  */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
 
@@ -1432,7 +1432,10 @@ union bpf_attr {
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
-		__aligned_u64	prog_attach_flags; /* output: per-program attach_flags */
+		/* output: per-program attach_flags.
+		 * not allowed to be set during effective query.
+		 */
+		__aligned_u64	prog_attach_flags;
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 4a400cd63731..22888aaa68b6 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1020,6 +1020,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 			      union bpf_attr __user *uattr)
 {
 	__u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
+	bool effective_query = attr->query.query_flags & BPF_F_QUERY_EFFECTIVE;
 	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
 	enum bpf_attach_type type = attr->query.attach_type;
 	enum cgroup_bpf_attach_type from_atype, to_atype;
@@ -1029,8 +1030,12 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	int total_cnt = 0;
 	u32 flags;
 
+	if (effective_query && prog_attach_flags)
+		return -EINVAL;
+
 	if (type == BPF_LSM_CGROUP) {
-		if (attr->query.prog_cnt && prog_ids && !prog_attach_flags)
+		if (!effective_query && attr->query.prog_cnt &&
+		    prog_ids && !prog_attach_flags)
 			return -EINVAL;
 
 		from_atype = CGROUP_LSM_START;
@@ -1045,7 +1050,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	}
 
 	for (atype = from_atype; atype <= to_atype; atype++) {
-		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
+		if (effective_query) {
 			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
 							      lockdep_is_held(&cgroup_mutex));
 			total_cnt += bpf_prog_array_length(effective);
@@ -1054,6 +1059,8 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		}
 	}
 
+	/* always output uattr->query.attach_flags as 0 during effective query */
+	flags = effective_query ? 0 : flags;
 	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
 		return -EFAULT;
 	if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
@@ -1068,7 +1075,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	}
 
 	for (atype = from_atype; atype <= to_atype && total_cnt; atype++) {
-		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
+		if (effective_query) {
 			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
 							      lockdep_is_held(&cgroup_mutex));
 			cnt = min_t(int, bpf_prog_array_length(effective), total_cnt);
@@ -1090,15 +1097,16 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 				if (++i == cnt)
 					break;
 			}
-		}
 
-		if (prog_attach_flags) {
-			flags = cgrp->bpf.flags[atype];
+			if (prog_attach_flags) {
+				flags = cgrp->bpf.flags[atype];
 
-			for (i = 0; i < cnt; i++)
-				if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
-					return -EFAULT;
-			prog_attach_flags += cnt;
+				for (i = 0; i < cnt; i++)
+					if (copy_to_user(prog_attach_flags + i,
+							 &flags, sizeof(flags)))
+						return -EFAULT;
+				prog_attach_flags += cnt;
+			}
 		}
 
 		prog_ids += cnt;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 59a217ca2dfd..4eff7fc7ae58 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1233,7 +1233,7 @@ enum {
 
 /* Query effective (directly attached + inherited from ancestor cgroups)
  * programs that will be executed for events within a cgroup.
- * attach_flags with this flag are returned only for directly attached programs.
+ * attach_flags with this flag are always returned 0.
  */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
 
@@ -1432,7 +1432,10 @@ union bpf_attr {
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
-		__aligned_u64	prog_attach_flags; /* output: per-program attach_flags */
+		/* output: per-program attach_flags.
+		 * not allowed to be set during effective query.
+		 */
+		__aligned_u64	prog_attach_flags;
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
-- 
2.35.1



