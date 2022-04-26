Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4817A50F7FC
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346111AbiDZJK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347922AbiDZJGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80ED1B7C62;
        Tue, 26 Apr 2022 01:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11D4860C42;
        Tue, 26 Apr 2022 08:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D299C385A4;
        Tue, 26 Apr 2022 08:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962839;
        bh=eU63M2Csqic/VCKHXYjcooxY2JHvdkP4DRhbEDkReXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oni03q3bRQ7nKMcCOJU6YZkBYJM4FwrQEsMmHFRYk+dP2BFEWpX16Lmq63Jwuosw0
         Ao4SesoHEYQ/P+pB8UhmltuNFY1F9X8m2YG/LNqHhDmTZovA9VuNnW2cazUDtZfvJg
         X6iCaw/XKb+8TgSDZsRSfZMKjbKmxNzIKqlxJWgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+96b43810dfe9c3bb95ed@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 099/146] io_uring: free iovec if file assignment fails
Date:   Tue, 26 Apr 2022 10:21:34 +0200
Message-Id: <20220426081752.842825330@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 323b190ba2debbcc03c01d2edaf1ec6b43e6ae43 ]

We just return failure in this case, but we need to release the iovec
first. If we're doing IO with more than FAST_IOV segments, then the
iovec is allocated and must be freed.

Reported-by: syzbot+96b43810dfe9c3bb95ed@syzkaller.appspotmail.com
Fixes: 584b0180f0f4 ("io_uring: move read/write file prep state into actual opcode handler")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 619c67fd456d..9349d7e0754f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3622,8 +3622,10 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		iovec = NULL;
 	}
 	ret = io_rw_init_file(req, FMODE_READ);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		kfree(iovec);
 		return ret;
+	}
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
@@ -3742,8 +3744,10 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		iovec = NULL;
 	}
 	ret = io_rw_init_file(req, FMODE_WRITE);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		kfree(iovec);
 		return ret;
+	}
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
-- 
2.35.1



