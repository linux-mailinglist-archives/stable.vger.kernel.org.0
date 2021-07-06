Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0DB3BD255
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbhGFLmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237636AbhGFLgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8293461F5C;
        Tue,  6 Jul 2021 11:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570941;
        bh=2odLN7wD+vdTjDcW5w0x45lgq2snaTEbdf4+fpVUc7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+epCIPE2UssWLIPkDffFHJMuF/OoQUXOs8Vb0ITdn9yIwx79HiC7fcnpitjpM9OD
         CIiQ5wqtykfOaHzjUYzMEGVTg2AJHATLQdxajUnO90D3UglJDJORh0i2E/vRTCs4ex
         CkjhOVfYI6FZ4aI4Ur3QNvwS3SZOENdJb0IlMSIwqxZ0CEVcTFjSSfUYj43Pj2hk7G
         zBH+PxdGWPxyd88M2YlQDwaqY/y2eO2PUbGDdMDY9L88rrV1nWzRhCVPh2afrxAscv
         KgIDWCjNFHXdo0DzS1SHTR9ctLBhokiEYxUDzCMiUyozCZ1Qbu1yB5XSK9SnxaSRMI
         G/B5narVyKMCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arturo Giusti <koredump@protonmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 10/35] udf: Fix NULL pointer dereference in udf_symlink function
Date:   Tue,  6 Jul 2021 07:28:22 -0400
Message-Id: <20210706112848.2066036-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arturo Giusti <koredump@protonmail.com>

[ Upstream commit fa236c2b2d4436d9f19ee4e5d5924e90ffd7bb43 ]

In function udf_symlink, epos.bh is assigned with the value returned
by udf_tgetblk. The function udf_tgetblk is defined in udf/misc.c
and returns the value of sb_getblk function that could be NULL.
Then, epos.bh is used without any check, causing a possible
NULL pointer dereference when sb_getblk fails.

This fix adds a check to validate the value of epos.bh.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=213083
Signed-off-by: Arturo Giusti <koredump@protonmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/namei.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 348b922d1b6a..bfa53dead8c8 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -956,6 +956,10 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 				iinfo->i_location.partitionReferenceNum,
 				0);
 		epos.bh = udf_tgetblk(sb, block);
+		if (unlikely(!epos.bh)) {
+			err = -ENOMEM;
+			goto out_no_entry;
+		}
 		lock_buffer(epos.bh);
 		memset(epos.bh->b_data, 0x00, bsize);
 		set_buffer_uptodate(epos.bh);
-- 
2.30.2

