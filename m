Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBD837C6D1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbhELPy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:54:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234312AbhELPv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FEAE60FE9;
        Wed, 12 May 2021 15:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833181;
        bh=7WL8eamTbY8OeH4qiYW4xUGzjX1FxHghoA8QBUgtahk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pkyzoznnd+3LWHZqKWe+ISrsuUTmVNhMiIuWjtCACfXKFpKA0sOdyiScxQCXSZL6h
         07POiMPKYqtYRzCFpZoq35zGnp4mmuhnHl+8CKwHIcUuAIYhzBwSxtVNL4si0u5Pk0
         4yQOSX+sRjPpWIqVEmx8t/lXuFsg0R3IU/S2qQQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.11 050/601] md: split mddev_find
Date:   Wed, 12 May 2021 16:42:07 +0200
Message-Id: <20210512144829.466434623@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 65aa97c4d2bfd76677c211b9d03ef05a98c6d68e upstream.

Split mddev_find into a simple mddev_find that just finds an existing
mddev by the unit number, and a more complicated mddev_find that deals
with find or allocating a mddev.

This turns out to fix this bug reported by Zhao Heming.

----------------------------- snip ------------------------------
commit d3374825ce57 ("md: make devices disappear when they are no longer
needed.") introduced protection between mddev creating & removing. The
md_open shouldn't create mddev when all_mddevs list doesn't contain
mddev. With currently code logic, there will be very easy to trigger
soft lockup in non-preempt env.

---
 drivers/md/md.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -754,6 +754,22 @@ EXPORT_SYMBOL_GPL(mddev_init);
 
 static struct mddev *mddev_find(dev_t unit)
 {
+	struct mddev *mddev;
+
+	if (MAJOR(unit) != MD_MAJOR)
+		unit &= ~((1 << MdpMinorShift) - 1);
+
+	spin_lock(&all_mddevs_lock);
+	mddev = mddev_find_locked(unit);
+	if (mddev)
+		mddev_get(mddev);
+	spin_unlock(&all_mddevs_lock);
+
+	return mddev;
+}
+
+static struct mddev *mddev_find_or_alloc(dev_t unit)
+{
 	struct mddev *mddev, *new = NULL;
 
 	if (unit && MAJOR(unit) != MD_MAJOR)
@@ -5657,7 +5673,7 @@ static int md_alloc(dev_t dev, char *nam
 	 * writing to /sys/module/md_mod/parameters/new_array.
 	 */
 	static DEFINE_MUTEX(disks_mutex);
-	struct mddev *mddev = mddev_find(dev);
+	struct mddev *mddev = mddev_find_or_alloc(dev);
 	struct gendisk *disk;
 	int partitioned;
 	int shift;
@@ -6539,11 +6555,9 @@ static void autorun_devices(int part)
 
 		md_probe(dev);
 		mddev = mddev_find(dev);
-		if (!mddev || !mddev->gendisk) {
-			if (mddev)
-				mddev_put(mddev);
+		if (!mddev)
 			break;
-		}
+
 		if (mddev_lock(mddev))
 			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
 		else if (mddev->raid_disks || mddev->major_version


