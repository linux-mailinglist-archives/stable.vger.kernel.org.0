Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982482763D0
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 00:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgIWWfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 18:35:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbgIWWfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 18:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600900548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9kI0qB1hfh6tsiKhjRK0SM2DkDO7brKW16bjChfU0AQ=;
        b=hcRVGW273VQnR+T9V2wzf5HJpDo3eL8u7YXOiiYBIaiJBdUK+wxEAzXzdL2uh887JYIuqA
        C1kcrW6WEQ+cHiHURSh5v8Kc7BANvwgKCz3fmsEh2Fsr9VgpOHaHqczh8CncNXWv0eKhop
        OrYkb738PiIp8DEsfcMFVcYLOARoWBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-k5B2v6ekMraZ4A_FfY76mg-1; Wed, 23 Sep 2020 18:35:46 -0400
X-MC-Unique: k5B2v6ekMraZ4A_FfY76mg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 198F0800135;
        Wed, 23 Sep 2020 22:35:45 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0E2119D7C;
        Wed, 23 Sep 2020 22:35:44 +0000 (UTC)
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH STABLE] xfs: trim IO to found COW exent limit
Message-ID: <e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com>
Date:   Wed, 23 Sep 2020 17:35:44 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
---

I've tested this with a targeted reproducer (in next email) as well as
with xfstests.

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

