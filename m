Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B5C499C55
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578966AbiAXWEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577801AbiAXWBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:01:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B2AC02B841;
        Mon, 24 Jan 2022 12:40:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C418B80FA3;
        Mon, 24 Jan 2022 20:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924E2C340E5;
        Mon, 24 Jan 2022 20:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056827;
        bh=DtB2ewSAb4R06N3RmFKmPjCaSnxLF0dCbGuY6M11Z6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tE77bxeB2eS73hgY8Lffp7RTY/+QVwSBF6h5r/c6eHFZVhD+SY3BzA8UIJ9W2z4tB
         boW7W8xKcw95VfNmFCRkOkiGanEDRcVV54OAK/Ko6me+pK0XZYvzjUZr/GmUY+H6c+
         TgbXNB1VoKH8B6SxNa9FkJMubS/qBurZGpzF+TOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wangyangbo <wangyangbo@uniontech.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 581/846] block: check minor range in device_add_disk()
Date:   Mon, 24 Jan 2022 19:41:38 +0100
Message-Id: <20220124184121.096162685@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit e338924bd05d6e71574bc13e310c89e10e49a8a5 ]

ioctl(fd, LOOP_CTL_ADD, 1048576) causes

  sysfs: cannot create duplicate filename '/dev/block/7:0'

message because such request is treated as if ioctl(fd, LOOP_CTL_ADD, 0)
due to MINORMASK == 1048575. Verify that all minor numbers for that device
fit in the minor range.

Reported-by: wangyangbo <wangyangbo@uniontech.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/b1b19379-23ee-5379-0eb5-94bf5f79f1b4@i-love.sakura.ne.jp
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 22f899615801c..de789d1a1e3d2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -420,6 +420,8 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
 				DISK_MAX_PARTS);
 			disk->minors = DISK_MAX_PARTS;
 		}
+		if (disk->first_minor + disk->minors > MINORMASK + 1)
+			return -EINVAL;
 	} else {
 		if (WARN_ON(disk->minors))
 			return -EINVAL;
-- 
2.34.1



