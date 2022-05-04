Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EEF51A9A8
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242655AbiEDRSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357367AbiEDRPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687644C432;
        Wed,  4 May 2022 09:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B83D7B82737;
        Wed,  4 May 2022 16:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E647C385AA;
        Wed,  4 May 2022 16:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683498;
        bh=Cj423LBW0JOAkn2kSvevRr0JyLnJVh1uaZY7/j2THy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJBLr1i0sLreVvBVNY75i+lmR3PF0lgwFMmLi38p0O7sNktLqyCF6kYWD42/w1IfC
         RrObGg/tdS/bp27TKgrIGw7mOE1cCOUdAOmxSfwmrgl9CxzB4u3W5QmF2omzYi95JP
         rGHU8ZbBRasYtipKVv8ZPgUIV4AYTKzbWgIPuPiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Ravichandran <jravi@mit.edu>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 156/225] io_uring: fix uninitialized field in rw io_kiocb
Date:   Wed,  4 May 2022 18:46:34 +0200
Message-Id: <20220504153123.976903087@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Ravichandran <jravi@mit.edu>

[ Upstream commit 32452a3eb8b64e01e2be717f518c0be046975b9d ]

io_rw_init_file does not initialize kiocb->private, so when iocb_bio_iopoll
reads kiocb->private it can contain uninitialized data.

Fixes: 3e08773c3841 ("block: switch polling to be bio based")
Signed-off-by: Joseph Ravichandran <jravi@mit.edu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 531d0086d0b3..87df37912055 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3584,6 +3584,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
 			return -EOPNOTSUPP;
 
+		kiocb->private = NULL;
 		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
-- 
2.35.1



