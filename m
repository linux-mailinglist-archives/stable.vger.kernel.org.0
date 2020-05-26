Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0D11E2B8B
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391062AbgEZTGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403875AbgEZTGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:06:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF24D20776;
        Tue, 26 May 2020 19:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519971;
        bh=WvgeDUlBuFvjwO26UKDgxLQqw5bDZjtGnMdSOqGdDts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPNV5Wn8kqRw6h0rux8Um2+MiL0UAd7ciXfSMHpEW4fpqGo7nVySXGpkUWSN7SaTM
         gFeGqbNNIVXIQOe38uHBcphAfEFsvlANUZwkh+IaO3hm/caGwtZsYBviLTG68p8Myl
         iVPWS2g9WYf0wAZeRdycX/go8L007nl4TZNdb4F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Dexuan Cui <decui@microsoft.com>,
        Pedro dAquino Filocre F S Barbuda 
        <pbarbuda@microsoft.com>, Vishal Verma <vishal.l.verma@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/81] libnvdimm/btt: Fix LBA masking during free list population
Date:   Tue, 26 May 2020 20:53:28 +0200
Message-Id: <20200526183932.993059888@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Verma <vishal.l.verma@intel.com>

[ Upstream commit 9dedc73a4658ebcc0c9b58c3cb84e9ac80122213 ]

The Linux BTT implementation assumes that log entries will never have
the 'zero' flag set, and indeed it never sets that flag for log entries
itself.

However, the UEFI spec is ambiguous on the exact format of the LBA field
of a log entry, specifically as to whether it should include the
additional flag bits or not. While a zero bit doesn't make sense in the
context of a log entry, other BTT implementations might still have it set.

If an implementation does happen to have it set, we would happily read
it in as the next block to write to for writes. Since a high bit is set,
it pushes the block number out of the range of an 'arena', and we fail
such a write with an EIO.

Follow the robustness principle, and tolerate such implementations by
stripping out the zero flag when populating the free list during
initialization. Additionally, use the same stripped out entries for
detection of incomplete writes and map restoration that happens at this
stage.

Add a sysfs file 'log_zero_flags' that indicates the ability to accept
such a layout to userspace applications. This enables 'ndctl
check-namespace' to recognize whether the kernel is able to handle zero
flags, or whether it should attempt a fix-up under the --repair option.

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Dexuan Cui <decui@microsoft.com>
Reported-by: Pedro d'Aquino Filocre F S Barbuda <pbarbuda@microsoft.com>
Tested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/btt.c      | 25 +++++++++++++++++++------
 drivers/nvdimm/btt.h      |  2 ++
 drivers/nvdimm/btt_devs.c |  8 ++++++++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index d78cfe82ad5c..1064a703ccec 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -542,8 +542,8 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
 static int btt_freelist_init(struct arena_info *arena)
 {
 	int new, ret;
-	u32 i, map_entry;
 	struct log_entry log_new;
+	u32 i, map_entry, log_oldmap, log_newmap;
 
 	arena->freelist = kcalloc(arena->nfree, sizeof(struct free_entry),
 					GFP_KERNEL);
@@ -555,16 +555,22 @@ static int btt_freelist_init(struct arena_info *arena)
 		if (new < 0)
 			return new;
 
+		/* old and new map entries with any flags stripped out */
+		log_oldmap = ent_lba(le32_to_cpu(log_new.old_map));
+		log_newmap = ent_lba(le32_to_cpu(log_new.new_map));
+
 		/* sub points to the next one to be overwritten */
 		arena->freelist[i].sub = 1 - new;
 		arena->freelist[i].seq = nd_inc_seq(le32_to_cpu(log_new.seq));
-		arena->freelist[i].block = le32_to_cpu(log_new.old_map);
+		arena->freelist[i].block = log_oldmap;
 
 		/*
 		 * FIXME: if error clearing fails during init, we want to make
 		 * the BTT read-only
 		 */
-		if (ent_e_flag(log_new.old_map)) {
+		if (ent_e_flag(log_new.old_map) &&
+				!ent_normal(log_new.old_map)) {
+			arena->freelist[i].has_err = 1;
 			ret = arena_clear_freelist_error(arena, i);
 			if (ret)
 				dev_err_ratelimited(to_dev(arena),
@@ -572,7 +578,7 @@ static int btt_freelist_init(struct arena_info *arena)
 		}
 
 		/* This implies a newly created or untouched flog entry */
-		if (log_new.old_map == log_new.new_map)
+		if (log_oldmap == log_newmap)
 			continue;
 
 		/* Check if map recovery is needed */
@@ -580,8 +586,15 @@ static int btt_freelist_init(struct arena_info *arena)
 				NULL, NULL, 0);
 		if (ret)
 			return ret;
-		if ((le32_to_cpu(log_new.new_map) != map_entry) &&
-				(le32_to_cpu(log_new.old_map) == map_entry)) {
+
+		/*
+		 * The map_entry from btt_read_map is stripped of any flag bits,
+		 * so use the stripped out versions from the log as well for
+		 * testing whether recovery is needed. For restoration, use the
+		 * 'raw' version of the log entries as that captured what we
+		 * were going to write originally.
+		 */
+		if ((log_newmap != map_entry) && (log_oldmap == map_entry)) {
 			/*
 			 * Last transaction wrote the flog, but wasn't able
 			 * to complete the map write. So fix up the map.
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index db3cb6d4d0d4..ddff49c707b0 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -44,6 +44,8 @@
 #define ent_e_flag(ent) (!!(ent & MAP_ERR_MASK))
 #define ent_z_flag(ent) (!!(ent & MAP_TRIM_MASK))
 #define set_e_flag(ent) (ent |= MAP_ERR_MASK)
+/* 'normal' is both e and z flags set */
+#define ent_normal(ent) (ent_e_flag(ent) && ent_z_flag(ent))
 
 enum btt_init_state {
 	INIT_UNCHECKED = 0,
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index e341498876ca..9486acc08402 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -159,11 +159,19 @@ static ssize_t size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(size);
 
+static ssize_t log_zero_flags_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "Y\n");
+}
+static DEVICE_ATTR_RO(log_zero_flags);
+
 static struct attribute *nd_btt_attributes[] = {
 	&dev_attr_sector_size.attr,
 	&dev_attr_namespace.attr,
 	&dev_attr_uuid.attr,
 	&dev_attr_size.attr,
+	&dev_attr_log_zero_flags.attr,
 	NULL,
 };
 
-- 
2.25.1



