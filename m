Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2321812C8A2
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733115AbfL2R4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:56:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732653AbfL2R4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B095222C3;
        Sun, 29 Dec 2019 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642201;
        bh=V5VIuNNWrdimgxGRHI3tSHqlGBTBL6VArwShKNhnAc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8lk0KGIic5M08AYWyfCHtf0V5tSJovaYFPBNllEttYX/5cSg1PBqxvq3zgh7Jb/a
         7iqyMZdskMc/xQmyLTxM5jcfsLK/R5XCtB0Y0c4idojIUvQrNyFd2BibIMd9Z7uklf
         ZKEZyzcWb3O0xi+Ds32dtBT98HvI55ovPyubGKZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Yufen Yu <yuyufen@huawei.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 385/434] md: avoid invalid memory access for array sb->dev_roles
Date:   Sun, 29 Dec 2019 18:27:18 +0100
Message-Id: <20191229172727.772277906@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit 228fc7d76db68732677230a3c64337908fd298e3 ]

we need to gurantee 'desc_nr' valid before access array
of sb->dev_roles.

In addition, we should avoid .load_super always return '0'
when level is LEVEL_MULTIPATH, which is not expected.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1487373 ("Memory - illegal accesses")
Fixes: 6a5cb53aaa4e ("md: no longer compare spare disk superblock events in super_load")
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 51 +++++++++++++++++++------------------------------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6f0ecfe8eab2..805b33e27496 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1105,6 +1105,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	mdp_super_t *sb;
 	int ret;
+	bool spare_disk = true;
 
 	/*
 	 * Calculate the position of the superblock (512byte sectors),
@@ -1155,13 +1156,15 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 	else
 		rdev->desc_nr = sb->this_disk.number;
 
+	/* not spare disk, or LEVEL_MULTIPATH */
+	if (sb->level == LEVEL_MULTIPATH ||
+		(rdev->desc_nr >= 0 &&
+		 sb->disks[rdev->desc_nr].state &
+		 ((1<<MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE))))
+		spare_disk = false;
+
 	if (!refdev) {
-		/*
-		 * Insist on good event counter while assembling, except
-		 * for spares (which don't need an event count)
-		 */
-		if (sb->disks[rdev->desc_nr].state & (
-			(1<<MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE)))
+		if (!spare_disk)
 			ret = 1;
 		else
 			ret = 0;
@@ -1181,13 +1184,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		ev1 = md_event(sb);
 		ev2 = md_event(refsb);
 
-		/*
-		 * Insist on good event counter while assembling, except
-		 * for spares (which don't need an event count)
-		 */
-		if (sb->disks[rdev->desc_nr].state & (
-			(1<<MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE)) &&
-			(ev1 > ev2))
+		if (!spare_disk && ev1 > ev2)
 			ret = 1;
 		else
 			ret = 0;
@@ -1547,7 +1544,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	sector_t sectors;
 	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	int bmask;
-	__u64 role;
+	bool spare_disk = true;
 
 	/*
 	 * Calculate the position of the superblock in 512byte sectors.
@@ -1681,17 +1678,16 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	    sb->level != 0)
 		return -EINVAL;
 
-	role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
+	/* not spare disk, or LEVEL_MULTIPATH */
+	if (sb->level == cpu_to_le32(LEVEL_MULTIPATH) ||
+		(rdev->desc_nr >= 0 &&
+		rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
+		(le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DISK_ROLE_MAX ||
+		 le16_to_cpu(sb->dev_roles[rdev->desc_nr]) == MD_DISK_ROLE_JOURNAL)))
+		spare_disk = false;
 
 	if (!refdev) {
-		/*
-		 * Insist of good event counter while assembling, except for
-		 * spares (which don't need an event count)
-		 */
-		if (rdev->desc_nr >= 0 &&
-		    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
-			(role < MD_DISK_ROLE_MAX ||
-			 role == MD_DISK_ROLE_JOURNAL))
+		if (!spare_disk)
 			ret = 1;
 		else
 			ret = 0;
@@ -1711,14 +1707,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		ev1 = le64_to_cpu(sb->events);
 		ev2 = le64_to_cpu(refsb->events);
 
-		/*
-		 * Insist of good event counter while assembling, except for
-		 * spares (which don't need an event count)
-		 */
-		if (rdev->desc_nr >= 0 &&
-		    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
-			(role < MD_DISK_ROLE_MAX ||
-			 role == MD_DISK_ROLE_JOURNAL) && ev1 > ev2)
+		if (!spare_disk && ev1 > ev2)
 			ret = 1;
 		else
 			ret = 0;
-- 
2.20.1



