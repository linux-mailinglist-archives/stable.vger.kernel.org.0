Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F43C1B693C
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgDWXVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:21:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48492 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgDWXGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:32 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004bf-Dj; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6ic-1P; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Vivek Goyal" <vgoyal@redhat.com>,
        "Mike Snitzer" <snitzer@redhat.com>
Date:   Fri, 24 Apr 2020 00:04:43 +0100
Message-ID: <lsq.1587683028.702625938@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 056/245] dm: do not override error code returned from
 dm_get_device()
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek Goyal <vgoyal@redhat.com>

commit e80d1c805a3b2f0ad2081369be5dc5deedd5ee59 upstream.

Some of the device mapper targets override the error code returned by
dm_get_device() and return either -EINVAL or -ENXIO.  There is nothing
gained by this override.  It is better to propagate the returned error
code unchanged to caller.

This work was motivated by hitting an issue where the underlying device
was busy but -EINVAL was being returned.  After this change we get
-EBUSY instead and it is easier to figure out the problem.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[bwh: Backported to 3.16: drop changes to dm-log-writes]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1762,11 +1762,13 @@ static int crypt_ctr(struct dm_target *t
 	}
 	cc->iv_offset = tmpll;
 
-	if (dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &cc->dev)) {
+	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &cc->dev);
+	if (ret) {
 		ti->error = "Device lookup failed";
 		goto bad;
 	}
 
+	ret = -EINVAL;
 	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid device sector";
 		goto bad;
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -129,6 +129,7 @@ static int delay_ctr(struct dm_target *t
 	struct delay_c *dc;
 	unsigned long long tmpll;
 	char dummy;
+	int ret;
 
 	if (argc != 3 && argc != 6) {
 		ti->error = "requires exactly 3 or 6 arguments";
@@ -143,6 +144,7 @@ static int delay_ctr(struct dm_target *t
 
 	dc->reads = dc->writes = 0;
 
+	ret = -EINVAL;
 	if (sscanf(argv[1], "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid device sector";
 		goto bad;
@@ -154,12 +156,14 @@ static int delay_ctr(struct dm_target *t
 		goto bad;
 	}
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &dc->dev_read)) {
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &dc->dev_read);
+	if (ret) {
 		ti->error = "Device lookup failed";
 		goto bad;
 	}
 
+	ret = -EINVAL;
 	dc->dev_write = NULL;
 	if (argc == 3)
 		goto out;
@@ -175,13 +179,15 @@ static int delay_ctr(struct dm_target *t
 		goto bad_dev_read;
 	}
 
-	if (dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
-			  &dc->dev_write)) {
+	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+			    &dc->dev_write);
+	if (ret) {
 		ti->error = "Write device lookup failed";
 		goto bad_dev_read;
 	}
 
 out:
+	ret = -EINVAL;
 	dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
 	if (!dc->kdelayd_wq) {
 		DMERR("Couldn't start kdelayd");
@@ -208,7 +214,7 @@ bad_dev_read:
 	dm_put_device(ti, dc->dev_read);
 bad:
 	kfree(dc);
-	return -EINVAL;
+	return ret;
 }
 
 static void delay_dtr(struct dm_target *ti)
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -183,6 +183,7 @@ static int flakey_ctr(struct dm_target *
 
 	devname = dm_shift_arg(&as);
 
+	r = -EINVAL;
 	if (sscanf(dm_shift_arg(&as), "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid device sector";
 		goto bad;
@@ -211,7 +212,8 @@ static int flakey_ctr(struct dm_target *
 	if (r)
 		goto bad;
 
-	if (dm_get_device(ti, devname, dm_table_get_mode(ti->table), &fc->dev)) {
+	r = dm_get_device(ti, devname, dm_table_get_mode(ti->table), &fc->dev);
+	if (r) {
 		ti->error = "Device lookup failed";
 		goto bad;
 	}
@@ -224,7 +226,7 @@ static int flakey_ctr(struct dm_target *
 
 bad:
 	kfree(fc);
-	return -EINVAL;
+	return r;
 }
 
 static void flakey_dtr(struct dm_target *ti)
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -30,6 +30,7 @@ static int linear_ctr(struct dm_target *
 	struct linear_c *lc;
 	unsigned long long tmp;
 	char dummy;
+	int ret;
 
 	if (argc != 2) {
 		ti->error = "Invalid argument count";
@@ -42,13 +43,15 @@ static int linear_ctr(struct dm_target *
 		return -ENOMEM;
 	}
 
+	ret = -EINVAL;
 	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1) {
 		ti->error = "dm-linear: Invalid device sector";
 		goto bad;
 	}
 	lc->start = tmp;
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev)) {
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev);
+	if (ret) {
 		ti->error = "dm-linear: Device lookup failed";
 		goto bad;
 	}
@@ -61,7 +64,7 @@ static int linear_ctr(struct dm_target *
 
       bad:
 	kfree(lc);
-	return -EINVAL;
+	return ret;
 }
 
 static void linear_dtr(struct dm_target *ti)
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -923,16 +923,18 @@ static int get_mirror(struct mirror_set
 {
 	unsigned long long offset;
 	char dummy;
+	int ret;
 
 	if (sscanf(argv[1], "%llu%c", &offset, &dummy) != 1) {
 		ti->error = "Invalid offset";
 		return -EINVAL;
 	}
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &ms->mirror[mirror].dev)) {
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &ms->mirror[mirror].dev);
+	if (ret) {
 		ti->error = "Device lookup failure";
-		return -ENXIO;
+		return ret;
 	}
 
 	ms->mirror[mirror].ms = ms;
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -75,13 +75,15 @@ static int get_stripe(struct dm_target *
 {
 	unsigned long long start;
 	char dummy;
+	int ret;
 
 	if (sscanf(argv[1], "%llu%c", &start, &dummy) != 1)
 		return -EINVAL;
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &sc->stripe[stripe].dev))
-		return -ENXIO;
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &sc->stripe[stripe].dev);
+	if (ret)
+		return ret;
 
 	sc->stripe[stripe].physical_start = start;
 

