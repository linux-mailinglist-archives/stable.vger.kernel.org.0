Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5504F2CB8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345751AbiDEJzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343876AbiDEJOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:14:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE85350E1A;
        Tue,  5 Apr 2022 02:01:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 44AE4CE1C6A;
        Tue,  5 Apr 2022 09:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B37FC385A1;
        Tue,  5 Apr 2022 09:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149266;
        bh=Rzsl//Od4kog6/5iJWPpitObw1OpYpIUeRxM9Rz1vOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLwtKGGLNw7z4lP8Mr4NNkpaT9fvzPboTnOpdJz3OopdNK3BNATDZb/pu47d1By4R
         IsrQIDL8JMVqE9tlGsvN5f0wp52Ap2bQTjeEHRO60OrxSfe21GcyxddXz70xtfH3wl
         XWIWdrVZIbgWBnnEYBkMFQQum/W76YJyQ/XSEoc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0654/1017] dmaengine: idxd: change bandwidth token to read buffers
Date:   Tue,  5 Apr 2022 09:26:07 +0200
Message-Id: <20220405070413.696720087@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 7ed6f1b85fb613e5e44ef3e14d73f2dc96860935 ]

DSA spec v1.2 has changed the term of "bandwidth tokens" to "read buffers"
in order to make the concept clearer. Deprecate bandwidth token
naming in the driver and convert to read buffers in order to match with
the spec and reduce confusion when reading the spec.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/163951338932.2988321.6162640806935567317.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c    | 25 +++++++++++----------
 drivers/dma/idxd/idxd.h      | 12 +++++------
 drivers/dma/idxd/init.c      |  6 +++---
 drivers/dma/idxd/registers.h | 14 ++++++------
 drivers/dma/idxd/sysfs.c     | 42 ++++++++++++++++++------------------
 5 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index cd855097bfdb..83aa0c79f830 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -688,9 +688,9 @@ static void idxd_groups_clear_state(struct idxd_device *idxd)
 		memset(&group->grpcfg, 0, sizeof(group->grpcfg));
 		group->num_engines = 0;
 		group->num_wqs = 0;
-		group->use_token_limit = false;
-		group->tokens_allowed = 0;
-		group->tokens_reserved = 0;
+		group->use_rdbuf_limit = false;
+		group->rdbufs_allowed = 0;
+		group->rdbufs_reserved = 0;
 		group->tc_a = -1;
 		group->tc_b = -1;
 	}
@@ -788,10 +788,10 @@ static int idxd_groups_config_write(struct idxd_device *idxd)
 	int i;
 	struct device *dev = &idxd->pdev->dev;
 
-	/* Setup bandwidth token limit */
-	if (idxd->hw.gen_cap.config_en && idxd->token_limit) {
+	/* Setup bandwidth rdbuf limit */
+	if (idxd->hw.gen_cap.config_en && idxd->rdbuf_limit) {
 		reg.bits = ioread32(idxd->reg_base + IDXD_GENCFG_OFFSET);
-		reg.token_limit = idxd->token_limit;
+		reg.rdbuf_limit = idxd->rdbuf_limit;
 		iowrite32(reg.bits, idxd->reg_base + IDXD_GENCFG_OFFSET);
 	}
 
@@ -932,13 +932,12 @@ static void idxd_group_flags_setup(struct idxd_device *idxd)
 			group->tc_b = group->grpcfg.flags.tc_b = 1;
 		else
 			group->grpcfg.flags.tc_b = group->tc_b;
-		group->grpcfg.flags.use_token_limit = group->use_token_limit;
-		group->grpcfg.flags.tokens_reserved = group->tokens_reserved;
-		if (group->tokens_allowed)
-			group->grpcfg.flags.tokens_allowed =
-				group->tokens_allowed;
+		group->grpcfg.flags.use_rdbuf_limit = group->use_rdbuf_limit;
+		group->grpcfg.flags.rdbufs_reserved = group->rdbufs_reserved;
+		if (group->rdbufs_allowed)
+			group->grpcfg.flags.rdbufs_allowed = group->rdbufs_allowed;
 		else
-			group->grpcfg.flags.tokens_allowed = idxd->max_tokens;
+			group->grpcfg.flags.rdbufs_allowed = idxd->max_rdbufs;
 	}
 }
 
@@ -1131,7 +1130,7 @@ int idxd_device_load_config(struct idxd_device *idxd)
 	int i, rc;
 
 	reg.bits = ioread32(idxd->reg_base + IDXD_GENCFG_OFFSET);
-	idxd->token_limit = reg.token_limit;
+	idxd->rdbuf_limit = reg.rdbuf_limit;
 
 	for (i = 0; i < idxd->max_groups; i++) {
 		struct idxd_group *group = idxd->groups[i];
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 0cf8d3145870..ca1e7bd05839 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -84,9 +84,9 @@ struct idxd_group {
 	int id;
 	int num_engines;
 	int num_wqs;
-	bool use_token_limit;
-	u8 tokens_allowed;
-	u8 tokens_reserved;
+	bool use_rdbuf_limit;
+	u8 rdbufs_allowed;
+	u8 rdbufs_reserved;
 	int tc_a;
 	int tc_b;
 };
@@ -276,11 +276,11 @@ struct idxd_device {
 	u32 max_batch_size;
 	int max_groups;
 	int max_engines;
-	int max_tokens;
+	int max_rdbufs;
 	int max_wqs;
 	int max_wq_size;
-	int token_limit;
-	int nr_tokens;		/* non-reserved tokens */
+	int rdbuf_limit;
+	int nr_rdbufs;		/* non-reserved read buffers */
 	unsigned int wqcfg_size;
 
 	union sw_err_reg sw_err;
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 7bf03f371ce1..6263d9825250 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -464,9 +464,9 @@ static void idxd_read_caps(struct idxd_device *idxd)
 	dev_dbg(dev, "group_cap: %#llx\n", idxd->hw.group_cap.bits);
 	idxd->max_groups = idxd->hw.group_cap.num_groups;
 	dev_dbg(dev, "max groups: %u\n", idxd->max_groups);
-	idxd->max_tokens = idxd->hw.group_cap.total_tokens;
-	dev_dbg(dev, "max tokens: %u\n", idxd->max_tokens);
-	idxd->nr_tokens = idxd->max_tokens;
+	idxd->max_rdbufs = idxd->hw.group_cap.total_rdbufs;
+	dev_dbg(dev, "max read buffers: %u\n", idxd->max_rdbufs);
+	idxd->nr_rdbufs = idxd->max_rdbufs;
 
 	/* read engine capabilities */
 	idxd->hw.engine_cap.bits =
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index 262c8220adbd..ac4fe0b1dd8a 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -64,9 +64,9 @@ union wq_cap_reg {
 union group_cap_reg {
 	struct {
 		u64 num_groups:8;
-		u64 total_tokens:8;
-		u64 token_en:1;
-		u64 token_limit:1;
+		u64 total_rdbufs:8;	/* formerly total_tokens */
+		u64 rdbuf_ctrl:1;	/* formerly token_en */
+		u64 rdbuf_limit:1;	/* formerly token_limit */
 		u64 rsvd:46;
 	};
 	u64 bits;
@@ -110,7 +110,7 @@ union offsets_reg {
 #define IDXD_GENCFG_OFFSET		0x80
 union gencfg_reg {
 	struct {
-		u32 token_limit:8;
+		u32 rdbuf_limit:8;
 		u32 rsvd:4;
 		u32 user_int_en:1;
 		u32 rsvd2:19;
@@ -287,10 +287,10 @@ union group_flags {
 		u32 tc_a:3;
 		u32 tc_b:3;
 		u32 rsvd:1;
-		u32 use_token_limit:1;
-		u32 tokens_reserved:8;
+		u32 use_rdbuf_limit:1;
+		u32 rdbufs_reserved:8;
 		u32 rsvd2:4;
-		u32 tokens_allowed:8;
+		u32 rdbufs_allowed:8;
 		u32 rsvd3:4;
 	};
 	u32 bits;
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index a9025be940db..999ce13a93ad 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -99,17 +99,17 @@ struct device_type idxd_engine_device_type = {
 
 /* Group attributes */
 
-static void idxd_set_free_tokens(struct idxd_device *idxd)
+static void idxd_set_free_rdbufs(struct idxd_device *idxd)
 {
-	int i, tokens;
+	int i, rdbufs;
 
-	for (i = 0, tokens = 0; i < idxd->max_groups; i++) {
+	for (i = 0, rdbufs = 0; i < idxd->max_groups; i++) {
 		struct idxd_group *g = idxd->groups[i];
 
-		tokens += g->tokens_reserved;
+		rdbufs += g->rdbufs_reserved;
 	}
 
-	idxd->nr_tokens = idxd->max_tokens - tokens;
+	idxd->nr_rdbufs = idxd->max_rdbufs - rdbufs;
 }
 
 static ssize_t group_tokens_reserved_show(struct device *dev,
@@ -118,7 +118,7 @@ static ssize_t group_tokens_reserved_show(struct device *dev,
 {
 	struct idxd_group *group = confdev_to_group(dev);
 
-	return sysfs_emit(buf, "%u\n", group->tokens_reserved);
+	return sysfs_emit(buf, "%u\n", group->rdbufs_reserved);
 }
 
 static ssize_t group_tokens_reserved_store(struct device *dev,
@@ -143,14 +143,14 @@ static ssize_t group_tokens_reserved_store(struct device *dev,
 	if (idxd->state == IDXD_DEV_ENABLED)
 		return -EPERM;
 
-	if (val > idxd->max_tokens)
+	if (val > idxd->max_rdbufs)
 		return -EINVAL;
 
-	if (val > idxd->nr_tokens + group->tokens_reserved)
+	if (val > idxd->nr_rdbufs + group->rdbufs_reserved)
 		return -EINVAL;
 
-	group->tokens_reserved = val;
-	idxd_set_free_tokens(idxd);
+	group->rdbufs_reserved = val;
+	idxd_set_free_rdbufs(idxd);
 	return count;
 }
 
@@ -164,7 +164,7 @@ static ssize_t group_tokens_allowed_show(struct device *dev,
 {
 	struct idxd_group *group = confdev_to_group(dev);
 
-	return sysfs_emit(buf, "%u\n", group->tokens_allowed);
+	return sysfs_emit(buf, "%u\n", group->rdbufs_allowed);
 }
 
 static ssize_t group_tokens_allowed_store(struct device *dev,
@@ -190,10 +190,10 @@ static ssize_t group_tokens_allowed_store(struct device *dev,
 		return -EPERM;
 
 	if (val < 4 * group->num_engines ||
-	    val > group->tokens_reserved + idxd->nr_tokens)
+	    val > group->rdbufs_reserved + idxd->nr_rdbufs)
 		return -EINVAL;
 
-	group->tokens_allowed = val;
+	group->rdbufs_allowed = val;
 	return count;
 }
 
@@ -207,7 +207,7 @@ static ssize_t group_use_token_limit_show(struct device *dev,
 {
 	struct idxd_group *group = confdev_to_group(dev);
 
-	return sysfs_emit(buf, "%u\n", group->use_token_limit);
+	return sysfs_emit(buf, "%u\n", group->use_rdbuf_limit);
 }
 
 static ssize_t group_use_token_limit_store(struct device *dev,
@@ -232,10 +232,10 @@ static ssize_t group_use_token_limit_store(struct device *dev,
 	if (idxd->state == IDXD_DEV_ENABLED)
 		return -EPERM;
 
-	if (idxd->token_limit == 0)
+	if (idxd->rdbuf_limit == 0)
 		return -EPERM;
 
-	group->use_token_limit = !!val;
+	group->use_rdbuf_limit = !!val;
 	return count;
 }
 
@@ -1161,7 +1161,7 @@ static ssize_t max_tokens_show(struct device *dev,
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
 
-	return sysfs_emit(buf, "%u\n", idxd->max_tokens);
+	return sysfs_emit(buf, "%u\n", idxd->max_rdbufs);
 }
 static DEVICE_ATTR_RO(max_tokens);
 
@@ -1170,7 +1170,7 @@ static ssize_t token_limit_show(struct device *dev,
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
 
-	return sysfs_emit(buf, "%u\n", idxd->token_limit);
+	return sysfs_emit(buf, "%u\n", idxd->rdbuf_limit);
 }
 
 static ssize_t token_limit_store(struct device *dev,
@@ -1191,13 +1191,13 @@ static ssize_t token_limit_store(struct device *dev,
 	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
 		return -EPERM;
 
-	if (!idxd->hw.group_cap.token_limit)
+	if (!idxd->hw.group_cap.rdbuf_limit)
 		return -EPERM;
 
-	if (val > idxd->hw.group_cap.total_tokens)
+	if (val > idxd->hw.group_cap.total_rdbufs)
 		return -EINVAL;
 
-	idxd->token_limit = val;
+	idxd->rdbuf_limit = val;
 	return count;
 }
 static DEVICE_ATTR_RW(token_limit);
-- 
2.34.1



