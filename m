Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E16B3BD179
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238406AbhGFLjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237092AbhGFLfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BECC761363;
        Tue,  6 Jul 2021 11:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570727;
        bh=DXNw3JdV5Xk7dzotIKYtcXxrIDggvEiE7eo5uR+1n8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDHuEaG8phvKBPvIcyUFcqngo7mpHg3leoMLKPTZ+R0zxUlLI3+5eDxtl7EuNoe/y
         o8Lbn+jxI4Dmy8XGQ5pv1QnchA9Vm00WQcba65hESVtCZB+uALg0jLnVXtknW43ScX
         rEoh3aCg6LIDjp8q7V2n93Ia3rwmz44Hyk7G2DDjwu8mcMu/MMy4reKeV/FHuQm4/B
         SYrZnG9Eqm6TqeddP4983QBj3rsW9T3lYcN5xQVp1WiViOhrCOUJdF58Nrtq9aEzB7
         tIFA/nvUhdr2o6C5VhFyVeJD517lPosBZ2M6qjm1EBh2L82gJ1Daz9B/9czvXd/jhf
         jQSxzD1BjFpQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arturo Giusti <koredump@protonmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 19/74] udf: Fix NULL pointer dereference in udf_symlink function
Date:   Tue,  6 Jul 2021 07:24:07 -0400
Message-Id: <20210706112502.2064236-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index 77b6d89b9bcd..3c3d3b20889c 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -933,6 +933,10 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
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

