Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF66603BB5
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiJSIik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiJSIi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:38:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676997F0B1;
        Wed, 19 Oct 2022 01:37:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A151617DE;
        Wed, 19 Oct 2022 08:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1E9C433D7;
        Wed, 19 Oct 2022 08:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168657;
        bh=ZKHuwzbbayTKexEwFeJx2fK4RZ5sHCm4E9pO/aAbQDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yu5oBujCCryBOT9R41A6v5vNPWc4HQoUeiZNS+P7H1jeX5JH6B701yucSLVxTDSoF
         ZwEq0E6+SIoMCBq6UMy7y94H1uwqL9fExVIeQu4QRs7nUvyCZOOoxhxcuZIq1Hky/J
         wgpabSTQqfhUz8IhYNBYBcQL3gpMZMKVEYCEg30g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 012/862] io_uring/net: dont lose partial send/recv on fail
Date:   Wed, 19 Oct 2022 10:21:39 +0200
Message-Id: <20221019083250.547079300@linuxfoundation.org>
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

commit 7e6b638ed501cced4e472298d6b08dd16346f3a6 upstream.

Just as with rw, partial send/recv may end up in
io_req_complete_failed() and loose the result, make sure we return the
number of bytes processed.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/a4ff95897b5419356fca9ea55db91ac15b2975f9.1663668091.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c   |   10 ++++++++++
 io_uring/net.h   |    2 ++
 io_uring/opdef.c |    4 ++++
 3 files changed, 16 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1087,6 +1087,16 @@ int io_sendzc(struct io_kiocb *req, unsi
 	return IOU_OK;
 }
 
+void io_sendrecv_fail(struct io_kiocb *req)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	int res = req->cqe.res;
+
+	if (req->flags & REQ_F_PARTIAL_IO)
+		res = sr->done_io;
+	io_req_set_res(req, res, req->cqe.flags);
+}
+
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = io_kiocb_to_cmd(req, struct io_accept);
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -43,6 +43,8 @@ int io_recvmsg_prep(struct io_kiocb *req
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags);
 int io_recv(struct io_kiocb *req, unsigned int issue_flags);
 
+void io_sendrecv_fail(struct io_kiocb *req);
+
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_accept(struct io_kiocb *req, unsigned int issue_flags);
 
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -157,6 +157,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_sendmsg,
 		.prep_async		= io_sendmsg_prep_async,
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
+		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
@@ -174,6 +175,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_recvmsg,
 		.prep_async		= io_recvmsg_prep_async,
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
+		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
@@ -316,6 +318,7 @@ const struct io_op_def io_op_defs[] = {
 #if defined(CONFIG_NET)
 		.prep			= io_sendmsg_prep,
 		.issue			= io_send,
+		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
@@ -331,6 +334,7 @@ const struct io_op_def io_op_defs[] = {
 #if defined(CONFIG_NET)
 		.prep			= io_recvmsg_prep,
 		.issue			= io_recv,
+		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif


