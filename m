Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B959A6F7A
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbfICQbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731183AbfICQbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:31:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B54F223789;
        Tue,  3 Sep 2019 16:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528304;
        bh=6k6iEsk2BO6LAg9UW11D+hHtec6oooCFRqedn4k9uHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gr28huuvCaxAEwXFDbUcKEZX7v0j3ByR3yfOLwYFrAAXiiUG3z4yqROCGBGzjfjfD
         /6DXCq//6I9L7lBasJldfs5l5phOIlbV0GO1cNfNecUO/zLwQsU0v9HD72c/0XVnFj
         19AIp/f3qB6ddQS1M5ooUmXNEfKcGKP5fLPRK87s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@redhat.com>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 146/167] dm thin metadata: check if in fail_io mode when setting needs_check
Date:   Tue,  3 Sep 2019 12:24:58 -0400
Message-Id: <20190903162519.7136-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit 54fa16ee532705985e6c946da455856f18f63ee1 ]

Check if in fail_io mode at start of dm_pool_metadata_set_needs_check().
Otherwise dm_pool_metadata_set_needs_check()'s superblock_lock() can
crash in dm_bm_write_lock() while accessing the block manager object
that was previously destroyed as part of a failed
dm_pool_abort_metadata() that ultimately set fail_io to begin with.

Also, update DMERR() message to more accurately describe
superblock_lock() failure.

Cc: stable@vger.kernel.org
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-thin-metadata.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index ed3caceaed07c..6a26afcc1fd6b 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -2001,16 +2001,19 @@ int dm_pool_register_metadata_threshold(struct dm_pool_metadata *pmd,
 
 int dm_pool_metadata_set_needs_check(struct dm_pool_metadata *pmd)
 {
-	int r;
+	int r = -EINVAL;
 	struct dm_block *sblock;
 	struct thin_disk_superblock *disk_super;
 
 	down_write(&pmd->root_lock);
+	if (pmd->fail_io)
+		goto out;
+
 	pmd->flags |= THIN_METADATA_NEEDS_CHECK_FLAG;
 
 	r = superblock_lock(pmd, &sblock);
 	if (r) {
-		DMERR("couldn't read superblock");
+		DMERR("couldn't lock superblock");
 		goto out;
 	}
 
-- 
2.20.1

