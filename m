Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C761C11B02C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732206AbfLKPU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732335AbfLKPU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C13C22B48;
        Wed, 11 Dec 2019 15:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077625;
        bh=kw+8dI2Z7YoHHjMZvHp/R8yQvWbCgW29BW61cTpfwO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDSfBe5PwYQwCzFbefVBjrToSl2JVvhrNG/+e8LWMZksYbbpHomnJ9NFqx20cE1Vf
         UmjR6/O6D4NAOxHN3I/TipBXHrrg/h52T5ySShzDD0RIltMIY7DBlBNqqkFrJqSNSx
         9zrPmUU3dR/nKESQhw2ibIe0ZMHUYdeBBl7zXnvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/243] f2fs: fix to allow node segment for GC by ioctl path
Date:   Wed, 11 Dec 2019 16:04:29 +0100
Message-Id: <20191211150346.353552515@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

[ Upstream commit 08ac9a3870f6babb2b1fff46118536ca8a71ef19 ]

Allow node type segments also to be GC'd via f2fs ioctl
F2FS_IOC_GARBAGE_COLLECT_RANGE.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 3d98e909201d9..700c39ec99f5a 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -318,8 +318,7 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 	p.min_cost = get_max_cost(sbi, &p);
 
 	if (*result != NULL_SEGNO) {
-		if (IS_DATASEG(get_seg_entry(sbi, *result)->type) &&
-			get_valid_blocks(sbi, *result, false) &&
+		if (get_valid_blocks(sbi, *result, false) &&
 			!sec_usage_check(sbi, GET_SEC_FROM_SEG(sbi, *result)))
 			p.min_segno = *result;
 		goto out;
-- 
2.20.1



