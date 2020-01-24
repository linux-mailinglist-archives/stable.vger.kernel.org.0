Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774D31482CA
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404306AbgAXLay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:30:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404302AbgAXLax (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:30:53 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50166206D4;
        Fri, 24 Jan 2020 11:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865453;
        bh=jmARQAE+GIoSupim8Equ1hYy4YY2BUZw3jCc1PDbx5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hi3qQ0yQqgCnDjEhkOASAu4f1WJ2aro/cKgKc8mYhgyIkcCqOXmiqYh5o0NhgX9r5
         hLSMoHV3Dc/0y4i80eLTK8dSbYd0gK8n/0Xb8BZTuaxdpKktlnySPqhYAb85ZIWAjB
         CHZjdjoO9Mrb0tIe/2KOa5rS6IKqnnFYX8ogS+t0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 550/639] f2fs: fix wrong error injection path in inc_valid_block_count()
Date:   Fri, 24 Jan 2020 10:32:00 +0100
Message-Id: <20200124093158.081193920@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 9ea2f0be6ceaebae1518a5f897cff2645830dd95 ]

If FAULT_BLOCK type error injection is on, in inc_valid_block_count()
we may decrease sbi->alloc_valid_block_count percpu stat count
incorrectly, fix it.

Fixes: 36b877af7992 ("f2fs: Keep alloc_valid_block_count in sync")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 72d154e71bb56..6b5b685af5990 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1701,7 +1701,7 @@ static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 	if (time_to_inject(sbi, FAULT_BLOCK)) {
 		f2fs_show_injection_info(FAULT_BLOCK);
 		release = *count;
-		goto enospc;
+		goto release_quota;
 	}
 
 	/*
@@ -1741,6 +1741,7 @@ static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 
 enospc:
 	percpu_counter_sub(&sbi->alloc_valid_block_count, release);
+release_quota:
 	dquot_release_reservation_block(inode, release);
 	return -ENOSPC;
 }
-- 
2.20.1



