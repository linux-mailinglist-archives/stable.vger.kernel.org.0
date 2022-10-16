Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB00600349
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 22:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiJPUfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 16:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJPUfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 16:35:40 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BDA36DF8
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:39 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id q19so13419518edd.10
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5K9jTRW+Y/S++uWhxk4QQP6bOU9zbGUqLKPGcfq+NvY=;
        b=feth28LTtDAA0gkagnwevME7nCH5sqF+a7kj/aDy7aWgei5LcSTFP+jF7MtRR0HJNT
         pVzU+w61Nq4yYLtScV6aEC36VyFj2nF9s6DxZ12cDltf9OyoPrDcYO45TX7vB/cgGaJE
         wkdLEboXnWv4inszYfB4KYVj4IhlE9iU5pdZWfGuVyM7Ao6GAiBsfvrr3rotaKQfukkx
         qVd2fdzqmlu+pZNhN3l6a8qqROn2oOw5iyMoCEYtbNHOToRwNFjj7MVp5R27L8MV7OL4
         2pjV7duql6oNBKYsI0i1+rKA6JP6ZrFt8d9j92g3ST8jSzFNk4gbfxo4BmJcUjfe65GN
         FWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5K9jTRW+Y/S++uWhxk4QQP6bOU9zbGUqLKPGcfq+NvY=;
        b=OjajN2/+lNqAydmpsADjQRDUOKMOALNqncMHnQlu8O01QTBfd0jbX/Povt5njUyuUd
         S9hRvPN97SEIwZqjp9y5z01n3Syysk5WGyZxa8D58r2cqIR6JnV9VgrMvgPSdfN3V9HH
         FjIrvggfaWyzScXSefK9QDUQJ40lRfedRkHoow9LjgJeRirc0QnhAYT43NGnaXDpyeoK
         2+g4zNeqka/H7bkafeMUn3QQpYUXd8xXGp9A2X2yX13frg3D/aPDkTyhRg490Vvu2upR
         Mr8mLdci9ZDXsYxu4bO+vwoR7sc9OKp8AI7BjblRPSu2X+4GenpQ0xHSU5KIcDtFv0UL
         Gplg==
X-Gm-Message-State: ACrzQf12t3JZ5LCZx5b5Hz9xXQ/2gsQoi71kQCl9UCjbJUGbFsk+oSDP
        kPSDVWQDHAuRDzbgB4mfRGaPH/zq7O4=
X-Google-Smtp-Source: AMsMyM7cx3Q8A6FXIH4tNyqQteK5yT4tBNuQSHhlPTqFqXYdUnYHxL10nPYiTGcGvQ9U2UscOEHw7A==
X-Received: by 2002:a05:6402:27c9:b0:45d:4539:b462 with SMTP id c9-20020a05640227c900b0045d4539b462mr7422199ede.226.1665952537356;
        Sun, 16 Oct 2022 13:35:37 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id m3-20020a170906160300b0078194737761sm5008083ejd.124.2022.10.16.13.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:35:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-6.0 1/6] io_uring/net: refactor io_sr_msg types
Date:   Sun, 16 Oct 2022 21:33:25 +0100
Message-Id: <b14da215103e573d42100d252cfd130b7a4fbdba.1665951939.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665951939.git.asml.silence@gmail.com>
References: <cover.1665951939.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit 0b048557db761d287777360a100e1d010760d209 ]

In preparation for using struct io_sr_msg for zerocopy sends, clean up
types. First, flags can be u16 as it's provided by the userspace in u16
ioprio, as well as addr_len. This saves us 4 bytes. Also use unsigned
for size and done_io, both are as well limited to u32.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/42c2639d6385b8b2181342d2af3a42d3b1c5bcd2.1662639236.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index f1036f429156..bd9f686ba0a1 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -55,21 +55,21 @@ struct io_sr_msg {
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
 
-- 
2.38.0

