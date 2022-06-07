Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510E0541477
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358729AbiFGUSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376660AbiFGURA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:17:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABB01742BC;
        Tue,  7 Jun 2022 11:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA263B822C0;
        Tue,  7 Jun 2022 18:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474F6C385A5;
        Tue,  7 Jun 2022 18:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626582;
        bh=M9t8chD2hNq77zz35xqq4gXAk7I4iMh0mKRYZwsuwFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XLdy9iRSk/tn2Jj0Y7dokVhEPcmx2jr8Cd3k/tcPmmJCkFZf/v0gqREVsm/cIZpSK
         xBmJ+vCNYjM0uYOEEYZiVOGTwr3ScRlBjgmSMUY7GA1UMUQBs+KNkTgOK4vxp4dsHm
         WqVNGS3I5JxRGNcwdFwYG9UfKqdfHf31ZD8eDboI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 389/772] io_uring: avoid io-wq -EAGAIN looping for !IOPOLL
Date:   Tue,  7 Jun 2022 18:59:41 +0200
Message-Id: <20220607165000.476361122@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit e0deb6a025ae8c850dc8685be39fb27b06c88736 ]

If an opcode handler semi-reliably returns -EAGAIN, io_wq_submit_work()
might continue busily hammer the same handler over and over again, which
is not ideal. The -EAGAIN handling in question was put there only for
IOPOLL, so restrict it to IOPOLL mode only where there is no other
recourse than to retry as we cannot wait.

Fixes: def596e9557c9 ("io_uring: support for IO polling")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a0680046ff3c..26bf488096b2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6939,6 +6939,8 @@ static void io_wq_submit_work(struct io_wq_work *work)
 		 * wait for request slots on the block side.
 		 */
 		if (!needs_poll) {
+			if (!(req->ctx->flags & IORING_SETUP_IOPOLL))
+				break;
 			cond_resched();
 			continue;
 		}
-- 
2.35.1



