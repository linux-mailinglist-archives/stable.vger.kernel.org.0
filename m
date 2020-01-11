Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E462137DBC
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgAKKAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729064AbgAKKAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:00:46 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 724B420848;
        Sat, 11 Jan 2020 10:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736846;
        bh=QuJYVIMTRXk3gq4z/zDyeZrYy+ftsxeaBNQanbXnB+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSswi/nDOTtLK6iKOKbRcAJTnuR513ODUjkyTrYZsWddzSwPtkL0Nerr0x78DRsP7
         gBIW+/qT3flF3iDGnbHGDJYxgG1nkknDt0HNDtkVkC9HF2WEWr8qVlRJfke1xSP2es
         DNyAhi1xO6MOFaxxGtXCQVy9yw2Nm8D+dux8izLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 08/91] md: raid1: check rdev before reference in raid1_sync_request func
Date:   Sat, 11 Jan 2020 10:49:01 +0100
Message-Id: <20200111094846.192840422@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

[ Upstream commit 028288df635f5a9addd48ac4677b720192747944 ]

In raid1_sync_request func, rdev should be checked before reference.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9892c41de441..8a50da4f148f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2633,7 +2633,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 				write_targets++;
 			}
 		}
-		if (bio->bi_end_io) {
+		if (rdev && bio->bi_end_io) {
 			atomic_inc(&rdev->nr_pending);
 			bio->bi_iter.bi_sector = sector_nr + rdev->data_offset;
 			bio->bi_bdev = rdev->bdev;
-- 
2.20.1



