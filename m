Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1388A617B80
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 12:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiKCLam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 07:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiKCLal (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 07:30:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA92C11A19;
        Thu,  3 Nov 2022 04:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 65A42CE257D;
        Thu,  3 Nov 2022 11:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379EEC433C1;
        Thu,  3 Nov 2022 11:30:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="U/4SZCYC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667475031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/f6o/OYDOQ7Q6RyE0PpCRk4Xe1H3AuP3tWnYOWByfg=;
        b=U/4SZCYCZvDqix+wIfum5CLK1MUA0V56pTQQQJAsVBiJvVG2Brr/3lUiUrzq0HQg3mP8Jy
        DrfmTWK9yt3w2qmDr3qnWeKNp0kwIQ3W/TyWMc3f/0qqXGJZD01jXP0yzuQk+c24zuTdJ0
        VfYDtW0FEra3VizP/cmNrokhL2w2xXU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1665c81f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 3 Nov 2022 11:30:31 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        krisman@collabora.com, jirislaby@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH v2] unicode: don't write -1 after NUL terminator
Date:   Thu,  3 Nov 2022 12:30:21 +0100
Message-Id: <20221103113021.3271-1-Jason@zx2c4.com>
In-Reply-To: <79db9616-a2ee-9a1a-9a35-b82f65b6d15e@kernel.org>
References: <79db9616-a2ee-9a1a-9a35-b82f65b6d15e@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the intention is to overwrite the first NUL with a -1, s[strlen(s)]
is the first NUL, not s[strlen(s)+1].

Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 fs/unicode/mkutf8data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/unicode/mkutf8data.c b/fs/unicode/mkutf8data.c
index bc1a7c8b5c8d..61800e0d3226 100644
--- a/fs/unicode/mkutf8data.c
+++ b/fs/unicode/mkutf8data.c
@@ -3194,7 +3194,7 @@ static int normalize_line(struct tree *tree)
 	/* Second test: length-limited string. */
 	s = buf2;
 	/* Replace NUL with a value that will cause an error if seen. */
-	s[strlen(s) + 1] = -1;
+	s[strlen(s)] = -1;
 	t = buf3;
 	if (utf8cursor(&u8c, tree, s))
 		return -1;
-- 
2.38.1

