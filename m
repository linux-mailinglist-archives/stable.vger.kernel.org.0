Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 640E0F47E5
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391408AbfKHLqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:46:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391404AbfKHLql (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6685F22466;
        Fri,  8 Nov 2019 11:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213601;
        bh=sFmxPLvoOWEfl00tsENoIxTweNEQt91iXnciTX2cmDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3HO6ieG/lQrpYLerhR7hr/CmzolNNz+Bn+stt7Jh4hCARSEIJQckzNYRs1knowQb
         Ig5zEiXQkZe3+v7R2p0dnUBDQ6BqNLsr2SrkANOHDE42vE1YeT6kI0Rvsk8B+qyk0i
         T25KXXaiYYYjSoNL2VXFEbUtHh0JC8L8uUXcpVCY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 40/64] f2fs: fix memory leak of percpu counter in fill_super()
Date:   Fri,  8 Nov 2019 06:45:21 -0500
Message-Id: <20191108114545.15351-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 4a70e255449c9a13eed7a6eeecc85a1ea63cef76 ]

In fill_super -> init_percpu_info, we should destroy percpu counter
in error path, otherwise memory allcoated for percpu counter will
leak.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 9eff18c1f3e46..e0ac676e0a35c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1650,8 +1650,12 @@ static int init_percpu_info(struct f2fs_sb_info *sbi)
 	if (err)
 		return err;
 
-	return percpu_counter_init(&sbi->total_valid_inode_count, 0,
+	err = percpu_counter_init(&sbi->total_valid_inode_count, 0,
 								GFP_KERNEL);
+	if (err)
+		percpu_counter_destroy(&sbi->alloc_valid_block_count);
+
+	return err;
 }
 
 /*
-- 
2.20.1

