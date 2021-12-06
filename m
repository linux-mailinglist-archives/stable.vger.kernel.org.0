Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611E746A960
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350520AbhLFVRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:17:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52148 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350399AbhLFVRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:17:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A12F9B81235;
        Mon,  6 Dec 2021 21:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36871C341C1;
        Mon,  6 Dec 2021 21:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825218;
        bh=uNHdgPWM+j8p2sL5G+mJ0rzhnWOqW99l7ceUZtMdKxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDxyIw9fNhg/mkieksvsOCGc1WtiShsGO53ZB7Gq0H+0ICNYPpktInKkbpsFph3sD
         LqM7zYUPArK77fOfPTZ/L0HDBgqOjtjZtEgEkwUID6j7WrHa+/b9AoMYAywd3VZF5H
         hjj/DhWmQyVVsaPasb5EIc5lZ2R2Tv1G86P9+NMmCmcZseRdcYHktg3BxiosLvUsTp
         jXiss+GxYQHtfJHmPHE9utZPx1nrXgqRCdV8W3lkJswz1yoxjaQP2Et/xr4BVNlohH
         UNLA+y+czRpllc6c/MrFgD3NBqyzOPfu28DarR4zGlfIlWVBlWgGhgegpq95D3J5IG
         STMrKBzTMC6BQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        kernel test robot <oliver.sang@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/24] loop: Use pr_warn_once() for loop_control_remove() warning
Date:   Mon,  6 Dec 2021 16:12:15 -0500
Message-Id: <20211206211230.1660072-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit e3f9387aea67742b9d1f4de8e5bb2fd08a8a4584 ]

kernel test robot reported that RCU stall via printk() flooding is
possible [1] when stress testing.

Link: https://lkml.kernel.org/r/20211129073709.GA18483@xsang-OptiPlex-9020 [1]
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index dfc72a1f6500d..c00ae30fde89e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2429,7 +2429,7 @@ static int loop_control_remove(int idx)
 	int ret;
 
 	if (idx < 0) {
-		pr_warn("deleting an unspecified loop device is not supported.\n");
+		pr_warn_once("deleting an unspecified loop device is not supported.\n");
 		return -EINVAL;
 	}
 		
-- 
2.33.0

