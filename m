Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2750475EAC
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245616AbhLORXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245498AbhLORXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1DBC061401;
        Wed, 15 Dec 2021 09:23:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA9F7B81D5C;
        Wed, 15 Dec 2021 17:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E827C36AE0;
        Wed, 15 Dec 2021 17:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588998;
        bh=uNHdgPWM+j8p2sL5G+mJ0rzhnWOqW99l7ceUZtMdKxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pz52S1ZwqEJLD1U8Eq5CRaNAWPe8gEWep5tLXO7LSN0xMkWGkL+R2nvdu22DNVmeg
         l3cIP8VmKMjSk31kMA/JZXTSJJz9U/qR1nyZMBVcnEXcbExEo8MeWZopjL+I1nnxB0
         SjtIv67opBlNkn1X24xmGQsqZ0qf5Zc4OlkcXbh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/42] loop: Use pr_warn_once() for loop_control_remove() warning
Date:   Wed, 15 Dec 2021 18:21:08 +0100
Message-Id: <20211215172027.598292349@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



