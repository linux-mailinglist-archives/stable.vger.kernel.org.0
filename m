Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F37413F34A
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391813AbgAPSlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:41:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390300AbgAPRLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 470A32468B;
        Thu, 16 Jan 2020 17:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194703;
        bh=2JHxflA3BEtDI5QcLJ6LyPWNK5cwoOxsgiMg5wbwaxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCi6FKUKKaAsKHoo7mH5bgCCIikBmlX1/KDDI12AkN85zWJpVv1sJ53MOG0HlxoB6
         QpN6L8xU/Omid01rM7eswkBzPpoVeF3bFq9w5JPvLx8XQgJ5Qms/n/1tScOqK6QiBQ
         Ms6bUgi7qLQv4D3Et/thJWzZ76fpPef9azh3GsSk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 542/671] btrfs: use correct count in btrfs_file_write_iter()
Date:   Thu, 16 Jan 2020 12:03:00 -0500
Message-Id: <20200116170509.12787-279-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d9d90f0b66d2..f4a7dac76356 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1895,7 +1895,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 	ssize_t err;
 	loff_t pos;
-	size_t count = iov_iter_count(from);
+	size_t count;
 	loff_t oldsize;
 	int clean_page = 0;
 
@@ -1916,6 +1916,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	}
 
 	pos = iocb->ki_pos;
+	count = iov_iter_count(from);
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		/*
 		 * We will allocate space in case nodatacow is not set,
-- 
2.20.1

