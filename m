Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22FFFC3AED
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbfJAQkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbfJAQkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DA7921906;
        Tue,  1 Oct 2019 16:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948020;
        bh=POELVahFGz2TRENm/GYsKvf3/fYvIuvcaqdZ7Lh4NPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHBtlBIZH2n5tdeXqHZM46iPrOq2idH/KAen6VAwRyw0G3M8fHdC8JfCa16Wo1KTv
         OKPFsR28ZCQn3TM2n7Xbpb+B+KDSUDok2+Z1CHaxBrhB93aLZkiCi2UxjEU1xVqRQH
         5p18BaQMYbLOVMCGif3zMPBYkynWKcV9B7ubjL7E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvdimm@lists.01.org
Subject: [PATCH AUTOSEL 5.3 40/71] =?UTF-8?q?libnvdimm:=20Fix=20endian=20c?= =?UTF-8?q?onversion=20issues=C2=A0?=
Date:   Tue,  1 Oct 2019 12:38:50 -0400
Message-Id: <20191001163922.14735-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

[ Upstream commit 86aa66687442ef45909ff9814b82b4d2bb892294 ]

nd_label->dpa issue was observed when trying to enable the namespace created
with little-endian kernel on a big-endian kernel. That made me run
`sparse` on the rest of the code and other changes are the result of that.

Fixes: d9b83c756953 ("libnvdimm, btt: rework error clearing")
Fixes: 9dedc73a4658 ("libnvdimm/btt: Fix LBA masking during 'free list' population")
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Link: https://lore.kernel.org/r/20190809074726.27815-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/btt.c            | 8 ++++----
 drivers/nvdimm/namespace_devs.c | 7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index a8d56887ec881..3e9f45aec8d18 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -392,9 +392,9 @@ static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
 	arena->freelist[lane].sub = 1 - arena->freelist[lane].sub;
 	if (++(arena->freelist[lane].seq) == 4)
 		arena->freelist[lane].seq = 1;
-	if (ent_e_flag(ent->old_map))
+	if (ent_e_flag(le32_to_cpu(ent->old_map)))
 		arena->freelist[lane].has_err = 1;
-	arena->freelist[lane].block = le32_to_cpu(ent_lba(ent->old_map));
+	arena->freelist[lane].block = ent_lba(le32_to_cpu(ent->old_map));
 
 	return ret;
 }
@@ -560,8 +560,8 @@ static int btt_freelist_init(struct arena_info *arena)
 		 * FIXME: if error clearing fails during init, we want to make
 		 * the BTT read-only
 		 */
-		if (ent_e_flag(log_new.old_map) &&
-				!ent_normal(log_new.old_map)) {
+		if (ent_e_flag(le32_to_cpu(log_new.old_map)) &&
+		    !ent_normal(le32_to_cpu(log_new.old_map))) {
 			arena->freelist[i].has_err = 1;
 			ret = arena_clear_freelist_error(arena, i);
 			if (ret)
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index a16e52251a305..102c9d5141ee8 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1987,7 +1987,7 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 		nd_mapping = &nd_region->mapping[i];
 		label_ent = list_first_entry_or_null(&nd_mapping->labels,
 				typeof(*label_ent), list);
-		label0 = label_ent ? label_ent->label : 0;
+		label0 = label_ent ? label_ent->label : NULL;
 
 		if (!label0) {
 			WARN_ON(1);
@@ -2322,8 +2322,9 @@ static struct device **scan_labels(struct nd_region *nd_region)
 			continue;
 
 		/* skip labels that describe extents outside of the region */
-		if (nd_label->dpa < nd_mapping->start || nd_label->dpa > map_end)
-			continue;
+		if (__le64_to_cpu(nd_label->dpa) < nd_mapping->start ||
+		    __le64_to_cpu(nd_label->dpa) > map_end)
+				continue;
 
 		i = add_namespace_resource(nd_region, nd_label, devs, count);
 		if (i < 0)
-- 
2.20.1

