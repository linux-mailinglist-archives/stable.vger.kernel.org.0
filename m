Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634105A4E38
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiH2Neh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiH2Ned (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:33 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0564A87099
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:33 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id e13so9306131wrm.1
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=rEyuWiBsHizL3fm1YJLGC4l7TiTLdM88JTMn8FFq+xI=;
        b=P1V4/abnIJuin3mAUWWrxfo/OB3cI9A61btr1sHFyDp8h/HiRpweeIZrw5xZ8BIYVo
         dU7WSNavCincfUlCQQ4nitSQYcDssrnn+9P/RahTYVAQmgvazhTZODXiHMzvmh5Ouy8x
         WvG0/1TF36pYMxeLGliwr07i2k4wAn1tTmYoW20HVFgnQq8r9aZFVYsYDSb/tdszEpBZ
         1fj/+MszbkoqJCZ36PJJuv77igmBJzqNGew9bW45e6DNVlK0nQhDFwOkSxjYsJJjxFSb
         JBcp4RshfhzjYDiIreW9TkbmkmtGcWsgfBS1N5sG4mnyddVne+wQ9HyWIvgN1K5M6Ko7
         OIFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=rEyuWiBsHizL3fm1YJLGC4l7TiTLdM88JTMn8FFq+xI=;
        b=gneDLGKmge3wXP9WizHKHrs7EPjID8On8qSjLGzP1AWuhvzw4X3chPD2DCdMaTLrnF
         oSFU1gmlLn/ZBBMPvJ6Eue36PEYfH4VokwDeGNX3KTyeuWiQq2tMlpB08dOq2syIbLko
         XUJ2hJ+QQU+oGT1Ya7C6TjIeD+FzaUNoVSG/9GDIBYv/L/QcoT0bsO19ROQNTHDKt7MJ
         LFwlxPHuZBxH4oY8wR5UL3znoK6bUggbHHDie3BZ5qyjyuVgXEaNpkOptw3OCcf77umc
         JdADrUDqarLHFWxOiguUMCzHLewCfl4tsuzuDxbGFGsxgSNuSxnd2B8tofK7U/C+IdxH
         e0kg==
X-Gm-Message-State: ACgBeo2UMKn0GYYjDLPdUM7RnMIhQx8603aaRPyspdeoS7uPNnVMj8PD
        IBUxf4v8sy1MdDLxDf6uFAgzP7HLCKU=
X-Google-Smtp-Source: AA6agR4KpoWoRcI49aAOYCa+40Rb+R0E9CcY8AbD4DrZY09zvOVSqrSDmDq4WnE7FxLXW1yR6C/FaA==
X-Received: by 2002:a05:6000:50a:b0:225:210c:a7e4 with SMTP id a10-20020a056000050a00b00225210ca7e4mr6295530wrf.704.1661780072349;
        Mon, 29 Aug 2022 06:34:32 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 11/13] io_uring: fail links when poll fails
Date:   Mon, 29 Aug 2022 14:30:22 +0100
Message-Id: <e9e78439b420e0b502fe7db89f5424c717a7ddca.1661594698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661594698.git.asml.silence@gmail.com>
References: <cover.1661594698.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commmit c487a5ad48831afa6784b368ec40d0ee50f2fe1b ]

Don't forget to cancel all linked requests of poll request when
__io_arm_poll_handler() failed.

Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/a78aad962460f9fdfe4aa4c0b62425c88f9415bc.1655852245.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ac9fa3364c45..16b0ea1b5bf7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5838,6 +5838,8 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	ipt.pt._qproc = io_poll_queue_proc;
 
 	ret = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events);
+	if (!ret && ipt.error)
+		req_set_fail(req);
 	ret = ret ?: ipt.error;
 	if (ret)
 		__io_req_complete(req, issue_flags, ret, 0);
-- 
2.37.2

