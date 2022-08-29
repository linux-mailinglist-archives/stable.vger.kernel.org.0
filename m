Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096875A4E33
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiH2Nea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiH2Ne3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:29 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12831F58B
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:28 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id m17-20020a7bce11000000b003a5bedec07bso8206107wmc.0
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=vvlW1soxCI9cO6hjIuefcVmNqMKMlDl+4iuI5Z1rPys=;
        b=GD3hpbfR0SNJ0jh9MFyI9iCWXicxcbX6TqRRq70hlyXzzIyxBd68avvWyWubzvL9K0
         lFZmrf5rX1TdDJ2+mz4o+HJMEgW8ZOTKijjQItcooxmnMGO9aCL5jL+ApGZWP5Ktsn9b
         8J8ptIdD6JAcsYVjzMEj9eHJr4Y1njxdQAOgfmMcb/LzGmSnk+1IiYFHmNiKkqmfJezs
         mkZZD6DMAfmxLEVrnHFsaChUY0Yg495WwtIKaDkOrUJWE0KMdwe123fSlXO+YTUceIDH
         fCSi1/qxiSDiZ1IVQRiCk2qBLkPHaWPg7gZcXcKaDZsIdX8zuae3NZa0MBsxpy9iH4Zj
         sKuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=vvlW1soxCI9cO6hjIuefcVmNqMKMlDl+4iuI5Z1rPys=;
        b=EoA9FhcQoSAFSKGk4E0MEdbUzv+l5dyurtUqDRtomjss4dkomiJyDzfkAjRaboYU8D
         vjDmGBvPbCNo2zyWVkEnMUfsCMpH+35eoq6XdHfS/55avwruA6R18IbtN4sviZX/6n/g
         xuwgbBHZ6OmKGwEIEEMb/a3BhnzvSHpwrVlgYTgveNTyHTrPJwg8JWbIAP3NK/+w7mGA
         pNAplFpErXSwlbZpnz3sZFhPY0ZW4C5MgUBSHKLAVPEWFgvKqqyPithp5jGyP89IGrPD
         7k2mx624YKhsig4e1jzfQwPH02MncRPBsbSoRL3MK7VoZRiZF2NPppXfZE1rEfXy2iQ5
         SfWw==
X-Gm-Message-State: ACgBeo0k148cyVeAIm+PMDzLjkh91xU9rOBf+5UBt59s0FD1m0wsSJ62
        lCgDrFBosx8LrEffOHq6HPkntlEBwyw=
X-Google-Smtp-Source: AA6agR7bnefcgJHSskL7D1nvB2/gPABZQ17+r1UVvOn78QBSdk7GPgA+90xUSySim+iftiGJAC7w3w==
X-Received: by 2002:a05:600c:b47:b0:3a5:a431:ce36 with SMTP id k7-20020a05600c0b4700b003a5a431ce36mr7084356wmr.89.1661780066015;
        Mon, 29 Aug 2022 06:34:26 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 05/13] io_uring: kill poll linking optimisation
Date:   Mon, 29 Aug 2022 14:30:16 +0100
Message-Id: <46e0b53479f36ef3f9a0330b41ed0ccdb27a52bf.1661594698.git.asml.silence@gmail.com>
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

[ upstream commmit ab1dab960b8352cee082db0f8a54dc92a948bfd7 ]

With IORING_FEAT_FAST_POLL in place, io_put_req_find_next() for poll
requests doesn't make much sense, and in any case re-adding it
shouldn't be a problem considering batching in tctx_task_work(). We can
remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/15699682bf81610ec901d4e79d6da64baa9f70be.1639605189.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8fa257b62ba7..6e80876d8894 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5454,7 +5454,6 @@ static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *nxt;
 
 	if (io_poll_rewait(req, &req->poll)) {
 		spin_unlock(&ctx->completion_lock);
@@ -5478,11 +5477,8 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 		spin_unlock(&ctx->completion_lock);
 		io_cqring_ev_posted(ctx);
 
-		if (done) {
-			nxt = io_put_req_find_next(req);
-			if (nxt)
-				io_req_task_submit(nxt, locked);
-		}
+		if (done)
+			io_put_req(req);
 	}
 }
 
-- 
2.37.2

