Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83915676EED
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjAVPPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjAVPPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:15:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F3E22033
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BE7DB80B1D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EB8C433EF;
        Sun, 22 Jan 2023 15:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400551;
        bh=v9SRppU2v67R3vYQVDHsEJwJJs4kyKG8UR2qblF2UH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTrSjQu/n+rywVkUt/hH4tu0awvmEW9Tfu0amOkd+Y6/MLY7YyoT/iZ9DAPQODGwp
         Wlwg2LRXohVf/3+1m65BVxsIull70Lx29cUfeDypMm+yK7DdiedaPpMmoooXral+Ot
         ZDGNzfYbSzsgoMdMRSM0Y+v2drFbdpfZnUxPimnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 5.15 019/117] zonefs: Detect append writes at invalid locations
Date:   Sun, 22 Jan 2023 16:03:29 +0100
Message-Id: <20230122150233.483252158@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit a608da3bd730d718f2d3ebec1c26f9865f8f17ce upstream.

Using REQ_OP_ZONE_APPEND operations for synchronous writes to sequential
files succeeds regardless of the zone write pointer position, as long as
the target zone is not full. This means that if an external (buggy)
application writes to the zone of a sequential file underneath the file
system, subsequent file write() operation will succeed but the file size
will not be correct and the file will contain invalid data written by
another application.

Modify zonefs_file_dio_append() to check the written sector of an append
write (returned in bio->bi_iter.bi_sector) and return -EIO if there is a
mismatch with the file zone wp offset field. This change triggers a call
to zonefs_io_error() and a zone check. Modify zonefs_io_error_cb() to
not expose the unexpected data after the current inode size when the
errors=remount-ro mode is used. Other error modes are correctly handled
already.

Fixes: 02ef12a663c7 ("zonefs: use REQ_OP_ZONE_APPEND for sync DIO")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -402,6 +402,10 @@ static int zonefs_io_error_cb(struct blk
 			data_size = zonefs_check_zone_condition(inode, zone,
 								false, false);
 		}
+	} else if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_RO &&
+		   data_size > isize) {
+		/* Do not expose garbage data */
+		data_size = isize;
 	}
 
 	/*
@@ -765,6 +769,24 @@ static ssize_t zonefs_file_dio_append(st
 
 	ret = submit_bio_wait(bio);
 
+	/*
+	 * If the file zone was written underneath the file system, the zone
+	 * write pointer may not be where we expect it to be, but the zone
+	 * append write can still succeed. So check manually that we wrote where
+	 * we intended to, that is, at zi->i_wpoffset.
+	 */
+	if (!ret) {
+		sector_t wpsector =
+			zi->i_zsector + (zi->i_wpoffset >> SECTOR_SHIFT);
+
+		if (bio->bi_iter.bi_sector != wpsector) {
+			zonefs_warn(inode->i_sb,
+				"Corrupted write pointer %llu for zone at %llu\n",
+				wpsector, zi->i_zsector);
+			ret = -EIO;
+		}
+	}
+
 	zonefs_file_write_dio_end_io(iocb, size, ret, 0);
 	trace_zonefs_file_dio_append(inode, size, ret);
 


