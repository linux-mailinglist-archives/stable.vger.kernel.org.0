Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52FF4095E9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346360AbhIMOqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:46:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347658AbhIMOoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2740619E7;
        Mon, 13 Sep 2021 13:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541461;
        bh=Qv+nBdfMIHDysSVli+009HPvJndRyFgRwRQ+sXeJhW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cfvk11issLAkZiaUvs60lZ4t9QBeOOIG2tjSnxdPYZ2sml/dI4eo2Fkutjea4WoDS
         sBhA9j7t4KV7pVrxmQfNnMGbmMACBt23SapNmhfn+ogHk0ybIMUK+hXDcMLSBTXSC+
         rZLM2nRpAc+dExc0pFMDZQZrDb7YlFKzwG8D44FU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Stutte <jens@chianterastutte.eu>,
        Christoph Hellwig <hch@lst.de>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.14 305/334] raid1: ensure write behind bio has less than BIO_MAX_VECS sectors
Date:   Mon, 13 Sep 2021 15:15:59 +0200
Message-Id: <20210913131123.730602786@linuxfoundation.org>
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

From: Guoqing Jiang <jiangguoqing@kylinos.cn>

commit 6607cd319b6b91bff94e90f798a61c031650b514 upstream.

We can't split write behind bio with more than BIO_MAX_VECS sectors,
otherwise the below call trace was triggered because we could allocate
oversized write behind bio later.

[ 8.097936] bvec_alloc+0x90/0xc0
[ 8.098934] bio_alloc_bioset+0x1b3/0x260
[ 8.099959] raid1_make_request+0x9ce/0xc50 [raid1]
[ 8.100988] ? __bio_clone_fast+0xa8/0xe0
[ 8.102008] md_handle_request+0x158/0x1d0 [md_mod]
[ 8.103050] md_submit_bio+0xcd/0x110 [md_mod]
[ 8.104084] submit_bio_noacct+0x139/0x530
[ 8.105127] submit_bio+0x78/0x1d0
[ 8.106163] ext4_io_submit+0x48/0x60 [ext4]
[ 8.107242] ext4_writepages+0x652/0x1170 [ext4]
[ 8.108300] ? do_writepages+0x41/0x100
[ 8.109338] ? __ext4_mark_inode_dirty+0x240/0x240 [ext4]
[ 8.110406] do_writepages+0x41/0x100
[ 8.111450] __filemap_fdatawrite_range+0xc5/0x100
[ 8.112513] file_write_and_wait_range+0x61/0xb0
[ 8.113564] ext4_sync_file+0x73/0x370 [ext4]
[ 8.114607] __x64_sys_fsync+0x33/0x60
[ 8.115635] do_syscall_64+0x33/0x40
[ 8.116670] entry_SYSCALL_64_after_hwframe+0x44/0xae

Thanks for the comment from Christoph.

[1]. https://bugs.archlinux.org/task/70992

Cc: stable@vger.kernel.org # v5.12+
Reported-by: Jens Stutte <jens@chianterastutte.eu>
Tested-by: Jens Stutte <jens@chianterastutte.eu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1329,6 +1329,7 @@ static void raid1_write_request(struct m
 	struct raid1_plug_cb *plug = NULL;
 	int first_clone;
 	int max_sectors;
+	bool write_behind = false;
 
 	if (mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
@@ -1381,6 +1382,15 @@ static void raid1_write_request(struct m
 	max_sectors = r1_bio->sectors;
 	for (i = 0;  i < disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+
+		/*
+		 * The write-behind io is only attempted on drives marked as
+		 * write-mostly, which means we could allocate write behind
+		 * bio later.
+		 */
+		if (rdev && test_bit(WriteMostly, &rdev->flags))
+			write_behind = true;
+
 		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
 			atomic_inc(&rdev->nr_pending);
 			blocked_rdev = rdev;
@@ -1454,6 +1464,15 @@ static void raid1_write_request(struct m
 		goto retry_write;
 	}
 
+	/*
+	 * When using a bitmap, we may call alloc_behind_master_bio below.
+	 * alloc_behind_master_bio allocates a copy of the data payload a page
+	 * at a time and thus needs a new bio that can fit the whole payload
+	 * this bio in page sized chunks.
+	 */
+	if (write_behind && bitmap)
+		max_sectors = min_t(int, max_sectors,
+				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);


