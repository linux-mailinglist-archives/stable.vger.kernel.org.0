Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FB532AFDA
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239290AbhCCA3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241637AbhCBMg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:36:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7FE864F4F;
        Tue,  2 Mar 2021 11:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686215;
        bh=Wxn8Bvnolw8MgzDPl7y+OEVkXz02zvxeI6P2SoHE9O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exmW0HJlgXRBIhiZ2hS1t5HaFdWxhbWvuZPfVROmzYh+e3nsn32nbdTLGaxNoWI3T
         kadWbuvrOpGLQ8wmBj6Myy9hldJxifCbrdZU8jqiwIGlH5fJQb88G5bcS3zw+/kKtI
         2KiQYSEMU4SNWB9IbmCix7PAYE4NJqPMeavdU0cQlZOn+OA5an7JDWOQ+g6CyQsY+H
         IL8hpYwsuEGG+qzQ22hrDzgyTgoVcIjcskHTtS+HsgpRWj70vcGsC11D1xs5N2HF87
         UcRxxOch37QOQOiElooNZYVNcGnIc7BcQD1m3MQqxWHqzmAVCF+kcZn+pvkt86QFDi
         aFtAuet0zhWNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven J. Magnani" <magnani@ieee.org>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 06/47] udf: fix silent AED tagLocation corruption
Date:   Tue,  2 Mar 2021 06:56:05 -0500
Message-Id: <20210302115646.62291-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven J. Magnani" <magnani@ieee.org>

[ Upstream commit 63c9e47a1642fc817654a1bc18a6ec4bbcc0f056 ]

When extending a file, udf_do_extend_file() may enter following empty
indirect extent. At the end of udf_do_extend_file() we revert prev_epos
to point to the last written extent. However if we end up not adding any
further extent in udf_do_extend_file(), the reverting points prev_epos
into the header area of the AED and following updates of the extents
(in udf_update_extents()) will corrupt the header.

Make sure that we do not follow indirect extent if we are not going to
add any more extents so that returning back to the last written extent
works correctly.

Link: https://lore.kernel.org/r/20210107234116.6190-2-magnani@ieee.org
Signed-off-by: Steven J. Magnani <magnani@ieee.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index bb89c3e43212..0dd2f93ac048 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -544,11 +544,14 @@ static int udf_do_extend_file(struct inode *inode,
 
 		udf_write_aext(inode, last_pos, &last_ext->extLocation,
 				last_ext->extLength, 1);
+
 		/*
-		 * We've rewritten the last extent but there may be empty
-		 * indirect extent after it - enter it.
+		 * We've rewritten the last extent. If we are going to add
+		 * more extents, we may need to enter possible following
+		 * empty indirect extent.
 		 */
-		udf_next_aext(inode, last_pos, &tmploc, &tmplen, 0);
+		if (new_block_bytes || prealloc_len)
+			udf_next_aext(inode, last_pos, &tmploc, &tmplen, 0);
 	}
 
 	/* Managed to do everything necessary? */
-- 
2.30.1

