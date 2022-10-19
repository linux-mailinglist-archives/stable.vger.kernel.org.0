Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6159603BA9
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiJSIhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiJSIhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:37:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EED5F123;
        Wed, 19 Oct 2022 01:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8013617D1;
        Wed, 19 Oct 2022 08:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1212C433D6;
        Wed, 19 Oct 2022 08:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168647;
        bh=jQ+B1dF/CbazLraF4cxocdEvsIZ59fSeau73fNVHckg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRicA+L00irScEO/xZO4IdenjyAmtUYc/D8wqRrdGbaUnPoWIz2mglCNJahmdtnCe
         +Whxb1e7yvNWaXppQ1YjsLO1k2ZAA6zjnkbTMWxOKc3n5MnY849HkWd2PG/ckRwKDg
         XQNG3TuTT61DKTXuE24s+r/DCN1Zt2i6AIjwtVgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 010/862] io_uring: add custom opcode hooks on fail
Date:   Wed, 19 Oct 2022 10:21:37 +0200
Message-Id: <20221019083250.464199615@linuxfoundation.org>
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

commit a47b255e90395bdb481975ab3d9e96fcf8b3165f upstream.

Sometimes we have to do a little bit of a fixup on a request failuer in
io_req_complete_failed(). Add a callback in opdef for that.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b734cff4e67cb30cca976b9face321023f37549a.1663668091.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    4 ++++
 io_uring/opdef.h    |    1 +
 2 files changed, 5 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -823,8 +823,12 @@ inline void __io_req_complete(struct io_
 
 void io_req_complete_failed(struct io_kiocb *req, s32 res)
 {
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+
 	req_set_fail(req);
 	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
+	if (def->fail)
+		def->fail(req);
 	io_req_complete_post(req);
 }
 
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -36,6 +36,7 @@ struct io_op_def {
 	int (*issue)(struct io_kiocb *, unsigned int);
 	int (*prep_async)(struct io_kiocb *);
 	void (*cleanup)(struct io_kiocb *);
+	void (*fail)(struct io_kiocb *);
 };
 
 extern const struct io_op_def io_op_defs[];


