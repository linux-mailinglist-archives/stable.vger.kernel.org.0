Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0D1261AB4
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgIHSjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731324AbgIHQJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7A1E24055;
        Tue,  8 Sep 2020 15:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580111;
        bh=gfgOz1LJRRXw3d3FUaai0x8xlra370fWkb2FxVNkk8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKzjOd7aZ5XQKCvjIIoT2pXTWhwvZQ6Xk4fP2rdVW+nz/9mMCxqH68TFJWBQWJuFp
         uBjQU5LbqC/2Ym7OVafPBYq9OFJGwxmWzh4OgPoNKbxF/+8NsJxl6Z7Atijp/XbCjl
         yp7PNQiU3t2H21oLMtflXQlJfQD8pIneBXT+o53k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/88] xfs: fix boundary test in xfs_attr_shortform_verify
Date:   Tue,  8 Sep 2020 17:25:36 +0200
Message-Id: <20200908152222.839866169@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit f4020438fab05364018c91f7e02ebdd192085933 ]

The boundary test for the fixed-offset parts of xfs_attr_sf_entry in
xfs_attr_shortform_verify is off by one, because the variable array
at the end is defined as nameval[1] not nameval[].
Hence we need to subtract 1 from the calculation.

This can be shown by:

# touch file
# setfattr -n root.a file

and verifications will fail when it's written to disk.

This only matters for a last attribute which has a single-byte name
and no value, otherwise the combination of namelen & valuelen will
push endp further out and this test won't fail.

Fixes: 1e1bbd8e7ee06 ("xfs: create structure verifier function for shortform xattrs")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2652d00842d6b..087a5715cf20e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -935,8 +935,10 @@ xfs_attr_shortform_verify(
 		 * struct xfs_attr_sf_entry has a variable length.
 		 * Check the fixed-offset parts of the structure are
 		 * within the data buffer.
+		 * xfs_attr_sf_entry is defined with a 1-byte variable
+		 * array at the end, so we must subtract that off.
 		 */
-		if (((char *)sfep + sizeof(*sfep)) >= endp)
+		if (((char *)sfep + sizeof(*sfep) - 1) >= endp)
 			return __this_address;
 
 		/* Don't allow names with known bad length. */
-- 
2.25.1



