Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D46261D25
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731741AbgIHTc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731015AbgIHP6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:58:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1D53224DE;
        Tue,  8 Sep 2020 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579432;
        bh=RGMU6u9awNtR7uD988/rffJ2BkQdiyK7XwLpHaGK2xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYFKQ1OV6f5woOu2SCjzkPWsOhTtR/qbwlFOhs6bzz8HyRtrZIDXeIk/IRUGbGd9g
         mbMMLcQftCAEu+V7Ffw84imjA7W/XyOqL3ZqW6UIIrXP3J5SCmP3SjB8D5o976gAWf
         o4hdwxU4Tchy/4DNw+3uGLQzQi5SldJu241WxW2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 074/186] xfs: fix boundary test in xfs_attr_shortform_verify
Date:   Tue,  8 Sep 2020 17:23:36 +0200
Message-Id: <20200908152245.236842373@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
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
index 2f7e89e4be3e3..4eb2ecd31b0d2 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -996,8 +996,10 @@ xfs_attr_shortform_verify(
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



