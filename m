Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FDC1C1521
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgEANpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731559AbgEANpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:45:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4D9C2051A;
        Fri,  1 May 2020 13:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340706;
        bh=ZFamFEIyxLFqoZps+iwlPUAC68uaCGU+cjB/GQ1R06U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3EUXcBdsPODNoMmvw2JhkGRnvkRr1NvD3lViVIXhQLxFMksdK0FtEqJypUeEAX4j
         oSPccDVFOnXuHMiFzMjK3T4AdjWZm65fhCySXUEnWpSiVusPHCjRkFNh8qaqasBii1
         O746fQdvekUn7rY+Yq2q+PwX40kBWr4wStwU4l4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 091/106] ext4: convert BUG_ONs to WARN_ONs in mballoc.c
Date:   Fri,  1 May 2020 15:24:04 +0200
Message-Id: <20200501131554.397558897@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 907ea529fc4c3296701d2bfc8b831dd2a8121a34 ]

If the in-core buddy bitmap gets corrupted (or out of sync with the
block bitmap), issue a WARN_ON and try to recover.  In most cases this
involves skipping trying to allocate out of a particular block group.
We can end up declaring the file system corrupted, which is fair,
since the file system probably should be checked before we proceed any
further.

Link: https://lore.kernel.org/r/20200414035649.293164-1-tytso@mit.edu
Google-Bug-Id: 34811296
Google-Bug-Id: 34639169
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 51a78eb65f3cf..2f7aebee1a7b4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1936,7 +1936,8 @@ void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 	int free;
 
 	free = e4b->bd_info->bb_free;
-	BUG_ON(free <= 0);
+	if (WARN_ON(free <= 0))
+		return;
 
 	i = e4b->bd_info->bb_first_free;
 
@@ -1959,7 +1960,8 @@ void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 		}
 
 		mb_find_extent(e4b, i, ac->ac_g_ex.fe_len, &ex);
-		BUG_ON(ex.fe_len <= 0);
+		if (WARN_ON(ex.fe_len <= 0))
+			break;
 		if (free < ex.fe_len) {
 			ext4_grp_locked_error(sb, e4b->bd_group, 0, 0,
 					"%d free clusters as per "
-- 
2.20.1



