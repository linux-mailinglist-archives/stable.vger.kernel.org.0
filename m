Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69636AEBF6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbjCGRum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbjCGRuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:50:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E7A9E510
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:45:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 398E5B819BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B06C433EF;
        Tue,  7 Mar 2023 17:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211110;
        bh=DNw91WgBpcZMsqJL4CBUdfiawTgNfe1yjnEpxebHFZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1bMCbRI5BaTrCXJ2xY+YfTgSMSgJZ/h6dkzYcv7QDH2IXBYu0qsgt+64O0/uNHK4
         BCwG8cazz/+fb6kLwHF/T8tJXwuqpV5RFrDnK9Lk3e7+HMLK0i0pINscWsRzMFgR+y
         nHu3mnwDydxd7kDJbWkFor2OK1KXlvqDJHJclbC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 0755/1001] io_uring: use user visible tail in io_uring_poll()
Date:   Tue,  7 Mar 2023 17:58:47 +0100
Message-Id: <20230307170054.476984756@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit c10bb64684813a326174c3eebcafb3ee5af52ca3 upstream.

We return POLLIN from io_uring_poll() depending on whether there are
CQEs for the userspace, and so we should use the user visible tail
pointer instead of a transient cached value.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/228ffcbf30ba98856f66ffdb9a6a60ead1dd96c0.1674484266.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2790,7 +2790,7 @@ static __poll_t io_uring_poll(struct fil
 	 * pushes them to do the flush.
 	 */
 
-	if (io_cqring_events(ctx) || io_has_work(ctx))
+	if (__io_cqring_events_user(ctx) || io_has_work(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;


