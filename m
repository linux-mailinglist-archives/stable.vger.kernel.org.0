Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2676CCD34
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 00:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjC1WZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 18:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjC1WZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 18:25:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF19171E;
        Tue, 28 Mar 2023 15:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82D21B81EB2;
        Tue, 28 Mar 2023 22:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30206C433D2;
        Tue, 28 Mar 2023 22:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680042313;
        bh=+lypxTy0q7e7ELOKodrhU4n64vhRM79Rt7v20DF/RNY=;
        h=Date:To:From:Subject:From;
        b=Kq1OdTGvr8mMzxjxGPsB+pRpKiuWkPr7Vbt8QZA9vVdLt05cKPgXyI/heE+5d4T7v
         x6mp0t2q5+DOwb0NsGLPfnMtFDfY0O0BDNyhhkMAwZ7uE+47GxcrpEmSS6ToxPawQI
         t7/en3mX0Eqy5SXN9DahSNS3omMB0XqrPyuTQK1Q=
Date:   Tue, 28 Mar 2023 15:25:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, jack@suse.cz, djwong@kernel.org,
        dan.j.williams@intel.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fsdax-dedupe-should-compare-the-min-of-two-iters-length.patch removed from -mm tree
Message-Id: <20230328222513.30206C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: fsdax: dedupe should compare the min of two iters' length
has been removed from the -mm tree.  Its filename was
     fsdax-dedupe-should-compare-the-min-of-two-iters-length.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: dedupe should compare the min of two iters' length
Date: Wed, 22 Mar 2023 07:25:58 +0000

In an dedupe comparison iter loop, the length of iomap_iter decreases
because it implies the remaining length after each iteration.

The dedupe command will fail with -EIO if the range is larger than one 
page size and not aligned to the page size.  Also report warning in dmesg:

[ 4338.498374] ------------[ cut here ]------------
[ 4338.498689] WARNING: CPU: 3 PID: 1415645 at fs/iomap/iter.c:16 
...

The compare function should use the min length of the current iters,
not the total length.

Link: https://lkml.kernel.org/r/1679469958-2-1-git-send-email-ruansy.fnst@fujitsu.com
Fixes: 0e79e3736d54 ("fsdax: dedupe: iter two files at the same time")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/dax.c~fsdax-dedupe-should-compare-the-min-of-two-iters-length
+++ a/fs/dax.c
@@ -2027,8 +2027,8 @@ int dax_dedupe_file_range_compare(struct
 
 	while ((ret = iomap_iter(&src_iter, ops)) > 0 &&
 	       (ret = iomap_iter(&dst_iter, ops)) > 0) {
-		compared = dax_range_compare_iter(&src_iter, &dst_iter, len,
-						  same);
+		compared = dax_range_compare_iter(&src_iter, &dst_iter,
+				min(src_iter.len, dst_iter.len), same);
 		if (compared < 0)
 			return ret;
 		src_iter.processed = dst_iter.processed = compared;
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

fsdax-force-clear-dirty-mark-if-cow.patch

