Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886511FE11F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbgFRB0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731649AbgFRB0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:26:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3113E20776;
        Thu, 18 Jun 2020 01:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443581;
        bh=nf9nzU35c55tX/xzhfgZMXmzLhWaHU1Nh+8LWMvq+ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nN/JeaZoC65itd9bfcNrngaSXpebAWzuAiZez1XCHoKuS8qF2zCDD7CbKW91GMEIE
         PG30Z0cCGmzgQfyrhrCCVYbDyHz3v93dYcIcfhF6uajhW6K8/QmoER67JxGT50rBh/
         eZiWt1uJJCxFAEyudg6KoYrT3nBKGG5nq2Ug6sDI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 016/108] f2fs: report delalloc reserve as non-free in statfs for project quota
Date:   Wed, 17 Jun 2020 21:24:28 -0400
Message-Id: <20200618012600.608744-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

[ Upstream commit baaa7ebf25c78c5cb712fac16b7f549100beddd3 ]

This reserved space isn't committed yet but cannot be used for
allocations. For userspace it has no difference from used space.

See the same fix in ext4 commit f06925c73942 ("ext4: report delalloc
reserve as non-free in statfs for project quota").

Fixes: ddc34e328d06 ("f2fs: introduce f2fs_statfs_project")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 2d021a33914a..89319c352406 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -918,7 +918,8 @@ static int f2fs_statfs_project(struct super_block *sb,
 		limit >>= sb->s_blocksize_bits;
 
 	if (limit && buf->f_blocks > limit) {
-		curblock = dquot->dq_dqb.dqb_curspace >> sb->s_blocksize_bits;
+		curblock = (dquot->dq_dqb.dqb_curspace +
+			    dquot->dq_dqb.dqb_rsvspace) >> sb->s_blocksize_bits;
 		buf->f_blocks = limit;
 		buf->f_bfree = buf->f_bavail =
 			(buf->f_blocks > curblock) ?
-- 
2.25.1

