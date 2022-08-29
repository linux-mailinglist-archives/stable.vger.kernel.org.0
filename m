Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2075A4E3A
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiH2Nei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiH2Neg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:36 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5142C422F3
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:35 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e20so10184698wri.13
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=yI3VZuzBKR2m2h5ig7+PGXvd7mMSvnNYyPB5EvoEef4=;
        b=aVfHAGcYLqUZdkq1lDrQQlf+TseU77gG8TI/1vUeO58Tbw2oxJg/zNs7PNxiqO0Hbn
         TYsc8psI1nVhmN0d2GNQJtiZR3KS8ANWRBeaoLEv4DQ6PTcqR9pQ/r23SSO1fMaEjQMB
         W7LwCg48Eq84q+s9P4ZvCxnqvq8brMGOEj2FFB2UOs7Y7sgX1WnSKuWDFYZZ336N+1lQ
         iS6wsTwFtMiZGeUqfhJxRKxB3RwDCZbhprcxOWoaKG4UiqhT68bmATKOSLhD+/WF82Dv
         ZnB5+WS3miv0fR/Owz0CcrK5sYHbD++1m/Za2Ig/8Q3iZO9HFcv20d/8DV9ZcPhUva6C
         OlTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=yI3VZuzBKR2m2h5ig7+PGXvd7mMSvnNYyPB5EvoEef4=;
        b=5BSYZj3bUEnLt3ZjHV9B4DyuxiIvhYyo1mpJNoToF9YxS2EwBCgVvXJb6tkaI6bLbe
         xB13BiHJ0qLUR4esuWx5Mrx35zTAgPbw9WmAwOvPTDum8IRYlW7ptmMIFRv6XAFohvCS
         ymY8T7E9Fj7clLZetrfvp1VKH3F0w+s8667va+O9/YVs1vlhKRL7XXSaTDUw1UGzkeqY
         JeA+xfW9MN+PBZ0uLn4L2Twl16dP77JCGB8IMcP1rSCd0ZsQfI6+DDzQ/6HJhLaXjXGS
         N4FuFiflg0JFUnG+F0dsZdArOpXVaEEW3vXSLOfDG0Y5Q187QDnkYYF0LzKf1zsULDzm
         oKMg==
X-Gm-Message-State: ACgBeo3Zr3TcnTzxfPEZjuEXiF5NJWf5bmwzCpnBDRkqp9oTQo1oy0Nm
        4n+arWRNKs9onLhtIHoOZj+XWfQWrAE=
X-Google-Smtp-Source: AA6agR7vCuvhvGdLuuEmH3KTCmEH7RHsYiIvZ1GZ77j5wp+CmC+tj8S0vwHRwQeCdx9hiFQdW/5wKA==
X-Received: by 2002:adf:e84a:0:b0:226:d63d:3dc3 with SMTP id d10-20020adfe84a000000b00226d63d3dc3mr3883299wrn.140.1661780073370;
        Mon, 29 Aug 2022 06:34:33 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 12/13] io_uring: fix wrong arm_poll error handling
Date:   Mon, 29 Aug 2022 14:30:23 +0100
Message-Id: <cd4e6937d06fd243778b5a0eece6e37b9d058900.1661594698.git.asml.silence@gmail.com>
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

[ upstream commmit 9d2ad2947a53abf5e5e6527a9eeed50a3a4cbc72 ]

Leaving ip.error set when a request was punted to task_work execution is
problematic, don't forget to clear it.

Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/a6c84ef4182c6962380aebe11b35bdcb25b0ccfb.1655852245.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 16b0ea1b5bf7..6bcc3798591e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5621,8 +5621,10 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 
 	if (mask) {
 		/* can't multishot if failed, just queue the event we've got */
-		if (unlikely(ipt->error || !ipt->nr_entries))
+		if (unlikely(ipt->error || !ipt->nr_entries)) {
 			poll->events |= EPOLLONESHOT;
+			ipt->error = 0;
+		}
 		__io_poll_execute(req, mask);
 		return 0;
 	}
-- 
2.37.2

