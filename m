Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A664840960A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343597AbhIMOrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:47:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346229AbhIMOpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:45:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79CF66138D;
        Mon, 13 Sep 2021 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541496;
        bh=7cPgit04OnoYTxOk+CS+U8wiG3J4aHNe3jVdPZIM02Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msAVgGT3AC47eIDESfH6a9RQ++3Z14knTnRNxkaduCB5UQCez2+/vrFEZqmdzicWZ
         XNH2LO6vSKF0XSBTjdCdrOcVSOHkbZB6UZbBYZMiOuCixtwtATVJS0buhZoKjJEjo8
         Ou+YOUYgQRdzd+yAmlP+2U1BkFjUBkSKwQy7Z3RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.14 321/334] md/raid10: Remove unnecessary rcu_dereference in raid10_handle_discard
Date:   Mon, 13 Sep 2021 15:16:15 +0200
Message-Id: <20210913131124.279825906@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

commit 46d4703b1db4c86ab5acb2331b10df999f005e8e upstream.

We are seeing the following warning in raid10_handle_discard.
[  695.110751] =============================
[  695.131439] WARNING: suspicious RCU usage
[  695.151389] 4.18.0-319.el8.x86_64+debug #1 Not tainted
[  695.174413] -----------------------------
[  695.192603] drivers/md/raid10.c:1776 suspicious
rcu_dereference_check() usage!
[  695.225107] other info that might help us debug this:
[  695.260940] rcu_scheduler_active = 2, debug_locks = 1
[  695.290157] no locks held by mkfs.xfs/10186.

In the first loop of function raid10_handle_discard. It already
determines which disk need to handle discard request and add the
rdev reference count rdev->nr_pending. So the conf->mirrors will
not change until all bios come back from underlayer disks. It
doesn't need to use rcu_dereference to get rdev.

Cc: stable@vger.kernel.org
Fixes: d30588b2731f ('md/raid10: improve raid10 discard request')
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1712,6 +1712,11 @@ retry_discard:
 	} else
 		r10_bio->master_bio = (struct bio *)first_r10bio;
 
+	/*
+	 * first select target devices under rcu_lock and
+	 * inc refcount on their rdev.  Record them by setting
+	 * bios[x] to bio
+	 */
 	rcu_read_lock();
 	for (disk = 0; disk < geo->raid_disks; disk++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
@@ -1743,9 +1748,6 @@ retry_discard:
 	for (disk = 0; disk < geo->raid_disks; disk++) {
 		sector_t dev_start, dev_end;
 		struct bio *mbio, *rbio = NULL;
-		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
-		struct md_rdev *rrdev = rcu_dereference(
-			conf->mirrors[disk].replacement);
 
 		/*
 		 * Now start to calculate the start and end address for each disk.
@@ -1775,9 +1777,12 @@ retry_discard:
 
 		/*
 		 * It only handles discard bio which size is >= stripe size, so
-		 * dev_end > dev_start all the time
+		 * dev_end > dev_start all the time.
+		 * It doesn't need to use rcu lock to get rdev here. We already
+		 * add rdev->nr_pending in the first loop.
 		 */
 		if (r10_bio->devs[disk].bio) {
+			struct md_rdev *rdev = conf->mirrors[disk].rdev;
 			mbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
 			mbio->bi_end_io = raid10_end_discard_request;
 			mbio->bi_private = r10_bio;
@@ -1790,6 +1795,7 @@ retry_discard:
 			bio_endio(mbio);
 		}
 		if (r10_bio->devs[disk].repl_bio) {
+			struct md_rdev *rrdev = conf->mirrors[disk].replacement;
 			rbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
 			rbio->bi_end_io = raid10_end_discard_request;
 			rbio->bi_private = r10_bio;


