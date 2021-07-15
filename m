Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239CA3CAB92
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242807AbhGOTUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244463AbhGOTSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:18:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E95B8613D8;
        Thu, 15 Jul 2021 19:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376407;
        bh=INyJeFAVFCMDDxPWIB66WGq+MIN1r+ZSRaBmZN4dAmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKy9RZk3p6WyNvymFUhHIgsySy58zGF28g/ETcNXS2NP8Ko66XqPUoSmmxzzqc7s9
         +KXCQ+Q3fdSJEEvwwcLx1I/mS9LM50ttKipxUIzPiStqM6/VYpMhOHxhfpHrOIX4L8
         prTHZvx1J14UgDt3H02xd0348WOyhnXcShqvsOoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.13 259/266] dm writecache: write at least 4k when committing
Date:   Thu, 15 Jul 2021 20:40:14 +0200
Message-Id: <20210715182652.968417796@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 867de40c4c23e6d7f89f9ce4272a5d1b1484c122 upstream.

SSDs perform badly with sub-4k writes (because they perfrorm
read-modify-write internally), so make sure writecache writes at least
4k when committing.

Fixes: 991bd8d7bc78 ("dm writecache: commit just one block, not a full page")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-writecache.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -532,7 +532,11 @@ static void ssd_commit_superblock(struct
 
 	region.bdev = wc->ssd_dev->bdev;
 	region.sector = 0;
-	region.count = wc->block_size >> SECTOR_SHIFT;
+	region.count = max(4096U, wc->block_size) >> SECTOR_SHIFT;
+
+	if (unlikely(region.sector + region.count > wc->metadata_sectors))
+		region.count = wc->metadata_sectors - region.sector;
+
 	region.sector += wc->start_sector;
 
 	req.bi_op = REQ_OP_WRITE;


