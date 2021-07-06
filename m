Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB0C3BD221
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbhGFLlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237492AbhGFLgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B224D61F03;
        Tue,  6 Jul 2021 11:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570888;
        bh=3IVAtzPpxoEBVV2EqKmnxyEFuGzcWDzdLnb0XTy4L4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcYeJYB1Lj092JR+sQQyetyHyHZGJGSasy7OvoMnOauV8zexBqidtaV/EuGWmnGOJ
         p4s3+nISQgAB56wRP0acgywIdERM4zoDn04VThyvCxeAZd2qJrH5VJ+Ie5S+QKbhmY
         p0jT6E4wycVvZYvx0gef9ds7J8LQz+MWu+ZfrPoCyH6uleD/iBYiJ2Xl8zoTDZ8WF1
         URslWVkXrTuT5VklWyBvE9z9zSoAmr1+HPZar+xF4x4Zf/X1B2PspeXHpDyHbZzNxQ
         keIsJyp4TOBFsnlnQoKz+QYYn0MVSMPTVDWQ3zTpMEvj3OLYImb8WP6G37zPAqvFbV
         O/M5fOW9nPtJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arturo Giusti <koredump@protonmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 14/45] udf: Fix NULL pointer dereference in udf_symlink function
Date:   Tue,  6 Jul 2021 07:27:18 -0400
Message-Id: <20210706112749.2065541-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112749.2065541-1-sashal@kernel.org>
References: <20210706112749.2065541-1-sashal@kernel.org>
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
index 041bf34f781f..d5516f025bad 100644
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

