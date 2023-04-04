Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D876D6E68
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 22:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbjDDUu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 16:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbjDDUuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 16:50:25 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2434C25;
        Tue,  4 Apr 2023 13:50:24 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id ix20so32518178plb.3;
        Tue, 04 Apr 2023 13:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680641423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lglI8SHFdENU7LxVGQcu2UFVz8VugpbHJeSn7gO+RPc=;
        b=Nrw6i/FJkS+fqTHL9se7KaV8CBQ8xPVRt4LMvU2Do9i/mTfZSgWVYiqA/pz4ECapQQ
         tCpnUOnnfw0CQgEFR/FRbB9ejV68iU6P0vReR7IiHWMWh7XWRvd/zt3D7oPfgKzu8ZVL
         PFBGzhqG/eQ1Wg6dC/pz5EitUrx3E0FtWzBZHDob4owJKiqepla9rrMevQICz2jTD6sB
         IxCbiS3TOw5KrDKlwAMI7w2UXHiOSgdPeq6lxmP+5+46AFNq0b6/co31Vf/ozknj+8zJ
         x1LZzrI54HRvbU9F97DUHeoGyEX15x6ETRsdEZyk/TEk+xCTpDfq4O7jGHmFkSr5In1k
         FRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680641423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lglI8SHFdENU7LxVGQcu2UFVz8VugpbHJeSn7gO+RPc=;
        b=ZzNcOg0l55KuBHStiSkxAWJ5pitgMY5BT93oTM+8qbvsE+5Jc19EYhxJKVf/tpE5K3
         MCd0eENVb+7Oy0nEIvA/eCv64eFSX+mGWnxloyv5KyYkVmpKosJbMSe24Sy2rsN535BP
         kDZLMNdpwYt8ZyMwzm3lfyKl0rMuk7X/f6lYWAFqlMfuFfXJfdX9Guj+bkcM0nwBFF1Q
         2MyltgG6dP31ecckpRnsJhQ8rWcqMAFzpT+2P+UtL6l4RaC+fT8QrG+EE7XnQYuzIXtS
         2gDGl1p8AnrrkhBy1lfGecHv3t1cYO13kViszZDUTor+RAojRgTogdUaiD70bYH/5yHP
         wQ1Q==
X-Gm-Message-State: AAQBX9fDT5VNtuY/jYyru6aDkygI1T862rmUgJ881QWMzhIOEwtkc9N9
        GOd2u6SdGGwXXbYeofxXREqldmcFpqCO+QUL
X-Google-Smtp-Source: AKy350YCVMZqXw6ZiGurBjzNmoYBsAbAsOz/1gvcWpAAID0BsOihl1waiyFK0dykig976XfgWdUntw==
X-Received: by 2002:a17:903:244f:b0:1a1:ce5d:5a15 with SMTP id l15-20020a170903244f00b001a1ce5d5a15mr4998933pls.50.1680641423186;
        Tue, 04 Apr 2023 13:50:23 -0700 (PDT)
Received: from lunar.aeonazure.com ([182.2.143.216])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902728900b0019f2328bef8sm8818551pll.34.2023.04.04.13.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 13:50:22 -0700 (PDT)
From:   Shaun Tancheff <shaun.tancheff@gmail.com>
To:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     Shaun Tancheff <shaun.tancheff@hpe.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] memcg-v1: Enable setting memory min, low, high
Date:   Wed,  5 Apr 2023 03:50:13 +0700
Message-Id: <20230404205013.31520-1-shaun.tancheff@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaun Tancheff <shaun.tancheff@hpe.com>

For users that are unable to update to memcg-v2 this
provides a method where memcg-v1 can more effectively
apply enough memory pressure to effectively throttle
filesystem I/O or otherwise minimize being memcg oom
killed at the expense of reduced performance.

This patch extends the memcg-v1 legacy sysfs entries
with:
    limit_in_bytes.min, limit_in_bytes.low and
    limit_in_bytes.high
Since old software will need to be updated to take
advantage of the new files a secondary method
of setting min, low and high based on a percentage
of the limit is also provided. The percentages
are determined by module parameters.

The available module parameters can be set at
kernel boot time, for example:
   memcontrol.memcg_min=10
   memcontrol.memcg_low=30
   memcontrol.memcg_high=80

Would set min to 10%, low to 30% and high to 80% of
the value written to:
  /sys/fs/cgroup/memory/<grp>/memory.limit_in_bytes

Signed-off-by: Shaun Tancheff <shaun.tancheff@hpe.com>
---
 mm/memcontrol.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5abffe6f8389..eec6e6ed92f8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -73,6 +73,18 @@
 
 #include <trace/events/vmscan.h>
 
+static unsigned int memcg_v1_min_default_percent;
+module_param_named(memcg_min, memcg_v1_min_default_percent, uint, 0600);
+MODULE_PARM_DESC(memcg_min, "memcg v1 min default percent");
+
+static unsigned int memcg_v1_low_default_percent;
+module_param_named(memcg_low, memcg_v1_low_default_percent, uint, 0600);
+MODULE_PARM_DESC(memcg_low, "memcg v1 low default percent");
+
+static unsigned int memcg_v1_high_default_percent;
+module_param_named(memcg_high, memcg_v1_high_default_percent, uint, 0600);
+MODULE_PARM_DESC(memcg_high, "memcg v1 high default percent");
+
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
@@ -208,6 +220,7 @@ enum res_type {
 	_MEMSWAP,
 	_KMEM,
 	_TCP,
+	_MEM_V1,
 };
 
 #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
@@ -3689,6 +3702,9 @@ enum {
 	RES_MAX_USAGE,
 	RES_FAILCNT,
 	RES_SOFT_LIMIT,
+	RES_LIMIT_MIN,
+	RES_LIMIT_LOW,
+	RES_LIMIT_HIGH,
 };
 
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
@@ -3699,6 +3715,7 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 
 	switch (MEMFILE_TYPE(cft->private)) {
 	case _MEM:
+	case _MEM_V1:
 		counter = &memcg->memory;
 		break;
 	case _MEMSWAP:
@@ -3729,6 +3746,12 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 		return counter->failcnt;
 	case RES_SOFT_LIMIT:
 		return (u64)memcg->soft_limit * PAGE_SIZE;
+	case RES_LIMIT_MIN:
+		return (u64)READ_ONCE(memcg->memory.min);
+	case RES_LIMIT_LOW:
+		return (u64)READ_ONCE(memcg->memory.low);
+	case RES_LIMIT_HIGH:
+		return (u64)READ_ONCE(memcg->memory.high);
 	default:
 		BUG();
 	}
@@ -3828,6 +3851,35 @@ static int memcg_update_tcp_max(struct mem_cgroup *memcg, unsigned long max)
 	return ret;
 }
 
+static inline void mem_cgroup_v1_set_defaults(struct mem_cgroup *memcg,
+					       u64 nr_pages)
+{
+	u64 max = (u64)(PAGE_COUNTER_MAX * PAGE_SIZE) / PAGE_SIZE;
+	u64 min, low, high;
+
+	if (mem_cgroup_is_root(memcg) || max == nr_pages)
+		return;
+
+	min = READ_ONCE(memcg->memory.min);
+	low = READ_ONCE(memcg->memory.low);
+	if (min || low)
+		return;
+
+	if (!min && memcg_v1_min_default_percent) {
+		min = (nr_pages * memcg_v1_min_default_percent) / 100;
+		page_counter_set_min(&memcg->memory, min);
+	}
+	if (!low && memcg_v1_low_default_percent) {
+		low = (nr_pages * memcg_v1_low_default_percent) / 100;
+		page_counter_set_low(&memcg->memory, low);
+	}
+	high = READ_ONCE(memcg->memory.high);
+	if (high == PAGE_COUNTER_MAX && memcg_v1_high_default_percent) {
+		high = (nr_pages * memcg_v1_high_default_percent) / 100;
+		page_counter_set_high(&memcg->memory, high);
+	}
+}
+
 /*
  * The user of this function is...
  * RES_LIMIT.
@@ -3851,6 +3903,11 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 			break;
 		}
 		switch (MEMFILE_TYPE(of_cft(of)->private)) {
+		case _MEM_V1:
+			ret = mem_cgroup_resize_max(memcg, nr_pages, false);
+			if (!ret)
+				mem_cgroup_v1_set_defaults(memcg, nr_pages);
+			break;
 		case _MEM:
 			ret = mem_cgroup_resize_max(memcg, nr_pages, false);
 			break;
@@ -4999,6 +5056,13 @@ static int mem_cgroup_slab_show(struct seq_file *m, void *p)
 }
 #endif
 
+static ssize_t memory_min_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off);
+static ssize_t memory_low_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off);
+static ssize_t memory_high_write(struct kernfs_open_file *of,
+				 char *buf, size_t nbytes, loff_t off);
+
 static struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -5013,10 +5077,28 @@ static struct cftype mem_cgroup_legacy_files[] = {
 	},
 	{
 		.name = "limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEM, RES_LIMIT),
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT),
 		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
+	{
+		.name = "limit_in_bytes.min",
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT_MIN),
+		.write = memory_min_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
+		.name = "limit_in_bytes.low",
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT_LOW),
+		.write = memory_low_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
+		.name = "limit_in_bytes.high",
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT_HIGH),
+		.write = memory_high_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
 	{
 		.name = "soft_limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
-- 
2.34.1

