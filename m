Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34439593107
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 16:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiHOOxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 10:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiHOOxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 10:53:20 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5E01403D
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:53:19 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso7921911wma.2
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=nElDbTCSNkNAP8xQg8/k/OqVMafpwN8po+TvPzwbkVY=;
        b=bB3F9sDEpvmolKW75w2rsxfpkHfUgTV/Ltd9taJAcyQ1pH/kox6d7f10lEppU1EYUk
         0UFxKiQsYYAmC2UJl2vwz3dmPUPRhpF/vH4wnnMiEQ8s1A5HRMEnKRUgnxgqr+HXhhQ6
         es2oL9c5EgJQtxFfamgQr7MZ1DH7sQqqYy3YzxW4zePteHAXdYHj4mwkXiSLCZT3shOU
         wqEzq5immerkW4HwHg1mzV9gMcrksV5LGNEXlN64K7c+Igj6oRQRzBluaWdNnyX/PwPg
         9Nk6jv+da1qfGgZ9w8PLBxNAXiKda0FsdBYSRFbZgApUj+a0pLXSAtUojBAb+Q8yRHDR
         AyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=nElDbTCSNkNAP8xQg8/k/OqVMafpwN8po+TvPzwbkVY=;
        b=lBPXTbT6Kn7TzUS8JMTTVqpZkk07x/kI36bzbm/gVg1fHYjj/mFxciK1VQBCGELq99
         6PVYBVdrbqHJ0rO1Yy80Jt6WvDIEauKFNuGiLcZsRL4XaWc6insM8GFvj7AHqE24xBrm
         7N5pqkE7R3h1JGS58AmJeIAddpamYTe7bEyJRqlRKg2Y/P8xF8gmf0YYrHamXhuuW1K7
         aas3tmHOUQ0jx4IpV8N7tX6RdtGuB1wbtsbnLI3EO8FbgzHOHnUN84iNsOauA0hU9Ny5
         ZavGkb88dEEfmh26ddljnei8JIm7qc8fdWQZ58kZStM3VSCa4jYXI+B6soJCrFYMF0IA
         i9pw==
X-Gm-Message-State: ACgBeo3DkfnRkbRXdVkCE058UVPUUCb6iA5hQXAX2dZ3IZ/DyT9tnxoT
        3Kbr1dey4ofkW5wjkMcpFEyIvwCXEW0=
X-Google-Smtp-Source: AA6agR7LmZAy2Fhm/FIT45mPf6MHutTo4/MJ0te6paeo7IvFaUndNHd3/wH/m5WD5N2XiyYJBwcSTg==
X-Received: by 2002:a05:600c:4e8c:b0:3a6:11e:cc08 with SMTP id f12-20020a05600c4e8c00b003a6011ecc08mr1195387wmq.198.1660575198104;
        Mon, 15 Aug 2022 07:53:18 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:886])
        by smtp.gmail.com with ESMTPSA id bn21-20020a056000061500b0021e43b4edf0sm7644917wrb.20.2022.08.15.07.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 07:53:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.18 1/1] io_uring: mem-account pbuf buckets
Date:   Mon, 15 Aug 2022 15:51:27 +0100
Message-Id: <248fcea571fca546a2a5541577a05ce864b71c0b.1660574142.git.asml.silence@gmail.com>
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
index 3d97372e811e..c9ea517ecc46 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4927,7 +4927,7 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
-		bl = kmalloc(sizeof(*bl), GFP_KERNEL);
+		bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
 		if (!bl) {
 			ret = -ENOMEM;
 			goto err;
-- 
2.37.0

