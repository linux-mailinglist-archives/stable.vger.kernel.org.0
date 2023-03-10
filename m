Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C106B4971
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbjCJPMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbjCJPMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:12:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCB71151F3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:03:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D09D061A32
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB974C433D2;
        Fri, 10 Mar 2023 15:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460587;
        bh=bNtznkHANNGICO6vyTjXG+NWodryo0S9sIbQbrjo9nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSwQ/qdX3g9EkJzj/teAndq5xOKMzmbkSeEjQ5yeafjpt/QaKJCI3tiqQd5ZUVin0
         mZzrrA9W7zCEsFfP3iZrbBDPescVOTN7qxwE5E2K/Ulzvne1mfapvEyP9pvHynnlbS
         yJe3P09M4DjKofeG5qU8JIEmVg5gNDIAV+FLptGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Lamparter <equinox@diac24.net>,
        Eric Dumazet <edumazet@google.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 377/529] io_uring: remove MSG_NOSIGNAL from recvmsg
Date:   Fri, 10 Mar 2023 14:38:40 +0100
Message-Id: <20230310133822.475053307@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Lamparter <equinox@diac24.net>

commit 7605c43d67face310b4b87dee1a28bc0c8cd8c0f upstream.

MSG_NOSIGNAL is not applicable for the receiving side, SIGPIPE is
generated when trying to write to a "broken pipe".  AF_PACKET's
packet_recvmsg() does enforce this, giving back EINVAL when MSG_NOSIGNAL
is set - making it unuseable in io_uring's recvmsg.

Remove MSG_NOSIGNAL from io_recvmsg_prep().

Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: David Lamparter <equinox@diac24.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230224150123.128346-1-equinox@diac24.net
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4995,7 +4995,7 @@ static int io_recvmsg_prep(struct io_kio
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->bgid = READ_ONCE(sqe->buf_group);
-	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 


