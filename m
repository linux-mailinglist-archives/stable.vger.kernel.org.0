Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A774E40E23A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242060AbhIPQfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242247AbhIPQdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:33:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 716E3613A3;
        Thu, 16 Sep 2021 16:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809236;
        bh=v6MgzZEhp0bw1aYurSRe/URdwkX17DL7TLIvsxTY+sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJ5doReUTpBVW7jZfYA5FpFrg+A5sDSGwO7GpHYiyomqss/dUZpILw0VLMteMVmjD
         cYgwjQ3/MhlvgBIgiMe4JfB88I3KgSGPTY/FONRrvpIc8RRhC1a9TfNrzdElLbtmqJ
         KEJVhBEN/leF+lzRGXztJQTDDBi5+PHzDrm2lq4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 081/380] f2fs: fix wrong checkpoint_changed value in f2fs_remount()
Date:   Thu, 16 Sep 2021 17:57:18 +0200
Message-Id: <20210916155806.789420955@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit 277afbde6ca2b38729683fc17c031b4bc942068d ]

In f2fs_remount(), return value of test_opt() is an unsigned int type
variable, however when we compare it to a bool type variable, it cause
wrong result, fix it.

Fixes: 4354994f097d ("f2fs: checkpoint disabling")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 97e3efe5a020..d61f7fcdc66b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1966,11 +1966,10 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	bool need_restart_ckpt = false, need_stop_ckpt = false;
 	bool need_restart_flush = false, need_stop_flush = false;
 	bool no_extent_cache = !test_opt(sbi, EXTENT_CACHE);
-	bool disable_checkpoint = test_opt(sbi, DISABLE_CHECKPOINT);
+	bool enable_checkpoint = !test_opt(sbi, DISABLE_CHECKPOINT);
 	bool no_io_align = !F2FS_IO_ALIGNED(sbi);
 	bool no_atgc = !test_opt(sbi, ATGC);
 	bool no_compress_cache = !test_opt(sbi, COMPRESS_CACHE);
-	bool checkpoint_changed;
 #ifdef CONFIG_QUOTA
 	int i, j;
 #endif
@@ -2015,8 +2014,6 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	err = parse_options(sb, data, true);
 	if (err)
 		goto restore_opts;
-	checkpoint_changed =
-			disable_checkpoint != test_opt(sbi, DISABLE_CHECKPOINT);
 
 	/*
 	 * Previous and new state of filesystem is RO,
@@ -2133,7 +2130,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 		need_stop_flush = true;
 	}
 
-	if (checkpoint_changed) {
+	if (enable_checkpoint == !!test_opt(sbi, DISABLE_CHECKPOINT)) {
 		if (test_opt(sbi, DISABLE_CHECKPOINT)) {
 			err = f2fs_disable_checkpoint(sbi);
 			if (err)
-- 
2.30.2



