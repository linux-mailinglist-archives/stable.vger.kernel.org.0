Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862BF3CA9A5
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242522AbhGOTHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242503AbhGOTGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:06:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 386B1613D4;
        Thu, 15 Jul 2021 19:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375787;
        bh=INyJeFAVFCMDDxPWIB66WGq+MIN1r+ZSRaBmZN4dAmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJk26Q+CPvn34vrA2axvbH1YwiKetLB/J2g3CAv2X7jNFTEvV+mXgjh0MaxyaIExQ
         Q5rSCqXIUEEfjZ3wJINM8McmER3tY+ZEJehrpQDM9jE+NoH5enP6wKA4IHRAX16VM7
         IRmVileBKopFSk6SMpQ6lBhD9msFyAWtKbUbZV7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.12 235/242] dm writecache: write at least 4k when committing
Date:   Thu, 15 Jul 2021 20:39:57 +0200
Message-Id: <20210715182634.215340090@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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


