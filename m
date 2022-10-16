Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC80600386
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 23:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJPVpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 17:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiJPVpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 17:45:15 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F42032EED
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:13 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id k2so21074518ejr.2
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUcc5JovUqHX056pp4p87zlUUaHV8JGfeF8nsouwWh0=;
        b=ZjdfRlt+5r7mKHwLaakrE1gSNxFu2egN0Wfq3TwRWA+I1+MUWfiXB8DEiLQwEJmjr2
         6qFp6IYX2nPNofQj9NHenpB1i60/dyP84us2hcf4fV7WgcLm5DdZpEtOQaQG/Jbdi7Fs
         NBNGLHFXQAj229W52oJ+1hlJd+nZLiM3Fcs2DMa5rdQXpP3CcRa5uPXWip3rfBDKXW5Q
         3LPf+QDh9Pr3D+TK94jXVzK3MX+EZ2bUPym0nK2bLGpqf8HzkEL/ajuzD/fdhlgk0qwz
         zsmumu5wAvFrOeLiHE9J6HypCb5gijSa7hL2vgsTRo954Oe85u90rR/TMw/NFNtFwa56
         r9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tUcc5JovUqHX056pp4p87zlUUaHV8JGfeF8nsouwWh0=;
        b=v81zcCRY6puAjGOyPTVQ3OhJ1LXmJjVAlXzSKquLocxYXA/fpSAxBHFR1QRCHvtBsl
         lPKTJqEdD+k0CqBIpYJstePpFS0PrsBgAujF7k74fGYLEFB7YuYFOGPth7xxkM7SyV0m
         Nuc79lcqORQT3bKMJbzebl1jRVWNEY10Wi/cNzklRr3bzxGX3PXXKTWXhcRJcudnFwHN
         kHfx1BZM8qinvc4o9JH7qaFeWwu350hxUmZlUQKwHGDizdfSeUu58bhYlU8t7V01XgmU
         KQpwGPx4kVqFjsVCJBfr/IzPDr0SfshQdAm9K3P24OhqFmSE6UqzQcSVOSlamDSN6TnP
         Tksg==
X-Gm-Message-State: ACrzQf0xF9XEGUrYLPUlFnh9QhIy9MHBhqhXb7kMkaIW8UZEQr6ZDAJJ
        d3qEuPgQ78wpEVAaHuOCisCohwH03Pk=
X-Google-Smtp-Source: AMsMyM650oyNFgJQUdnwZ6LMkx6OjRp/kp6kxKvtMCaJgn6MlcH9I1z2WSVgF0SJbVrVrTJSHDhu8g==
X-Received: by 2002:a17:907:2c5b:b0:78d:3f8a:19d0 with SMTP id hf27-20020a1709072c5b00b0078d3f8a19d0mr6183959ejc.369.1665956711511;
        Sun, 16 Oct 2022 14:45:11 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090676c600b0078c47463277sm5177331ejn.96.2022.10.16.14.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 14:45:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 4/5] io_uring/rw: fix error'ed retry return values
Date:   Sun, 16 Oct 2022 22:42:57 +0100
Message-Id: <ebd1fd870c2f7048613f85fcdf3934f15301c1a7.1665954636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665954636.git.asml.silence@gmail.com>
References: <cover.1665954636.git.asml.silence@gmail.com>
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

[ upstream commit 62bb0647b14646fa6c9aa25ecdf67ad18f13523c ]

Kernel test robot reports that we test negativity of an unsigned in
io_fixup_rw_res() after a recent change, which masks error codes and
messes up the return value in case I/O is re-retried and failed with
an error.

Fixes: 4d9cb92ca41dd ("io_uring/rw: fix short rw error handling")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9754a0970af1861e7865f9014f735c70dc60bf79.1663071587.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c0d1948fb5a6..f667197c8bb9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2701,7 +2701,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
-static inline unsigned io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
 {
 	struct io_async_rw *io = req->async_data;
 
-- 
2.38.0

