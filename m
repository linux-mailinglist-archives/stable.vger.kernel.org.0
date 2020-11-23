Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8338E2C0941
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388121AbgKWNFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387584AbgKWMuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 751F7204EF;
        Mon, 23 Nov 2020 12:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135820;
        bh=x68gLZakTnqwMyJegYTFkrTYXgdQC8zKLEhVVWX5rWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=se/Z4TA/5FQ9Jdw1fV9+T945NjQPZ0gpLD3qMMiw1aSJQb0dFeT3/f+QRL+S0EirB
         u2GZq671DxQCG2BIlmUsF24g16AtfNX/hLl6oDnqeyuCVcvWL01igrzhLRbUqkg0ZA
         knznMMf2CyeTjcU7uS5ZBy3pY2JFZy8D/TLDP3j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dennis Gilmore <dgilmore@redhat.com>
Subject: [PATCH 5.9 206/252] xfs: fix forkoff miscalculation related to XFS_LITINO(mp)
Date:   Mon, 23 Nov 2020 13:22:36 +0100
Message-Id: <20201123121845.504437920@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit ada49d64fb3538144192181db05de17e2ffc3551 upstream.

Currently, commit e9e2eae89ddb dropped a (int) decoration from
XFS_LITINO(mp), and since sizeof() expression is also involved,
the result of XFS_LITINO(mp) is simply as the size_t type
(commonly unsigned long).

Considering the expression in xfs_attr_shortform_bytesfit():
  offset = (XFS_LITINO(mp) - bytes) >> 3;
let "bytes" be (int)340, and
    "XFS_LITINO(mp)" be (unsigned long)336.

on 64-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 3 =
           (int)(0xfffffffffffffffcUL >> 3) = -1

but on 32-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 3 =
           (int)(0xfffffffcUL >> 3) = 0x1fffffff
instead.

so offset becomes a large positive number on 32-bit platform, and
cause xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.

Therefore, one result is
  "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"

assertion failure in xfs_idata_realloc(), which was also the root
cause of the original bugreport from Dennis, see:
   https://bugzilla.redhat.com/show_bug.cgi?id=1894177

And it can also be manually triggered with the following commands:
  $ touch a;
  $ setfattr -n user.0 -v "`seq 0 80`" a;
  $ setfattr -n user.1 -v "`seq 0 80`" a

on 32-bit platform.

Fix the case in xfs_attr_shortform_bytesfit() by bailing out
"XFS_LITINO(mp) < bytes" in advance suggested by Eric and a misleading
comment together with this bugfix suggested by Darrick. It seems the
other users of XFS_LITINO(mp) are not impacted.

Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
Cc: <stable@vger.kernel.org> # 5.7+
Reported-and-tested-by: Dennis Gilmore <dgilmore@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/libxfs/xfs_attr_leaf.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -515,7 +515,7 @@ xfs_attr_copy_value(
  *========================================================================*/
 
 /*
- * Query whether the requested number of additional bytes of extended
+ * Query whether the total requested number of attr fork bytes of extended
  * attribute space will be able to fit inline.
  *
  * Returns zero if not, else the di_forkoff fork offset to be used in the
@@ -535,6 +535,12 @@ xfs_attr_shortform_bytesfit(
 	int			maxforkoff;
 	int			offset;
 
+	/*
+	 * Check if the new size could fit at all first:
+	 */
+	if (bytes > XFS_LITINO(mp))
+		return 0;
+
 	/* rounded down */
 	offset = (XFS_LITINO(mp) - bytes) >> 3;
 


