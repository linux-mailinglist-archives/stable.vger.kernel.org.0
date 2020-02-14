Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CDE15F065
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388414AbgBNP55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:57:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388409AbgBNP54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA0782467E;
        Fri, 14 Feb 2020 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695875;
        bh=7fjuIQKEHWOXOCCf+k1Q0SIAfVa+9d5A3GffvBjQEhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L17f26r3zgV+TN9VhLnIf9wcDvryrR0cc3DPWuWFNjk1VIb5igwNCx5W3L2oPXpvn
         +zcQhG9UAhMjUtRBtIsYiDo/TZDyhSLT4CWDDqdaPVzBxXigEeA46MucfKN+7/5lkb
         uqjAE1Je4HJ1FfQdm/lmYygs+gU5KEh/rViMcR44=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 420/542] btrfs: safely advance counter when looking up bio csums
Date:   Fri, 14 Feb 2020 10:46:52 -0500
Message-Id: <20200214154854.6746-420-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit 4babad10198fa73fe73239d02c2e99e3333f5f5c ]

Dan's smatch tool reports

  fs/btrfs/file-item.c:295 btrfs_lookup_bio_sums()
  warn: should this be 'count == -1'

which points to the while (count--) loop. With count == 0 the check
itself could decrement it to -1. There's a WARN_ON a few lines below
that has never been seen in practice though.

It turns out that the value of page_bytes_left matches the count (by
sectorsize multiples). The loop never reaches the state where count
would go to -1, because page_bytes_left == 0 is found first and this
breaks out.

For clarity, use only plain check on count (and only for positive
value), decrement safely inside the loop. Any other discrepancy after
the whole bio list processing should be reported by the exising
WARN_ON_ONCE as well.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file-item.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index b1bfdc5c1387a..6f18333e83c33 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -274,7 +274,8 @@ static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio
 		csum += count * csum_size;
 		nblocks -= count;
 next:
-		while (count--) {
+		while (count > 0) {
+			count--;
 			disk_bytenr += fs_info->sectorsize;
 			offset += fs_info->sectorsize;
 			page_bytes_left -= fs_info->sectorsize;
-- 
2.20.1

