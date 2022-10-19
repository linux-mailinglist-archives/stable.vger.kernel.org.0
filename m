Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AA46040A2
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiJSKIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiJSKH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:07:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1A11372B0;
        Wed, 19 Oct 2022 02:46:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8A9961811;
        Wed, 19 Oct 2022 09:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09EFC433C1;
        Wed, 19 Oct 2022 09:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170946;
        bh=YspMoVNdhe0Amkm/NqCNpfJEbXRl1gsIsi9AdqNL9yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6u9feQTMacoh6lmzv3TyozymyicoEpbQxAWRFCb0vDDxXbdU9AZtZgCGP1VTYkpI
         UGsuxBNux6Iykpn6nFC2FfrZVHhAu/anCY+B4thyLhx57BdCrwj5XJ50XAFTMp2voQ
         SghRGCiWIrNS909FILA9RJJ5a7E9iVWP+Y5NoADE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 845/862] io_uring/net: rename io_sendzc()
Date:   Wed, 19 Oct 2022 10:35:32 +0200
Message-Id: <20221019083327.225706381@linuxfoundation.org>
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

[ upstream commit b0e9b5517eb12fa80c72e205fe28534c2e2f39b9 ]

Simple renaming of io_sendzc*() functions in preparatio to adding
a zerocopy sendmsg variant.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/265af46829e6076dd220011b1858dc3151969226.1663668091.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c   |    6 +++---
 io_uring/net.h   |    6 +++---
 io_uring/opdef.c |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -875,7 +875,7 @@ out_free:
 	return ret;
 }
 
-void io_sendzc_cleanup(struct io_kiocb *req)
+void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 
@@ -884,7 +884,7 @@ void io_sendzc_cleanup(struct io_kiocb *
 	zc->notif = NULL;
 }
 
-int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_ring_ctx *ctx = req->ctx;
@@ -989,7 +989,7 @@ static int io_sg_from_iter(struct sock *
 	return ret;
 }
 
-int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
+int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address, *addr = NULL;
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -55,9 +55,9 @@ int io_connect_prep_async(struct io_kioc
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 
-int io_sendzc(struct io_kiocb *req, unsigned int issue_flags);
-int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-void io_sendzc_cleanup(struct io_kiocb *req);
+int io_send_zc(struct io_kiocb *req, unsigned int issue_flags);
+int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_send_zc_cleanup(struct io_kiocb *req);
 void io_send_zc_fail(struct io_kiocb *req);
 
 void io_netmsg_cache_free(struct io_cache_entry *entry);
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -490,10 +490,10 @@ const struct io_op_def io_op_defs[] = {
 		.manual_alloc		= 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
-		.prep			= io_sendzc_prep,
-		.issue			= io_sendzc,
+		.prep			= io_send_zc_prep,
+		.issue			= io_send_zc,
 		.prep_async		= io_sendzc_prep_async,
-		.cleanup		= io_sendzc_cleanup,
+		.cleanup		= io_send_zc_cleanup,
 		.fail			= io_send_zc_fail,
 #else
 		.prep			= io_eopnotsupp_prep,


