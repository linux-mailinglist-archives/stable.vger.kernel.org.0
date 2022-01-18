Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA0249162E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245657AbiARCc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46296 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244864AbiARC3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:29:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64E9A604EF;
        Tue, 18 Jan 2022 02:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C54C36AE3;
        Tue, 18 Jan 2022 02:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472942;
        bh=PpXlT6/YLztJB8/hQ39X2TcYRGZB0gx3+6C/udNnkDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qn90vsLWYBUxzyclpHUEONTI1AZGTJLY4w0hGqChasSEf3fz36vOyoHJ3tdvXcR+d
         j4ZrswD2xarRpXxKMFOhyIPmH2IAdVnDn+NLBhn95SqG8r5ahROTJD44Kxbyl/7tCm
         axc7fyzdvJbs2SwQRe9m+5xGi68Ef+JcdllaTVjexBhzN/O9QqVZul4plHluCFkNx2
         ZkM2AnpehhViCDU+ZVfTiiUcznl+wPcJGtjfbFvR1+BkJcGY3jLYjPFjeZM/1HsMgu
         +S4YbVjfhtONsywllJY+4ybvYS4z5mKXD+Z8Zux3z8A90bBg7/bI6/x2XrZeSw4hQy
         JcdTC5Evxwogg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        wangyangbo <wangyangbo@uniontech.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 170/217] block: check minor range in device_add_disk()
Date:   Mon, 17 Jan 2022 21:18:53 -0500
Message-Id: <20220118021940.1942199-170-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 30362aeacac4b..b0847f7a90c50 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -425,6 +425,8 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
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

