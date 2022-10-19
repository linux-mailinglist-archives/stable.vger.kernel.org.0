Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D098B604125
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJSKit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbiJSKi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:38:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD43D14706B;
        Wed, 19 Oct 2022 03:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD090B824DD;
        Wed, 19 Oct 2022 09:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22190C433C1;
        Wed, 19 Oct 2022 09:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170937;
        bh=j0VtTnG6a2Rj5CWn/UcXVfa2+8rJjuOPKJ8QZgolvfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrHJBRff6CRGwKMW40QEGJcV1Efjd6U8xSztnKq1LEW/bdpf6Khr4wIdTO6IIj1z7
         myeWqcyXd+YGxzHYluQm+CzN7YrBTPX4XSRcxh/fhCu6TBnaNeOhU7gHJ3YEv0p4l3
         4Fy6quk/5eu9HG4mQChk0pYUSMQap14MCf6/w3DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 843/862] io_uring/net: use io_sr_msg for sendzc
Date:   Wed, 19 Oct 2022 10:35:30 +0200
Message-Id: <20221019083327.138150833@linuxfoundation.org>
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

[ upstream commit ac9e5784bbe72f4f603d1af84760ec09bc0b5ccd ]

Reuse struct io_sr_msg for zerocopy sends, which is handy. There is
only one zerocopy specific field, namely .notif, and we have enough
space for it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/408c5b1b2d8869e1a12da5f5a78ed72cac112149.1662639236.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -60,15 +60,7 @@ struct io_sr_msg {
 	unsigned			done_io;
 	unsigned			msg_flags;
 	u16				flags;
-};
-
-struct io_sendzc {
-	struct file			*file;
-	void __user			*buf;
-	unsigned			len;
-	unsigned			done_io;
-	unsigned			msg_flags;
-	u16				flags;
+	/* used only for sendzc */
 	u16				addr_len;
 	void __user			*addr;
 	struct io_kiocb 		*notif;
@@ -188,7 +180,7 @@ static int io_sendmsg_copy_hdr(struct io
 
 int io_sendzc_prep_async(struct io_kiocb *req)
 {
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *io;
 	int ret;
 
@@ -885,7 +877,7 @@ out_free:
 
 void io_sendzc_cleanup(struct io_kiocb *req)
 {
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	zc->notif->flags |= REQ_F_CQE_SKIP;
 	io_notif_flush(zc->notif);
@@ -894,7 +886,7 @@ void io_sendzc_cleanup(struct io_kiocb *
 
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *notif;
 
@@ -1000,7 +992,7 @@ static int io_sg_from_iter(struct sock *
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address, *addr = NULL;
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;


