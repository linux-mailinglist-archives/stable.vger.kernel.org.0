Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76F427C5A1
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgI2LhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730028AbgI2Lg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 347FB23EB4;
        Tue, 29 Sep 2020 11:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379141;
        bh=KHilziixZ3dsweEpRyzT8m7OaSAe+Q8HWApEZCDJZsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2kjNgqOXb0VAWUvW9uDdWo5QW0fzghZRIq9qeysFAEyOhUKk5VlGVDivy7vnrNr6
         c4cDhKtg01I++hrk7BfK3du3A36Zw0pcKcifcAB0CWPJhuuHxCuqy0PKOD0Z2VgVnY
         wRNz2+J+hXfmxRtNp+foeeq9esJrynwX6Xbo7jqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/388] f2fs: avoid kernel panic on corruption test
Date:   Tue, 29 Sep 2020 12:56:03 +0200
Message-Id: <20200929110012.045569210@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit bc005a4d5347da68e690f78d365d8927c87dc85a ]

xfstests/generic/475 complains kernel warn/panic while testing corrupted disk.

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 8a67b933ccd42..ed12e96681842 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2353,7 +2353,6 @@ static int __f2fs_build_free_nids(struct f2fs_sb_info *sbi,
 
 			if (ret) {
 				up_read(&nm_i->nat_tree_lock);
-				f2fs_bug_on(sbi, !mount);
 				f2fs_err(sbi, "NAT is corrupt, run fsck to fix it");
 				return ret;
 			}
-- 
2.25.1



