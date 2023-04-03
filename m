Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585946D4ACD
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbjDCOua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbjDCOuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F80829058
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73CD961F3D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A916C433D2;
        Mon,  3 Apr 2023 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533325;
        bh=BoB3oMBtNg/fDAUW2AA+bqEXtcZhcifO8b6Ne+d8Bkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbWHjPUqCRhlgm812hZed1wagbFZFNsDBtOm+77/Z2xU4Cr4u/RiPOMRzrm2QFqMT
         UuolaUUwKrXsFAiM3p6dqMKzeSvTzsk/Ik84rySNKxqB1+Hn1JqawOW+x1j+v4YaKj
         HMpGJ6QUALfIbuOvN2RFr1mhnNgOcXxozqhZvHf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pengfei Xu <pengfei.xu@intel.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 140/187] io_uring/poll: clear single/double poll flags on poll arming
Date:   Mon,  3 Apr 2023 16:09:45 +0200
Message-Id: <20230403140420.609619449@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 005308f7bdacf5685ed1a431244a183dbbb9e0e8 upstream.

Unless we have at least one entry queued, then don't call into
io_poll_remove_entries(). Normally this isn't possible, but if we
retry poll then we can have ->nr_entries cleared again as we're
setting it up. If this happens for a poll retry, then we'll still have
at least REQ_F_SINGLE_POLL set. io_poll_remove_entries() then thinks
it has entries to remove.

Clear REQ_F_SINGLE_POLL and REQ_F_DOUBLE_POLL unconditionally when
arming a poll request.

Fixes: c16bda37594f ("io_uring/poll: allow some retries for poll triggering spuriously")
Cc: stable@vger.kernel.org
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -724,6 +724,7 @@ int io_arm_poll_handler(struct io_kiocb
 	apoll = io_req_alloc_apoll(req, issue_flags);
 	if (!apoll)
 		return IO_APOLL_ABORTED;
+	req->flags &= ~(REQ_F_SINGLE_POLL | REQ_F_DOUBLE_POLL);
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 


