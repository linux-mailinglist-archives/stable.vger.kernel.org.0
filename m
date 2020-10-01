Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C54280051
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 15:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732020AbgJANkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 09:40:45 -0400
Received: from sandeen.net ([63.231.237.45]:55458 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731993AbgJANkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 09:40:45 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2020 09:40:45 EDT
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 26A8B4D1B9A;
        Thu,  1 Oct 2020 08:34:00 -0500 (CDT)
From:   Eric Sandeen <sandeen@sandeen.net>
To:     xfs <linux-xfs@vger.kernel.org>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH STABLE V2] xfs: trim IO to found COW extent limit
Message-ID: <5d2f4fc1-e498-c45e-3d57-9c2d7ac275e6@sandeen.net>
Date:   Thu, 1 Oct 2020 08:34:48 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A bug existed in the XFS reflink code between v5.1 and v5.5 in which
the mapping for a COW IO was not trimmed to the mapping of the COW
extent that was found.  This resulted in a too-short copy, and
corruption of other files which shared the original extent.

(This happened only when extent size hints were set, which bypasses
delalloc and led to this code path.)

This was (inadvertently) fixed upstream with

36adcbace24e "xfs: fill out the srcmap in iomap_begin"

and related patches which moved lots of this functionality to
the iomap subsystem.

Hence, this is a -stable only patch, targeted to fix this
corruption vector without other major code changes.

Fixes: 78f0cc9d55cb ("xfs: don't use delalloc extents for COW on files with extsize hints")
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

V2: Fix typo in subject, add reviewers

I've tested this with a targeted reproducer (in next email) as well as
with xfstests.

There is also now a testcase for xfstests submitted upstream

Stable folk, not sure how to send a "stable only" patch, or if that's even
valid.  Assuming you're willing to accept it, I would still like to have
some formal Reviewed-by's from the xfs developer community before it gets
merged.

Big thanks to Darrick & Dave for letting me whine about this bug and
offering suggestions for testing and ultimately, a patch to test.

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 06b9e0aacf54..3289d0f4bb03 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1002,9 +1002,15 @@ xfs_file_iomap_begin(
 		 * I/O, which must be block aligned, we need to report the
 		 * newly allocated address.  If the data fork has a hole, copy
 		 * the COW fork mapping to avoid allocating to the data fork.
+		 *
+		 * Otherwise, ensure that the imap range does not extend past
+		 * the range allocated/found in cmap.
 		 */
 		if (directio || imap.br_startblock == HOLESTARTBLOCK)
 			imap = cmap;
+		else
+			xfs_trim_extent(&imap, cmap.br_startoff,
+					cmap.br_blockcount);
 
 		end_fsb = imap.br_startoff + imap.br_blockcount;
 		length = XFS_FSB_TO_B(mp, end_fsb) - offset;

