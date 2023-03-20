Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC036C178B
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbjCTPO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbjCTPO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:14:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85891302A7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:09:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E8F46159E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D89EC433D2;
        Mon, 20 Mar 2023 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324972;
        bh=EW3IUZy7H/oEoRo7wEwIx5XU9yzKL1a/g34Sm7XYNn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acytCLOGNccCUFkzzqNmjcVrQ06rcgyxC0L2cDNlc1Huv2VPp666yVGpYknPkzLng
         7T9ZvBFG7a5n4TKVPe/rV2rx7LDwYnD0CVveGwGBeXbWQW6HLy/l30nqGJnPrjpvzT
         Ll+oROpRwZyfqev1BsOwvKplWjF6QqsGnw4MrTMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 79/99] io_uring: avoid null-ptr-deref in io_arm_poll_handler
Date:   Mon, 20 Mar 2023 15:54:57 +0100
Message-Id: <20230320145446.714163290@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

No upstream commit exists for this commit.

The issue was introduced with backporting upstream commit c16bda37594f
("io_uring/poll: allow some retries for poll triggering spuriously").

Memory allocation can possibly fail causing invalid pointer be
dereferenced just before comparing it to NULL value.

Move the pointer check in proper place (upstream has the similar location
of the check). In case the request has REQ_F_POLLED flag up, apoll can't
be NULL so no need to check there.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5792,10 +5792,10 @@ static int io_arm_poll_handler(struct io
 		}
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		if (unlikely(!apoll))
+			return IO_APOLL_ABORTED;
 		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
-	if (unlikely(!apoll))
-		return IO_APOLL_ABORTED;
 	apoll->double_poll = NULL;
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;


