Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A19451E41
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344497AbhKPAfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344786AbhKOTZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57B36632C0;
        Mon, 15 Nov 2021 19:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003053;
        bh=GfFbanzA7JbXfM5Y+eHyHkuxrROkpziyab8MHyjJNlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prtL7yt7PPmubfavcXHmBB/IS/31vMRb8oinyPp9LRGBf/Q+cM970yhBwzuqEc/G8
         pKGqf3nfSPBHNVJO/b2ugiIPBb7r7BWXKm98o9xA1PbE2qtIqMn8eDfSrzgWI4OWnD
         HOkoF4c3VxYs6bGtyCeT8/CJSRBd30K7e7tmSFiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 793/917] block: fix device_add_disk() kobject_create_and_add() error handling
Date:   Mon, 15 Nov 2021 18:04:48 +0100
Message-Id: <20211115165455.857556511@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit fe7d064fa3faec5d8157029fb8720b4fddc9e1e8 ]

Commit 83cbce957446 ("block: add error handling for device_add_disk /
add_disk") added error handling to device_add_disk(), however the goto
label for the kobject_create_and_add() failure did not set the return
value correctly, and so we can end up in a situation where
kobject_create_and_add() fails but we report success.

Fixes: 83cbce957446 ("block: add error handling for device_add_disk / add_disk")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211103164023.1384821-1-mcgrof@kernel.org
[axboe: fold in followup fix from Wu Bo <wubo40@huawei.com>]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index ab12ae6e636e8..6accd0b185e9e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -467,11 +467,15 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
 
 	disk->part0->bd_holder_dir =
 		kobject_create_and_add("holders", &ddev->kobj);
-	if (!disk->part0->bd_holder_dir)
+	if (!disk->part0->bd_holder_dir) {
+		ret = -ENOMEM;
 		goto out_del_integrity;
+	}
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
-	if (!disk->slave_dir)
+	if (!disk->slave_dir) {
+		ret = -ENOMEM;
 		goto out_put_holder_dir;
+	}
 
 	ret = bd_register_pending_holders(disk);
 	if (ret < 0)
-- 
2.33.0



