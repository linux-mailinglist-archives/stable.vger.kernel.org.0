Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E067F6CCD31
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 00:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjC1WZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 18:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjC1WZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 18:25:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B84610FF;
        Tue, 28 Mar 2023 15:25:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 951C561994;
        Tue, 28 Mar 2023 22:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF477C433EF;
        Tue, 28 Mar 2023 22:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680042312;
        bh=WITzyoGfnrqmrOHaJ/D5dK42sNBkCHhhLkLedHAMn1M=;
        h=Date:To:From:Subject:From;
        b=rnSOc/nhQKeT7nEo/jGThwmONvs1dP8VjbzBQHAh2hH1xBMXJPIOEchiq6fwOl6dt
         F3VojgUdVSpZtIsNIZIs14t3lWQ8+Z2g3QtZBvS9ByOzeN3UQMa98vfuRgnnM9BCIf
         W/NaDndtZwSIGxQ2EcFeSk1aK52NrEOrpDhPLU+g=
Date:   Tue, 28 Mar 2023 15:25:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        jack@suse.cz, djwong@kernel.org, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fsdax-unshare-zero-destination-if-srcmap-is-hole-or-unwritten.patch removed from -mm tree
Message-Id: <20230328222511.DF477C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: fsdax: unshare: zero destination if srcmap is HOLE or UNWRITTEN
has been removed from the -mm tree.  Its filename was
     fsdax-unshare-zero-destination-if-srcmap-is-hole-or-unwritten.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: unshare: zero destination if srcmap is HOLE or UNWRITTEN
Date: Wed, 22 Mar 2023 11:11:09 +0000

unshare copies data from source to destination.  But if the source is
HOLE or UNWRITTEN extents, we should zero the destination, otherwise
the HOLE or UNWRITTEN part will be user-visible old data of the new
allocated extent.

Found by running generic/649 while mounting with -o dax=always on pmem.

Link: https://lkml.kernel.org/r/1679483469-2-1-git-send-email-ruansy.fnst@fujitsu.com
Fixes: d984648e428b ("fsdax,xfs: port unshare to fsdax")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/dax.c~fsdax-unshare-zero-destination-if-srcmap-is-hole-or-unwritten
+++ a/fs/dax.c
@@ -1258,15 +1258,20 @@ static s64 dax_unshare_iter(struct iomap
 	/* don't bother with blocks that are not shared to start with */
 	if (!(iomap->flags & IOMAP_F_SHARED))
 		return length;
-	/* don't bother with holes or unwritten extents */
-	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
-		return length;
 
 	id = dax_read_lock();
 	ret = dax_iomap_direct_access(iomap, pos, length, &daddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
+	/* zero the distance if srcmap is HOLE or UNWRITTEN */
+	if (srcmap->flags & IOMAP_F_SHARED || srcmap->type == IOMAP_UNWRITTEN) {
+		memset(daddr, 0, length);
+		dax_flush(iomap->dax_dev, daddr, length);
+		ret = length;
+		goto out_unlock;
+	}
+
 	ret = dax_iomap_direct_access(srcmap, pos, length, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

fsdax-force-clear-dirty-mark-if-cow.patch

