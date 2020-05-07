Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213A71C8E9B
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgEGO2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbgEGO2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81CEC20870;
        Thu,  7 May 2020 14:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861702;
        bh=8Shtm4idk430UQGobbDZvLe300fCi968VhfPAQDmda0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSS6IB43nfDsPmrtIIJXbfp2WdFI1JdPblqaYOB5s1xcjQGthFlO8rtuZCCxvnBgK
         krjn1v9je9JcLexujuoaolQnQTyH6aoMEGxqdbJJtKo98hB1p+vxO/BJUhpiKiiDzu
         l8UkH3tG/9u8J1TuVShCF88P3krDVAJ04+G4i++o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Yang Xu <xuyang2018.jy@cn.fujitsu.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 43/50] block: remove the bd_openers checks in blk_drop_partitions
Date:   Thu,  7 May 2020 10:27:19 -0400
Message-Id: <20200507142726.25751-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 10c70d95c0f2f9a6f52d0e33243d2877370cef51 ]

When replacing the bd_super check with a bd_openers I followed a logical
conclusion, which turns out to be utterly wrong.  When a block device has
bd_super sets it has a mount file system on it (although not every
mounted file system sets bd_super), but that also implies it doesn't even
have partitions to start with.

So instead of trying to come up with a logical check for all openers,
just remove the check entirely.

Fixes: d3ef5536274f ("block: fix busy device checking in blk_drop_partitions")
Fixes: cb6b771b05c3 ("block: fix busy device checking in blk_drop_partitions again")
Reported-by: Michal Koutný <mkoutny@suse.com>
Reported-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partition-generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index ebe4c2e9834bd..8a7906fa96fd6 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -468,7 +468,7 @@ int blk_drop_partitions(struct gendisk *disk, struct block_device *bdev)
 
 	if (!disk_part_scan_enabled(disk))
 		return 0;
-	if (bdev->bd_part_count || bdev->bd_openers > 1)
+	if (bdev->bd_part_count)
 		return -EBUSY;
 	res = invalidate_partition(disk, 0);
 	if (res)
-- 
2.20.1

