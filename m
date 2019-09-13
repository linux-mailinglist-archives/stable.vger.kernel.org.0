Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A602B1F89
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390543AbfIMNUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390004AbfIMNUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:20:19 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB5620717;
        Fri, 13 Sep 2019 13:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380818;
        bh=0bJ1DW8JM+Y4C+HCplu7Xiu2mhXnXnYseGHTYwA1UfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=laLHtacoR2XvB9TFQNyWet6RNBz8chixErN+70sTz67fNYoKiFgVQS9sH7zUq+N36
         d+1ByGTPVcJ8gW5ex9EImaV1QhbOR0uZ3UKIK0bHQASfPds/6Hkpe+cwwX1Scnt+3T
         4HgjEn90ayi4x0nINJGjjvjpgxUcmqXZYnNxBzVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/190] dm thin metadata: check if in fail_io mode when setting needs_check
Date:   Fri, 13 Sep 2019 14:07:01 +0100
Message-Id: <20190913130613.147957998@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



