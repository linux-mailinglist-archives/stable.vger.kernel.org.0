Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4F05A4E39
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiH2Neh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiH2Nee (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:34 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340498B2D2
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:33 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id bs25so10238147wrb.2
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Dux3oM2wq9MUPDhMjsLR7z9h1y60/tcuRFkhalnzxtM=;
        b=acEuW+xMunAItoo+FvcRd5X8oBFMw1InsCbrJ0Yn52VmbVd8pZG/sIcGWxWJyWN9mT
         ZgvHHIWkLYrR1CqvyL1gGYvUsjTkA5If0PbEkqZ/ZTAtEXIrCvWCIcRgx76O/RRJO5Ee
         S41wPvtnmAlVonVnpQldj9PnwifkAszrACpXr0pPoAk/AqL3pxFlerL4akotP16pQaKz
         H5QqyHEA6gcJxQHPh3QrN287ylRTH+S6eOgzhRWKwLdHOMdhsjdMy17BlFnEGWx0O42s
         Jq7hbh7qjT5Q3hB0NIJelWR2h4TRxkPzPEqJiOhpqakex3lFAbJt4hMBfso5n0fL0taa
         q1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Dux3oM2wq9MUPDhMjsLR7z9h1y60/tcuRFkhalnzxtM=;
        b=mBxhb+K3D0U1vDO8/unPXZRgg2d2pirJ/f63+wKTLb6TaDDtVyWI8XCuW3vqeirpFI
         RKddP8FY9JiwJl03hEEv55InpDHcNjQxk6eSRc9eD5fwp8HKRSIFXIfEqFrS87kfRicH
         4DYVof5etuPMy51khQwS4uGQdXbG7fmbnRtrALCrl/ingxb74Vsv74NYChVjDztpSLPD
         YnDvBqMnsG9rrHif9PtM8MYsmHVoUa7gAuM5fM5gFQekguEyg1oXiwJT+MUETa0TfKQ2
         +Fp/sUnbZ6CSbE56pU6xMfAoQLvUzvZ+3Au+5RWI/cFXhjrpX+CW/zhl/rGkyrmRX2yF
         azYg==
X-Gm-Message-State: ACgBeo2MPXrek7dCWH46dohatKYYrGbEly9u2E65tw/bQd1dWdeU9jdL
        H/G9vGwIlLtEU9MlDQm2SqHuu4ouDRk=
X-Google-Smtp-Source: AA6agR6nEGhlxbSqwOAPDorNDsqKaebFl7blaYsEGdaQBGgdH9oZ9RFrvsH9NFrx1/VhtPBNMZhOHg==
X-Received: by 2002:a05:6000:1f94:b0:225:3afc:936f with SMTP id bw20-20020a0560001f9400b002253afc936fmr6023000wrb.109.1661780071349;
        Mon, 29 Aug 2022 06:34:31 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 10/13] io_uring: bump poll refs to full 31-bits
Date:   Mon, 29 Aug 2022 14:30:21 +0100
Message-Id: <a043031ab97528ca7bd9aeed262bf4b3580d7ef5.1661594698.git.asml.silence@gmail.com>
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

From: Jens Axboe <axboe@kernel.dk>

[ upstream commmit e2c0cb7c0cc72939b61a7efee376206725796625 ]

The previous commit:

1bc84c40088 ("io_uring: remove poll entry from list when canceling all")

removed a potential overflow condition for the poll references. They
are currently limited to 20-bits, even if we have 31-bits available. The
upper bit is used to mark for cancelation.

Bump the poll ref space to 31-bits, making that kind of situation much
harder to trigger in general. We'll separately add overflow checking
and handling.

Fixes: aa43477b0402 ("io_uring: poll rework")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4ebc47ebb77a..ac9fa3364c45 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5308,7 +5308,7 @@ struct io_poll_table {
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_REF_MASK	((1u << 20)-1)
+#define IO_POLL_REF_MASK	GENMASK(30, 0)
 
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
-- 
2.37.2

