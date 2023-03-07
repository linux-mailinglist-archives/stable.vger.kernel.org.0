Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7025F6AEC2A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjCGRw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbjCGRwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9DA9B2E4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:46:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF018614B2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF5DC433EF;
        Tue,  7 Mar 2023 17:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211216;
        bh=zkeuX0BT4oQflnCR/p/JWi3iPcKScckVZ5EU8niHtv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucJqigfOGewn7nM4kjU7SGvPLM05a/H5Uq4K+QIWeSBZglODMDzamM6RxUSzJp+fw
         czOAP3DRTpOhWKAC3iJFqFWodz2LC70YsnssgkG5bh8hPdsWtm3RGkLxNR8gUGxb+L
         bJC54Su5p3uBra8RKZr/i53Gv5SYpkVo5wWAIuN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Lamparter <equinox@diac24.net>,
        Eric Dumazet <edumazet@google.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 0760/1001] io_uring: remove MSG_NOSIGNAL from recvmsg
Date:   Tue,  7 Mar 2023 17:58:52 +0100
Message-Id: <20230307170054.726333255@linuxfoundation.org>
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
 io_uring/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -568,7 +568,7 @@ int io_recvmsg_prep(struct io_kiocb *req
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~(RECVMSG_FLAGS))
 		return -EINVAL;
-	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	if (sr->msg_flags & MSG_ERRQUEUE)


