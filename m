Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB5638E9FF
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhEXOwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233794AbhEXOuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47B8861400;
        Mon, 24 May 2021 14:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867661;
        bh=FfLlHbhceFQpqIb6A/9hOSiqrfjkSpTDA/qbL078WLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CP0etZ1muLb+kBM42hndnNDyzJljyAJQ1T7Powkxzz+KEVv195RaMORv7QyC9Foje
         GxI5TLSB93LoolauGxPWI3UVnsZrj3oQwt7nxpcLFBo8CbwSqarROCqoE+Pj6PK/+s
         JO9GeONCP3UEqJDXNUeMfRmZ1bEP9E90iYKKRrIx1m0zVuPs5L3dk5ysAezo+gS91o
         HNbek7QZLq0AaZwNyCrxoxdksAPoB2zAI0WL99ZJzkKcDWmcWzKlva4LsiX27h2Cvz
         +ILNgiNi0T9hLof6a0QEOJwDjMMLF4y03V169ts3LOPrghnCGGdCYgFIOnLQ1sHWhi
         34od4n7T7uvGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gulam Mohamed <gulam.mohamed@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 62/63] block: fix a race between del_gendisk and BLKRRPART
Date:   Mon, 24 May 2021 10:46:19 -0400
Message-Id: <20210524144620.2497249-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gulam Mohamed <gulam.mohamed@oracle.com>

[ Upstream commit bc6a385132601c29a6da1dbf8148c0d3c9ad36dc ]

When BLKRRPART is called concurrently with del_gendisk, the partitions
rescan can create a stale partition that will never be be cleaned up.

Fix this by checking the the disk is up before rescanning partitions
while under bd_mutex.

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210514131842.1600568-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/block_dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index a5a6a7930e5e..389609bc5aa3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1244,6 +1244,9 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 
 	lockdep_assert_held(&bdev->bd_mutex);
 
+	if (!(disk->flags & GENHD_FL_UP))
+		return -ENXIO;
+
 rescan:
 	ret = blk_drop_partitions(bdev);
 	if (ret)
-- 
2.30.2

