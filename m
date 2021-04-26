Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F5E36AE76
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhDZHpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233045AbhDZHnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:43:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 346EE613BE;
        Mon, 26 Apr 2021 07:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422786;
        bh=KKXGXxppogMVwJKK3UMawfUkz54J6oOfZ5l1laiXOEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPajcJWigliUv+B8hINPsddMQtaamAr6SsbQNcPjE7/tM+wa8yafI4m0qoZDTqC6X
         hmlDUekgpO+lTg32J8c/goryb2UCanKDOyB26eh94PPo6kia2sw5l6aIVrnn/Cjnll
         g9JtWjsbqfvzMH2L37bdvSk95/hlReyBrQfL511c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karel Zak <kzak@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/36] block: return -EBUSY when there are open partitions in blkdev_reread_part
Date:   Mon, 26 Apr 2021 09:29:48 +0200
Message-Id: <20210426072819.003009242@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 68e6582e8f2dc32fd2458b9926564faa1fb4560e ]

The switch to go through blkdev_get_by_dev means we now ignore the
return value from bdev_disk_changed in __blkdev_get.  Add a manual
check to restore the old semantics.

Fixes: 4601b4b130de ("block: reopen the device in blkdev_reread_part")
Reported-by: Karel Zak <kzak@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210421160502.447418-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index 3be4d0e2a96c..ed240e170e14 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -98,6 +98,8 @@ static int blkdev_reread_part(struct block_device *bdev, fmode_t mode)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
+	if (bdev->bd_part_count)
+		return -EBUSY;
 
 	/*
 	 * Reopen the device to revalidate the driver state and force a
-- 
2.30.2



