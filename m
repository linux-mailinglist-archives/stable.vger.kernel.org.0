Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8572B595133
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiHPEwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbiHPEvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39313DB064;
        Mon, 15 Aug 2022 13:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C210260FC4;
        Mon, 15 Aug 2022 20:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9B3C433D6;
        Mon, 15 Aug 2022 20:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596541;
        bh=WxKy7OIihBZFfS6tzIpJMPQGFP/yMFa8G1Q4lBvrQmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9ev6CbuvQ1NPmuVW5+3qra3RXAQKblRd7qS1eXU9t+wqAmf2dD76f2pdIGpGcTeB
         LM5/LFpRXJkfkSjSJOA6eP9V1hZcBHg0Jr9EN5BiRQDve41v32o8Gyn7nJ7IiQI1KN
         AbiMifDdR/5J2mPG4/SLkw9+BW1DpzYvCEYCaZOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1111/1157] dm: fix dm-raid crash if md_handle_request() splits bio
Date:   Mon, 15 Aug 2022 20:07:47 +0200
Message-Id: <20220815180524.748652319@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 9dd1cd3220eca534f2d47afad7ce85f4c40118d8 ]

Commit ca522482e3eaf ("dm: pass NULL bdev to bio_alloc_clone")
introduced the optimization to _not_ perform bio_associate_blkg()'s
relatively costly work when DM core clones its bio. But in doing so it
exposed the possibility for DM's cloned bio to alter DM target
behavior (e.g. crash) if a target were to issue IO without first
calling bio_set_dev().

The DM raid target can trigger an MD crash due to its need to split
the DM bio that is passed to md_handle_request(). The split will
recurse to submit_bio_noacct() using a bio with an uninitialized
->bi_blkg. This NULL bio->bi_blkg causes blk_throtl_bio() to
dereference a NULL blkg_to_tg(bio->bi_blkg).

Fix this in DM core by adding a new 'needs_bio_set_dev' target flag that
will make alloc_tio() call bio_set_dev() on behalf of the target.
dm-raid is the only target that requires this flag. bio_set_dev()
initializes the DM cloned bio's ->bi_blkg, using bio_associate_blkg,
before passing the bio to md_handle_request().

Long-term fix would be to audit and refactor MD code to rely on DM to
split its bio, using dm_accept_partial_bio(), but there are MD raid
personalities (e.g. raid1 and raid10) whose implementation are tightly
coupled to handling the bio splitting inline.

Fixes: ca522482e3eaf ("dm: pass NULL bdev to bio_alloc_clone")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c          |  1 +
 drivers/md/dm.c               | 13 ++++++-------
 include/linux/device-mapper.h |  6 ++++++
 include/uapi/linux/dm-ioctl.h |  4 ++--
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index a55fc28d2a29..ba3638d1d046 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3097,6 +3097,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->private = rs;
 	ti->num_flush_bios = 1;
+	ti->needs_bio_set_dev = true;
 
 	/* Restore any requested new layout for conversion decision */
 	rs_config_restore(rs, &rs_layout);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2b75f1ef7386..36c704b50ac3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -578,9 +578,6 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	struct bio *clone;
 
 	clone = bio_alloc_clone(NULL, bio, GFP_NOIO, &md->mempools->io_bs);
-	/* Set default bdev, but target must bio_set_dev() before issuing IO */
-	clone->bi_bdev = md->disk->part0;
-
 	tio = clone_to_tio(clone);
 	tio->flags = 0;
 	dm_tio_set_flag(tio, DM_TIO_INSIDE_DM_IO);
@@ -614,6 +611,7 @@ static void free_io(struct dm_io *io)
 static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 			     unsigned target_bio_nr, unsigned *len, gfp_t gfp_mask)
 {
+	struct mapped_device *md = ci->io->md;
 	struct dm_target_io *tio;
 	struct bio *clone;
 
@@ -623,14 +621,10 @@ static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 		/* alloc_io() already initialized embedded clone */
 		clone = &tio->clone;
 	} else {
-		struct mapped_device *md = ci->io->md;
-
 		clone = bio_alloc_clone(NULL, ci->bio, gfp_mask,
 					&md->mempools->bs);
 		if (!clone)
 			return NULL;
-		/* Set default bdev, but target must bio_set_dev() before issuing IO */
-		clone->bi_bdev = md->disk->part0;
 
 		/* REQ_DM_POLL_LIST shouldn't be inherited */
 		clone->bi_opf &= ~REQ_DM_POLL_LIST;
@@ -646,6 +640,11 @@ static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 	tio->len_ptr = len;
 	tio->old_sector = 0;
 
+	/* Set default bdev, but target must bio_set_dev() before issuing IO */
+	clone->bi_bdev = md->disk->part0;
+	if (unlikely(ti->needs_bio_set_dev))
+		bio_set_dev(clone, md->disk->part0);
+
 	if (len) {
 		clone->bi_iter.bi_size = to_bytes(*len);
 		if (bio_integrity(clone))
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 47a01c7cffdf..e9c043f12e53 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -373,6 +373,12 @@ struct dm_target {
 	 * after returning DM_MAPIO_SUBMITTED from its map function.
 	 */
 	bool accounts_remapped_io:1;
+
+	/*
+	 * Set if the target will submit the DM bio without first calling
+	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
+	 */
+	bool needs_bio_set_dev:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 2e9550fef90f..27ad9671f2df 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -286,9 +286,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	46
+#define DM_VERSION_MINOR	47
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2022-02-22)"
+#define DM_VERSION_EXTRA	"-ioctl (2022-07-28)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
-- 
2.35.1



