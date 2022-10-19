Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D6F603BB4
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiJSIik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiJSIi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:38:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E052804A7;
        Wed, 19 Oct 2022 01:37:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00B0DB822BC;
        Wed, 19 Oct 2022 08:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B53C433D6;
        Wed, 19 Oct 2022 08:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168663;
        bh=xKUNb8xzWoGBdw3o8dM2lLi+Z8ucdUJntJX38Phs4e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wev42oRaZV10GbsOZSM6QT7fG6QBfdEjQ6miniL0m8YX4AWXXn6H44anv/eRAMhp+
         oSfAgTXPytgi2edYRy+3NgWImG8WrMAE40KNgD562iFr/RpHh8ywX6zGjwT5POyOqs
         rASW2N/zRoVUMHOiCZVq6RVj9Pp6fB57DGZQ5dyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 014/862] io_uring/rw: dont lose short results on io_setup_async_rw()
Date:   Wed, 19 Oct 2022 10:21:41 +0200
Message-Id: <20221019083250.634664654@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit c278d9f8ac0db5590909e6d9e85b5ca2b786704f upstream.

If a retry io_setup_async_rw() fails we lose result from the first
io_iter_do_read(), which is a problem mostly for streams/sockets.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0e8d20cebe5fc9c96ed268463c394237daabc384.1664235732.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -794,10 +794,12 @@ int io_read(struct io_kiocb *req, unsign
 	iov_iter_restore(&s->iter, &s->iter_state);
 
 	ret2 = io_setup_async_rw(req, iovec, s, true);
-	if (ret2)
-		return ret2;
-
 	iovec = NULL;
+	if (ret2) {
+		ret = ret > 0 ? ret : ret2;
+		goto done;
+	}
+
 	io = req->async_data;
 	s = &io->s;
 	/*


