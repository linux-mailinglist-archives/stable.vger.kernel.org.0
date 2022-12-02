Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB401640868
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 15:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiLBO3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 09:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiLBO3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 09:29:46 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC48DC84A
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 06:29:46 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id bs21so8058864wrb.4
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 06:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KT+wmwoJ4xmvyv8AJPdg7EZCfAGG3NkfZ1EJzoGb61M=;
        b=IySSnKgN4pMacQvXsZQrwuonGjxhmHRn4mFuX9t+rcM8WulnP2h8sxGqgmwqIQG2sx
         lo6NyK3LSE0kMbtAHSkcoBHvnWQWRET+ts8bSTRWIPTSlItpvx0F7mvQXJRulfN6DDpz
         SrrxNNwCMCIPE2hvDerzH/7hLiqjK8wjYLgXl1LST/K2pig+ADxp/TA4X/gXVIkP47/9
         2G3InW1XpCOSsrmYmB8jKmkxZPVfJ8i7PLU4fa6eMbskxu0VQzfolbY5sTAWERdwQo9i
         exgSp8TeyC+fwCBb6vGx/4fRJxp56wHHG3EzwzpMlBaG9N8slkQF+ygQMm6OvKp2EMeS
         1CbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KT+wmwoJ4xmvyv8AJPdg7EZCfAGG3NkfZ1EJzoGb61M=;
        b=I5F5lmiuzNJ5tdHJiKkOfLxBzdXlbYVtTfz6jhn+0G0QpkQD0tgBcC1okUMz6o0A3Q
         DqQN0V7dhg+55wVqyj9IC/I8ReuYKzXQuk2gCSVtxxZP/+SV9aKjpzevvkdxIda8Cewl
         ksuunmF0cNLm7SwiXLtAXHd2FgJkQASydcwnvobcwD+54SraNX96oVcwMTcsZ6eask4R
         9eX/C/y1DJT+IiP7beuoYJZBWzJNA1dg+LRcV15TXF/hUDdbsTLIsCeNU8k2bk0Irrhc
         rh31KvNRtFwswzmTYG0yPuEy/HlEL13edMG67M0tD+VXJB/vnNW3cqhlL42VET0ex5Z2
         5x+g==
X-Gm-Message-State: ANoB5pnzBZI4ALwdw4rITgcVNbWjs9/lqYzOrzL0k+GZx9swGBlQEYW1
        bSCKB7avNjSU8vHXQGx/9jC0PAskJ/U=
X-Google-Smtp-Source: AA0mqf53+KZxRHVf1Bk2gkvKeru46PEvR+Co/UuBO8LRR7SI9UZxyz5HQctZmdP36l+L9DOIzyaXRw==
X-Received: by 2002:adf:eb05:0:b0:225:8c57:88d0 with SMTP id s5-20020adfeb05000000b002258c5788d0mr43992443wrn.625.1669991384352;
        Fri, 02 Dec 2022 06:29:44 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:2dd3])
        by smtp.gmail.com with ESMTPSA id n187-20020a1ca4c4000000b003d005aab31asm8956946wme.40.2022.12.02.06.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 06:29:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 2/5] io_uring: fix tw losing poll events
Date:   Fri,  2 Dec 2022 14:27:12 +0000
Message-Id: <f802e6ca1e75aca0d42a4febe8088527d9b3bd93.1669990799.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669990799.git.asml.silence@gmail.com>
References: <cover.1669990799.git.asml.silence@gmail.com>
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

[ upstream commit 539bcb57da2f58886d7d5c17134236b0ec9cd15d ]

We may never try to process a poll wake and its mask if there was
multiple wake ups racing for queueing up a tw. Force
io_poll_check_events() to update the mask by vfs_poll().

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/00344d60f8b18907171178d7cf598de71d127b0b.1668710222.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2ba42e6e0881..62e0d352c78e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5440,6 +5440,13 @@ static int io_poll_check_events(struct io_kiocb *req)
 			return 0;
 		if (v & IO_POLL_CANCEL_FLAG)
 			return -ECANCELED;
+		/*
+		 * cqe.res contains only events of the first wake up
+		 * and all others are be lost. Redo vfs_poll() to get
+		 * up to date state.
+		 */
+		if ((v & IO_POLL_REF_MASK) != 1)
+			req->result = 0;
 
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = poll->events };
-- 
2.38.1

