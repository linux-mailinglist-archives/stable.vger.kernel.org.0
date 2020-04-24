Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C092B1B7491
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgDXM1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728472AbgDXMYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3902521569;
        Fri, 24 Apr 2020 12:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731076;
        bh=WMeea+6MCD7MAA4VhVMCsTDKiVHY2X/VaHCD0d2hj8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rl3qhvbkLC5S9Lpx5AIImoJfKsJDkhMXXAYlVvStJJpmTaOI055I0uSa/OyYPWDkp
         kP7hrClN/hKgMGS6LqX6Nrc88rzPBrmAdZYhd75y5LMDinJu+1MLGN6lP2w00fs/l3
         hGOVNWKhmodflDDKQ2Guf+LfpEfOo5RtDG/GbIBg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yangerkun <yangerkun@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/21] ext4: use matching invalidatepage in ext4_writepage
Date:   Fri, 24 Apr 2020 08:24:11 -0400
Message-Id: <20200424122419.10648-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122419.10648-1-sashal@kernel.org>
References: <20200424122419.10648-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

[ Upstream commit c2a559bc0e7ed5a715ad6b947025b33cb7c05ea7 ]

Run generic/388 with journal data mode sometimes may trigger the warning
in ext4_invalidatepage. Actually, we should use the matching invalidatepage
in ext4_writepage.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200226041002.13914-1-yangerkun@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1e2edebd09295..10838b28c5bbd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2123,7 +2123,7 @@ static int ext4_writepage(struct page *page,
 	bool keep_towrite = false;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb)))) {
-		ext4_invalidatepage(page, 0, PAGE_SIZE);
+		inode->i_mapping->a_ops->invalidatepage(page, 0, PAGE_SIZE);
 		unlock_page(page);
 		return -EIO;
 	}
-- 
2.20.1

