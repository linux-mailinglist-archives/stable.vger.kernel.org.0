Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC713BD4D4
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbhGFMRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233525AbhGFLb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D8CE61D0C;
        Tue,  6 Jul 2021 11:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570562;
        bh=3/5VTQ67dGpVPJEXLyxieGsl4R+yGH3Nmn7z9lut5mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjiPpPo/YwwwBwodBdEUGZtHPX4vvK7CBGkwyJnjcucYI4ZrZ35b+bkcHQAPgHx5m
         ue+f4LutesGVQqSJmDfZKklCUMEN89wsHU3yuynsUBqcI2PC4YDmvmR3hy+qMUGNiE
         FiRNIjJWfp5MB/rj+ER+YdN960kpSml5RTloVS6xHFafrDieMpzbumfKH1omaYNfSt
         Nqp1vlsJ0mzItRTV4jBVL+szJxHX4c2L9GZsuykwyrMqNdcapP363ui5ru+nQCYmJz
         EpJlwkqvkTDCTu4Unp5UlUP7xOZh6yoK26YZj5VvMfMre3OOAeOLZ1zeBodznoMNza
         UnxrQ4W7Ex5Og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arturo Giusti <koredump@protonmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 029/137] udf: Fix NULL pointer dereference in udf_symlink function
Date:   Tue,  6 Jul 2021 07:20:15 -0400
Message-Id: <20210706112203.2062605-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index e169d8fe35b5..f4a72ff8cf95 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -932,6 +932,10 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
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

