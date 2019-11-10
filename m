Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4F8F6291
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbfKJCoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:42786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728463AbfKJCn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 851D921924;
        Sun, 10 Nov 2019 02:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353839;
        bh=Clahr9tyx0YwPFKHVEbZpyqfQUlA1RpfBoLTc9F30ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbDpAkUpmKX84ZKLdP8GPAvdUWpc2x0As5G6GMZA37ZG1O33lyG24wpgJhoAhAm5/
         67gqFjdJvwFupfz5Do9A3/I7J++LyT1Ar73cDZvAjEJJtR79x5Dz9TFqQB+zbifYxA
         M9BvZ/uLwlg370PpSN19Vv18y6uePHZCWlBJ4cGw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@gmx.com>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 128/191] f2fs: fix remount problem of option io_bits
Date:   Sat,  9 Nov 2019 21:39:10 -0500
Message-Id: <20191110024013.29782-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@gmx.com>

[ Upstream commit c6b1867b1da3b1203b4c49988afeebdcbdf65499 ]

Currently we show mount option "io_bits=%u" as "io_size=%uKB",
it will cause option parsing problem(unrecognized mount option)
in remount.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index d9106bbe7df63..c3f07171a5ab9 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1336,7 +1336,8 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 				from_kgid_munged(&init_user_ns,
 					F2FS_OPTION(sbi).s_resgid));
 	if (F2FS_IO_SIZE_BITS(sbi))
-		seq_printf(seq, ",io_size=%uKB", F2FS_IO_SIZE_KB(sbi));
+		seq_printf(seq, ",io_bits=%u",
+				F2FS_OPTION(sbi).write_io_size_bits);
 #ifdef CONFIG_F2FS_FAULT_INJECTION
 	if (test_opt(sbi, FAULT_INJECTION)) {
 		seq_printf(seq, ",fault_injection=%u",
-- 
2.20.1

