Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC2059310D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 16:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiHOOye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 10:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiHOOye (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 10:54:34 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6234E1403D
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:54:33 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bv3so9361501wrb.5
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=4DjM/vZxduL6zzFIFmdTCVj3GPSxV2j1KLrN465Wx28=;
        b=mJBAvU5nX+Dl+YOJ+zdrp3NH+BGla5foqCyhhek3jeVvt7J+VMLd1lAoodG5M0coEP
         WbbSP9y/pOzze4JEaX6hnhLJzxBce4GXz7UsqHbVUbQmqVK1jM62Sml/zk5v9mVkMJbm
         LMxtO84tQsDFiPkEpqYE7hj+2XQlgqyUkE0T7IGihwEgalRc5D+q4ScHc3cZLmJbZS2+
         95SD8m/f6R4h/FN6ZCK0WdaAoIi7alG+uTQvwzPikgcjvaVcXhpinJjj6qRdez2+D5aZ
         8GgtPk001OcrqIqs7fdRhCg5F7O3ZnLgIe1fxZQfa2W929nrCCdjLAahhH75Cp+3kOT4
         RslQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=4DjM/vZxduL6zzFIFmdTCVj3GPSxV2j1KLrN465Wx28=;
        b=u6MgoBphralQtvDmfMV/Mkx1NJCL5BzCiKrsvac2bgoecdYR+eRyLanSxqc4QvMsoX
         a9Zg24eN2CxkXHDZ22FNv9lxfC4auQ6sZx7bXipdSQJhqp0QLYZQDKiQ38qfVeGfPWuS
         SWaup5fXkBrzwHTWsj4JJNf7LpHizxmMdvqEIoHYRizflkHhYwtxIJe8A8sMuoMd8yBp
         7GWb0GTdT61sIutrVBN32K3yqNmj6OSKRD6dhhXpdCMkRnTOA6n+iIS2+kjYmLxDr4Tg
         ogxFrQfslrKXCwbmXQyfndrA2lZtEsG8mNTiRIS4Z6UL6TftS0KE3fC9yK/aX0FhCzQO
         f6Mw==
X-Gm-Message-State: ACgBeo2dFbCWMlSVmetnv58vvqs4RRXI1wt6dEZC2+IIT87lXpTemA9R
        Hfsce1Ov8Wa9xZasXxkUSstIysh5cH0=
X-Google-Smtp-Source: AA6agR4cJCVLm3niMnY8DIZKqY00NtFJR6Dxo5CZEjXc5siUS61tC3wHWvOW3XSKdNDONylpv+4T9g==
X-Received: by 2002:a05:6000:184a:b0:222:cdc3:257c with SMTP id c10-20020a056000184a00b00222cdc3257cmr8822164wri.604.1660575271708;
        Mon, 15 Aug 2022 07:54:31 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:886])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c154d00b003a54fffa809sm10680330wmg.17.2022.08.15.07.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 07:54:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.19] io_uring: mem-account pbuf buckets
Date:   Mon, 15 Aug 2022 15:52:38 +0100
Message-Id: <4302b28024f6cf027a305a0b8790066acefb5e73.1660574026.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

[ upstream commit cc18cc5e82033d406f54144ad6f8092206004684 ]

Potentially, someone may create as many pbuf bucket as there are indexes
in an xarray without any other restrictions bounding our memory usage,
put memory needed for the buckets under memory accounting.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d34c452e45793e978d26e2606211ec9070d329ea.1659622312.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e8e769be9ed0..9fa702d707af 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5738,7 +5738,7 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
-		bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+		bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
 		if (!bl) {
 			ret = -ENOMEM;
 			goto err;
-- 
2.37.0

