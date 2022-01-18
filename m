Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D55491A42
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344952AbiARC7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344834AbiARCqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:46:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AE0C08EE6E;
        Mon, 17 Jan 2022 18:38:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F39E1B811D6;
        Tue, 18 Jan 2022 02:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD61C36AE3;
        Tue, 18 Jan 2022 02:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473513;
        bh=xAG+LIB8TdYti0WM8UY5bA4LxYwoy1xNB6UpM8EvH/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNwj0u4tsQJwDLnRF7VjepdN6RFrDwyNLW39imDzGkqkKXw227+KRdWsl4FGP6Vhc
         8kz0Fm/dF/RMhdto8ULAJeSOUW5h6hK8zM3uoDS5H9iZLesGAxGM+IkIFtveg7SqE9
         4mPy8n2wsjl/3JH5a4/iU4Bhp3Lp1bAC9Re16Eo1fq51avoByR0lFR3C0GyExPbJS/
         sK/X5gArSc0JDpMikQqmO81iI+1+bvSM+KIyOICcbFs+SoxD/noEmHUGHDwjGggu2N
         HcG5g4UjiZ0ZcujDm7MtPFqjpHWcQFmrzKPHUPGSOU8iMiJR3NLVpxRJep/t4LPwWg
         /5IEYOMDsaLwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        wangyangbo <wangyangbo@uniontech.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 144/188] block: check minor range in device_add_disk()
Date:   Mon, 17 Jan 2022 21:31:08 -0500
Message-Id: <20220118023152.1948105-144-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index f091a60dcf1ea..2eabe4c459fe1 100644
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

