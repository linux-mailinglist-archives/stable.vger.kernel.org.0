Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF92B4F3B23
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237383AbiDELvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356269AbiDEKXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:23:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEC9BAB9E;
        Tue,  5 Apr 2022 03:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3DDC617AA;
        Tue,  5 Apr 2022 10:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE080C385A8;
        Tue,  5 Apr 2022 10:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153285;
        bh=WAcl/CMtJJoJE24n0Tw8tG1yq386lGcEloJ1rQ265JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUqjI8gl5e3O0KQDs4eb5itPpb0V1JDtvrhtEJ4jm5RQ6B83X7LxfCeOtrqVS/vjT
         O4lRmMEEWvUsc49YQeY8q9hvXoAVBkJehL1YUuSvXLrs3Jf+ADg0guw6aVzVvR1Zz1
         tq/tHF52VHCnWLdom+AydWhd4afjJhAbDMpwffkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Jaeschke <joel.jaeschke@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/599] io_uring: terminate manual loop iterator loop correctly for non-vecs
Date:   Tue,  5 Apr 2022 09:27:43 +0200
Message-Id: <20220405070303.871680061@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 5e929367468c8f97cd1ffb0417316cecfebef94b ]

The fix for not advancing the iterator if we're using fixed buffers is
broken in that it can hit a condition where we don't terminate the loop.
This results in io-wq looping forever, asking to read (or write) 0 bytes
for every subsequent loop.

Reported-by: Joel Jaeschke <joel.jaeschke@gmail.com>
Link: https://github.com/axboe/liburing/issues/549
Fixes: 16c8d2df7ec0 ("io_uring: ensure symmetry in handling iter types in loop_rw_iter()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fd188b972151..82f1311dab8e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3220,13 +3220,15 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 				ret = nr;
 			break;
 		}
+		ret += nr;
 		if (!iov_iter_is_bvec(iter)) {
 			iov_iter_advance(iter, nr);
 		} else {
-			req->rw.len -= nr;
 			req->rw.addr += nr;
+			req->rw.len -= nr;
+			if (!req->rw.len)
+				break;
 		}
-		ret += nr;
 		if (nr != iovec.iov_len)
 			break;
 	}
-- 
2.34.1



