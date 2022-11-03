Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA176173B7
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 02:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiKCBYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 21:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKCBYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 21:24:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD76E62D7;
        Wed,  2 Nov 2022 18:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 490C961CE7;
        Thu,  3 Nov 2022 01:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCB6C433C1;
        Thu,  3 Nov 2022 01:24:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FWdiD5+j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667438665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=W7+oZClI0CrZlu6ZI88HJXSD2TxfHpWRCQjNVJlmR0w=;
        b=FWdiD5+jw7oC4pCzUniMPm1csJGA0WmlLbjPqHPbq33yv0oIZm3QBenwGHkFTGvuMbTqq7
        g7SXUKCaAQ5HjNTivyC30UpnoGBCLU980bcJaw754nznkMIUEcyiVc9bu2feDeoJjuNXg9
        9TkVsxlZroaQIP2X3N3imiOxFO7L4ow=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1d66be06 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 3 Nov 2022 01:24:25 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        krisman@collabora.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] unicode: don't write -1 after NULL terminator
Date:   Thu,  3 Nov 2022 02:24:11 +0100
Message-Id: <20221103012411.86537-1-Jason@zx2c4.com>
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

If the intention is to overwrite the first NULL with a -1, s[strlen(s)]
is the first NULL, not s[strlen(s)+1].

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

