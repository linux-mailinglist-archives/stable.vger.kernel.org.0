Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AD04F2F8F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245205AbiDEIyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241097AbiDEIcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4E21571B;
        Tue,  5 Apr 2022 01:27:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE340B81B13;
        Tue,  5 Apr 2022 08:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DD7C385A2;
        Tue,  5 Apr 2022 08:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147242;
        bh=01hs6Q1hDIw5ZZONE7XdN8GAELW5kfxRcxOW9cXHCyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRGUnyA98zptehoKQBPEaTXudVaT0WvOfVo+imBvLFHPHPGiGBXxWBo7efedDi64C
         MZfkyZkumC3pSWaqLm204wO28u7tl+NemjfcCmA1T9dT9rJKt/jgf00bFI32rRIZad
         0rqkM62lVzVfSpXF+UOEZdCPvTVFA+KDisQeoN8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 1054/1126] io_uring: remove poll entry from list when canceling all
Date:   Tue,  5 Apr 2022 09:30:01 +0200
Message-Id: <20220405070438.404034032@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

commit 61bc84c4008812d784c398cfb54118c1ba396dfc upstream.

When the ring is exiting, as part of the shutdown, poll requests are
removed. But io_poll_remove_all() does not remove entries when finding
them, and since completions are done out-of-band, we can find and remove
the same entry multiple times.

We do guard the poll execution by poll ownership, but that does not
exclude us from reissuing a new one once the previous removal ownership
goes away.

This can race with poll execution as well, where we then end up seeing
req->apoll be NULL because a previous task_work requeue finished the
request.

Remove the poll entry when we find it and get ownership of it. This
prevents multiple invocations from finding it.

Fixes: aa43477b0402 ("io_uring: poll rework")
Reported-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5870,6 +5870,7 @@ static __cold bool io_poll_remove_all(st
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
 			if (io_match_task_safe(req, tsk, cancel_all)) {
+				hlist_del_init(&req->hash_node);
 				io_poll_cancel_req(req);
 				found = true;
 			}


