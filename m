Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B5724ABAF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgHTAMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbgHTABx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:01:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E448214F1;
        Thu, 20 Aug 2020 00:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881713;
        bh=O7cbD4PDnM0EpN7J17/wF5KKMXAJKy5EqjAcay2JH+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVcIXleD3qbl0CvAumHQthB70Ku5ICH+CVrqU/HykS38hb34Rv/w0ZelwmVqr4iYc
         bk7lHGUxjHXi2XGQDCUaH7R2v/fDEN22VQmu5cz6G4ZyVb5RebMUFU7+Sp2H6BEfjs
         5XTQ2ALzT18dyke8VCGzch62wuFxtktkrTrAHj00=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        syzbot+756199124937b31a9b7e@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 26/27] fat: fix fat_ra_init() for data clusters == 0
Date:   Wed, 19 Aug 2020 20:01:15 -0400
Message-Id: <20200820000116.214821-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000116.214821-1-sashal@kernel.org>
References: <20200820000116.214821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

[ Upstream commit a090a5a7d73f79a9ae2dcc6e60d89bfc6864a65a ]

If data clusters == 0, fat_ra_init() calls the ->ent_blocknr() for the
cluster beyond ->max_clusters.

This checks the limit before initialization to suppress the warning.

Reported-by: syzbot+756199124937b31a9b7e@syzkaller.appspotmail.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/87mu462sv4.fsf@mail.parknet.co.jp
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/fatent.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index bbfe18c074179..f7e3304b78029 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -657,6 +657,9 @@ static void fat_ra_init(struct super_block *sb, struct fatent_ra *ra,
 	unsigned long ra_pages = sb->s_bdi->ra_pages;
 	unsigned int reada_blocks;
 
+	if (fatent->entry >= ent_limit)
+		return;
+
 	if (ra_pages > sb->s_bdi->io_pages)
 		ra_pages = rounddown(ra_pages, sb->s_bdi->io_pages);
 	reada_blocks = ra_pages << (PAGE_SHIFT - sb->s_blocksize_bits + 1);
-- 
2.25.1

