Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11C95921DF
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241119AbiHNPm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240750AbiHNPj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:39:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE071AF3C;
        Sun, 14 Aug 2022 08:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2F3A60D2D;
        Sun, 14 Aug 2022 15:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A0CC433C1;
        Sun, 14 Aug 2022 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491160;
        bh=WiHeptf/eanu/Vr13BE54U6jH1OAmEL/kgFHLVKmCk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o78nE1Qy6GYRTZHW8kG8wrGAKVV0/5v9LlRGGUqGe7gi6MU697ojhWSTHxPpquP0N
         mK09gpdx7gEWFtO3MtSOb4eGg28CwFQ6WBO26I66TMvKQ/SkqrU9HnVSrnoaQb88ar
         jW/cZOo8HOCumj70TFWT9xpU8G/DJaD2Jbt/TSSbw7YeSXypQeWfi0zHjBat0E4AVg
         Ejdjfll9yprbfUIdm8BvvzSdNNusUVLlWkfzWv1kHbF/9EFmamqspMe1EMBRUY8ibi
         0rjs3CjjHGo6UMLW5+X8O4P2FweEv6DfNeq3VSob4dtq9y9KyxbHiKJ1kSVMmkVpYv
         LWbk1iPO68rlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>, Song Liu <song@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 51/56] md/raid5: Make logic blocking check consistent with logic that blocks
Date:   Sun, 14 Aug 2022 11:30:21 -0400
Message-Id: <20220814153026.2377377-51-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 6e3f50d30af847bebce072182bd735e90a294c6a ]

The check in raid5_make_request differs very slightly from the logic
that causes it to block lower down. This likely does not cause a bug
as the check is fuzzy anyway (as reshape may move on between the first
check and the subsequent check). However, make it consistent so it can
be cleaned up in a subsequent patch.

The condition which causes the schedule is:

 !(mddev->reshape_backwards ? logical_sector < conf->reshape_progress :
   logical_sector >= conf->reshape_progress) &&
  (mddev->reshape_backwards ? logical_sector < conf->reshape_safe :
   logical_sector >= conf->reshape_safe)

The condition that causes the early bailout is made to match this.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0dd4679deb61..402b627139d6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5809,7 +5809,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	if ((bi->bi_opf & REQ_NOWAIT) &&
 	    (conf->reshape_progress != MaxSector) &&
 	    (mddev->reshape_backwards
-	    ? (logical_sector > conf->reshape_progress && logical_sector <= conf->reshape_safe)
+	    ? (logical_sector >= conf->reshape_progress && logical_sector < conf->reshape_safe)
 	    : (logical_sector >= conf->reshape_safe && logical_sector < conf->reshape_progress))) {
 		bio_wouldblock_error(bi);
 		if (rw == WRITE)
-- 
2.35.1

