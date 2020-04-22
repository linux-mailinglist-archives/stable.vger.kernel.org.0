Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DE31B3F1C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbgDVKed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:34:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730401AbgDVKYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:24:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CE1620776;
        Wed, 22 Apr 2020 10:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551051;
        bh=0H5qTCo9MCcBp0sS1kS6EKUNGIM5n9EoGASG7YstmfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjiu8AjGRZXu8b/H1Fr/8AbUxPz9P76RsjeI4tAJcIWCucx6hDfzB4VnWepnq1ISk
         ujAFCBGY1RhIjnnUw2fH0Ky9U3oB3JuwsvoSQFQFukrZ5eyZ320n63qOMS2BtnT9dn
         kXipxx2u6UBr1iuJnESEmVknCqlVGklOsjSZ4qU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 082/166] f2fs: Fix mount failure due to SPO after a successful online resize FS
Date:   Wed, 22 Apr 2020 11:56:49 +0200
Message-Id: <20200422095057.555918140@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

[ Upstream commit 682756827501dc52593bf490f2d437c65ec9efcb ]

Even though online resize is successfully done, a SPO immediately
after resize, still causes below error in the next mount.

[   11.294650] F2FS-fs (sda8): Wrong user_block_count: 2233856
[   11.300272] F2FS-fs (sda8): Failed to get valid F2FS checkpoint

This is because after FS metadata is updated in update_fs_metadata()
if the SBI_IS_DIRTY is not dirty, then CP will not be done to reflect
the new user_block_count.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 9cff2502e3bc6..2f645c591a000 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1579,11 +1579,17 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 		goto out;
 	}
 
+	mutex_lock(&sbi->cp_mutex);
 	update_fs_metadata(sbi, -secs);
 	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
+	set_sbi_flag(sbi, SBI_IS_DIRTY);
+	mutex_unlock(&sbi->cp_mutex);
+
 	err = f2fs_sync_fs(sbi->sb, 1);
 	if (err) {
+		mutex_lock(&sbi->cp_mutex);
 		update_fs_metadata(sbi, secs);
+		mutex_unlock(&sbi->cp_mutex);
 		update_sb_metadata(sbi, secs);
 		f2fs_commit_super(sbi, false);
 	}
-- 
2.20.1



