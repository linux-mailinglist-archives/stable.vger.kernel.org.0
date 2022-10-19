Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D1960416E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiJSKoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbiJSKnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:43:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943254330F;
        Wed, 19 Oct 2022 03:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F511B824E7;
        Wed, 19 Oct 2022 09:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A64C433C1;
        Wed, 19 Oct 2022 09:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170934;
        bh=f0d2g5W7whvr5O2/g5p6rp6VsVXxSHcsF+rMJ5dvsOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cunZMp4moJzdOEhcLbQiik2csL5VAD4dyejkOgK6/jSRpDrKLDATwKZSB5Uluz4Ap
         c3ALfW9izGGH9c+SAKUHu6dhurb3cX8fAgleCJTM5+a/cj1mZNBzhSt/IjKc1e+K4b
         b7GtM2owh9X+el5bTgfOSJiTxwZkD1Uif7psLj/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 842/862] io_uring/net: refactor io_sr_msg types
Date:   Wed, 19 Oct 2022 10:35:29 +0200
Message-Id: <20221019083327.098536439@linuxfoundation.org>
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

[ upstream commit 0b048557db761d287777360a100e1d010760d209 ]

In preparation for using struct io_sr_msg for zerocopy sends, clean up
types. First, flags can be u16 as it's provided by the userspace in u16
ioprio, as well as addr_len. This saves us 4 bytes. Also use unsigned
for size and done_io, both are as well limited to u32.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/42c2639d6385b8b2181342d2af3a42d3b1c5bcd2.1662639236.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -56,21 +56,21 @@ struct io_sr_msg {
 		struct user_msghdr __user	*umsg;
 		void __user			*buf;
 	};
+	unsigned			len;
+	unsigned			done_io;
 	unsigned			msg_flags;
-	unsigned			flags;
-	size_t				len;
-	size_t				done_io;
+	u16				flags;
 };
 
 struct io_sendzc {
 	struct file			*file;
 	void __user			*buf;
-	size_t				len;
+	unsigned			len;
+	unsigned			done_io;
 	unsigned			msg_flags;
-	unsigned			flags;
-	unsigned			addr_len;
+	u16				flags;
+	u16				addr_len;
 	void __user			*addr;
-	size_t				done_io;
 	struct io_kiocb 		*notif;
 };
 


