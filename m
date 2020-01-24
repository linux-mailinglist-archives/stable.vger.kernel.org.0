Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B409147DF2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387764AbgAXKEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:40814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730743AbgAXKEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:04:30 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF1C120709;
        Fri, 24 Jan 2020 10:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860270;
        bh=FkhOtWLcjqGbE4f2oaOmz3dOg//K5kSne0wbl2pCDck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10CY7RGRjvYREDFlrXs0j5JmdN+wJ1CXuyd1qqzvWW1sc+d9HlzJ+1PClo9HxJ3Xv
         toQvsHuTkYla3ySwuH/bNKZwXpmcP+ynmMS8jkrSRfHJq5u2x8wgMPkroQjS/Jpgsv
         BM558OfFulaGsFw9aKeQNho1Gm9ISHjTWzCKzGzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 299/343] btrfs: use correct count in btrfs_file_write_iter()
Date:   Fri, 24 Jan 2020 10:31:57 +0100
Message-Id: <20200124092959.256203698@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit c09767a8960ca0500fb636bf73686723337debf4 ]

generic_write_checks() may modify iov_iter_count(), so we must get the
count after the call, not before. Using the wrong one has a couple of
consequences:

1. We check a longer range in check_can_nocow() for nowait than we're
   actually writing.
2. We create extra hole extent maps in btrfs_cont_expand(). As far as I
   can tell, this is harmless, but I might be missing something.

These issues are pretty minor, but let's fix it before something more
important trips on it.

Fixes: edf064e7c6fe ("btrfs: nowait aio support")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 97be32da857ab..c68ce3412dc11 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1882,7 +1882,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 	ssize_t err;
 	loff_t pos;
-	size_t count = iov_iter_count(from);
+	size_t count;
 	loff_t oldsize;
 	int clean_page = 0;
 
@@ -1904,6 +1904,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	}
 
 	pos = iocb->ki_pos;
+	count = iov_iter_count(from);
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		/*
 		 * We will allocate space in case nodatacow is not set,
-- 
2.20.1



