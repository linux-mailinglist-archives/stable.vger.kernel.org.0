Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75EB5A4E35
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiH2Nee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiH2Nec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:32 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351858B2F6
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:31 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id e13so9305948wrm.1
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=M8hx2ILfAIFsJunC86nezODCVfjRBuYodRpZouMAs0Y=;
        b=Ep1NDiFcHs1xTKFX33eg+odU+iv8KTQpQg0YNbzlpuwYB3POlmsVODBFg3aZ7OgOBc
         S6gX/2G/lgyZs9LuB3Dk+HYPeltls8Iatm6UhakkkzX5yd6xjzs198d8yasSuZ370bLY
         WDfk6yp380qN3PXqCIscphKBQ9xJMg3BGtJzhOw7lY7U/r/pt/xRpJnDhJbOpClWvAPo
         REWhXJxATsdd/Y/aPJ1dv26Ptvk8olCpIAjS77UFf3MXOuvFUiD6FUMvLk4mfmD7CDlG
         fpTl8AjUjeczQ2ytbwfh6mN9aACKyU65xnla/eXDz3pt3k7RdzmsEAsR0AUDsM6Un8Ns
         nEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=M8hx2ILfAIFsJunC86nezODCVfjRBuYodRpZouMAs0Y=;
        b=BtskA13XMxjp4cuOFgCIPe1wU3Z7iQ4wQwdnUOyTSYYDuhQT4c1JSX+N+Lah8h0/mq
         c+S+g93OjgTlyPkfihGkie7bEFMiP5mvimnu8WgWJsMOcjWBJL1p3QoPmZMR078LvDE9
         Tc500honFJ+7CU+/D7HG0mfVKReftTdzAD8lNpgNIBOzuGfBcvkf1fbNlPuu0+566QRi
         N4k5qa9FlF9WJXNFUgpIexw778qW2CbQv0qz/hJUZOMZEpMV0p84oWQzm0A0HAiZG3b4
         5Y+1JV8vmjQRRDTP5KmAWPljbIYbZWeLjBXp+b72YgfiQEhIa95o58RMguofEhy0rz6w
         IatA==
X-Gm-Message-State: ACgBeo2spaYHlkDiQQccL1Lol81a0OgRfZWEuxoJYiM0gQhO3UKQphmu
        X1kJdkfWONFQew97rOFda/9tUXgkqpU=
X-Google-Smtp-Source: AA6agR5QSPbFcaPzECHe4Dja2N5GIsGW2jscwkSPVuvtDfiiZ0fTfFVQprhTYf8UTsAoXa3DbL2VAg==
X-Received: by 2002:a05:6000:1881:b0:222:c899:cac6 with SMTP id a1-20020a056000188100b00222c899cac6mr6086800wri.283.1661780069274;
        Mon, 29 Aug 2022 06:34:29 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH stable-5.15 08/13] io_uring: Remove unused function req_ref_put
Date:   Mon, 29 Aug 2022 14:30:19 +0100
Message-Id: <462047f63638cd5489cf368f90cd86115a57d983.1661594698.git.asml.silence@gmail.com>
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

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ upstream commmit c84b8a3fef663933007e885535591b9d30bdc860 ]

Fix the following clang warnings:

fs/io_uring.c:1195:20: warning: unused function 'req_ref_put'
[-Wunused-function].

Fixes: aa43477b0402 ("io_uring: poll rework")
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220113162005.3011-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bc4741061258..c4d34b4e8fb6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1155,12 +1155,6 @@ static inline bool req_ref_put_and_test(struct io_kiocb *req)
 	return atomic_dec_and_test(&req->refs);
 }
 
-static inline void req_ref_put(struct io_kiocb *req)
-{
-	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
-	WARN_ON_ONCE(req_ref_put_and_test(req));
-}
-
 static inline void req_ref_get(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
-- 
2.37.2

