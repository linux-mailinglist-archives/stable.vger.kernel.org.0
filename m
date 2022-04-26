Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B054250F82C
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245475AbiDZJMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347384AbiDZJKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:10:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DD017F125;
        Tue, 26 Apr 2022 01:49:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9DF860C42;
        Tue, 26 Apr 2022 08:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20F2C385A0;
        Tue, 26 Apr 2022 08:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962980;
        bh=zMT2bqha3hiEmZn2PZkK+h5nbupE7FfoSqKxXILC13g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uyg46sB0JVQAABr512IcMJpXW6VHdiYSeYFU77JyriJ6/KYFs0j22A+Oe7BpmMDxk
         +3AqSQbwdl0sutS/KoC2XK/yHW0en1TGWA29sO38L2ZpWRp1753Z+pfGpo6KQaSQgG
         WhUMOt4SeAM+2Zkb7H6roKM2Mae6CWjmvsoiFY/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 145/146] io_uring: fix leaks on IOPOLL and CQE_SKIP
Date:   Tue, 26 Apr 2022 10:22:20 +0200
Message-Id: <20220426081754.135044907@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit c0713540f6d55c53dca65baaead55a5a8b20552d upstream.

If all completed requests in io_do_iopoll() were marked with
REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
io_free_batch_list() leaking memory and resources.

Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
return the value greater than the real one, but iopolling will deal with
it and the userspace will re-iopoll if needed. In anyway, I don't think
there are many use cases for REQ_F_CQE_SKIP + IOPOLL.

Fixes: 83a13a4181b0e ("io_uring: tweak iopoll CQE_SKIP event counting")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5072fc8693fbfd595f89e5d4305bfcfd5d2f0a64.1650186611.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2612,11 +2612,10 @@ static int io_do_iopoll(struct io_ring_c
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
+		nr_events++;
 		if (unlikely(req->flags & REQ_F_CQE_SKIP))
 			continue;
-
 		__io_fill_cqe(ctx, req->user_data, req->result, io_put_kbuf(req));
-		nr_events++;
 	}
 
 	if (unlikely(!nr_events))


