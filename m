Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2EB51A9BD
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357053AbiEDRTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357711AbiEDRPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B35C4C78F;
        Wed,  4 May 2022 09:58:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 666BB61770;
        Wed,  4 May 2022 16:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A4CC385B0;
        Wed,  4 May 2022 16:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683534;
        bh=uApf3v+9kesqtJgfXozi9r+RG/9L8H2PAKWXC7sppRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=womKuCWyVAHDoom+6bd6XQuccus/Zui99EhHwGpadZ+wwMFPu/HttxVOEM9hERlK5
         Q7+dYEBVy0BEFD0v0I/80O2B/dMT6qnf4zFyWVbXnDbJMF88PSwPhTW8i2FzBtJi0X
         P6RpJXg1vf4EYS9hFFE9SLc3D7mBdrwRNUwyhJnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>, Qu Wenruo <wqu@suse.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 192/225] btrfs: fix direct I/O writes for split bios on zoned devices
Date:   Wed,  4 May 2022 18:47:10 +0200
Message-Id: <20220504153127.384584893@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 0fdf977d4576ee0decd612e22f6a837a239573cc upstream.

When a bio is split in btrfs_submit_direct, dip->file_offset contains
the file offset for the first bio.  But this means the start value used
in btrfs_end_dio_bio to record the write location for zone devices is
incorrect for subsequent bios.

CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7845,6 +7845,7 @@ static blk_status_t btrfs_submit_bio_sta
 static void btrfs_end_dio_bio(struct bio *bio)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
+	struct btrfs_bio *bbio = btrfs_bio(bio);
 	blk_status_t err = bio->bi_status;
 
 	if (err)
@@ -7855,12 +7856,12 @@ static void btrfs_end_dio_bio(struct bio
 			   bio->bi_iter.bi_size, err);
 
 	if (bio_op(bio) == REQ_OP_READ)
-		err = btrfs_check_read_dio_bio(dip, btrfs_bio(bio), !err);
+		err = btrfs_check_read_dio_bio(dip, bbio, !err);
 
 	if (err)
 		dip->dio_bio->bi_status = err;
 
-	btrfs_record_physical_zoned(dip->inode, dip->file_offset, bio);
+	btrfs_record_physical_zoned(dip->inode, bbio->file_offset, bio);
 
 	bio_put(bio);
 	btrfs_dio_private_put(dip);


