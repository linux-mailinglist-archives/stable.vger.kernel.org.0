Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8EE676F80
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjAVPWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjAVPWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D5322DE3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:22:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A493360C6E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FE1C433EF;
        Sun, 22 Jan 2023 15:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400923;
        bh=Xea6gcJS+2b6jcjVhCWrf7/RFgQsbexQym2WGld9Czs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSVYdsiak2YKxzDYZZjyCHE4ua+mQHWjcK/CYV53bJB+G+jcUbKHm7RFjJVYI0Rrj
         nbeONg0dPVsE5wWpbjE6/cLA+1VhE7Vll54RZaySU75YN5bldEuHtOPSK+SXNg3TIY
         VoSAmkvoSDe+AkueCPFuQI8N1ZwRPNQudAMJPa5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 6.1 043/193] zonefs: Detect append writes at invalid locations
Date:   Sun, 22 Jan 2023 16:02:52 +0100
Message-Id: <20230122150248.363150680@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
@@ -442,6 +442,10 @@ static int zonefs_io_error_cb(struct blk
 			data_size = zonefs_check_zone_condition(inode, zone,
 								false, false);
 		}
+	} else if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_RO &&
+		   data_size > isize) {
+		/* Do not expose garbage data */
+		data_size = isize;
 	}
 
 	/*
@@ -805,6 +809,24 @@ static ssize_t zonefs_file_dio_append(st
 
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
 


