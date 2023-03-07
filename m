Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA796AF140
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbjCGSlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbjCGSlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:41:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C45C2239
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:32:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9B3161560
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEE3C433EF;
        Tue,  7 Mar 2023 18:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213927;
        bh=dWi15JBGD2xuVUf0ZmnTj4PidPtOupBFmg1mjwECCpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOmn8oXD3/Zc7Sh99ysuXjGCFs/KlnOSIxok9tvT9h1xGsAGURh4bPQAOn7JDOwVD
         gmhYYtAmSYnl+8CU3FpsQZlzXB7RFojXEJnveOG50Px1RNc6OGL1RM66myDkdvtsVA
         arpxmojnu7ZN9bo8+/fScDJK6T+uQzGY3URJJilQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Lamparter <equinox@diac24.net>,
        Eric Dumazet <edumazet@google.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 663/885] io_uring: remove MSG_NOSIGNAL from recvmsg
Date:   Tue,  7 Mar 2023 17:59:57 +0100
Message-Id: <20230307170030.973826647@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
 io_uring/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -553,7 +553,7 @@ int io_recvmsg_prep(struct io_kiocb *req
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~(RECVMSG_FLAGS))
 		return -EINVAL;
-	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	if (sr->msg_flags & MSG_ERRQUEUE)


