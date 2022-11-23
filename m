Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863666358FB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbiKWKEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235763AbiKWKDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:03:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9CD11E817
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:55:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52F93B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF69C433C1;
        Wed, 23 Nov 2022 09:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197310;
        bh=hCcOxp8hsjUEilbht1UxvF/v83QNvLyRxB4jRPjcjiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOwIH+Mcma8QED5HCXv+37YyC59/kHZlBje0RdblEU7VPUYdSpNAqq3DfQOq91Qkw
         uhVEafab8jOmSwnj3GUJCsDdbcRCh2dOzKebWSkjUousLLNp9LM3Yh3vd/yZgOCfq3
         9ypD5qIDvVu6JXM50ahSmWUhcnMHQTTr9vHRdZRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 257/314] io_uring: fix tw losing poll events
Date:   Wed, 23 Nov 2022 09:51:42 +0100
Message-Id: <20221123084637.171063454@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 539bcb57da2f58886d7d5c17134236b0ec9cd15d upstream.

We may never try to process a poll wake and its mask if there was
multiple wake ups racing for queueing up a tw. Force
io_poll_check_events() to update the mask by vfs_poll().

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/00344d60f8b18907171178d7cf598de71d127b0b.1668710222.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -226,6 +226,13 @@ static int io_poll_check_events(struct i
 			return IOU_POLL_DONE;
 		if (v & IO_POLL_CANCEL_FLAG)
 			return -ECANCELED;
+		/*
+		 * cqe.res contains only events of the first wake up
+		 * and all others are be lost. Redo vfs_poll() to get
+		 * up to date state.
+		 */
+		if ((v & IO_POLL_REF_MASK) != 1)
+			req->cqe.res = 0;
 
 		/* the mask was stashed in __io_poll_execute */
 		if (!req->cqe.res) {


