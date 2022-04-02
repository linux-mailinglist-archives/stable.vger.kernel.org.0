Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87EF4F0196
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354739AbiDBMqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354730AbiDBMqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:46:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF2263A7
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DD9E61479
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE52C340EC;
        Sat,  2 Apr 2022 12:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648903468;
        bh=5AYF46unz162OQ255vgagScDpjn78ga+f40P/3yLFb0=;
        h=Subject:To:Cc:From:Date:From;
        b=LDUktzr4eviqf6VRYadVU3nFViMhRzdlzG8ZjuYgIi+BOsMst6/zaBK9O/HbnRaON
         LLcXpT4QN0BqXSs0bZvdzp+qkVNqHrT5LGxQ3Hl0h7BJWrcGf8foWTpOxmW/AB9EaP
         LDJf+aZst+8f1yWJl4OIV0Zs85OJN1VW4bF9u8fk=
Subject: FAILED: patch "[PATCH] crypto: rsa-pkcs1pad - fix buffer overread in" failed to apply to 4.9-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org, tadeusz.struk@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:44:15 +0200
Message-ID: <1648903455198173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a24611ea356c7f3f0ec926da11b9482ac1f414fd Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 18 Jan 2022 16:13:05 -0800
Subject: [PATCH] crypto: rsa-pkcs1pad - fix buffer overread in
 pkcs1pad_verify_complete()

Before checking whether the expected digest_info is present, we need to
check that there are enough bytes remaining.

Fixes: a49de377e051 ("crypto: Add hash param to pkcs1pad")
Cc: <stable@vger.kernel.org> # v4.6+
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 6b556ddeb3a0..9d804831c8b3 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -476,6 +476,8 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 	pos++;
 
 	if (digest_info) {
+		if (digest_info->size > dst_len - pos)
+			goto done;
 		if (crypto_memneq(out_buf + pos, digest_info->data,
 				  digest_info->size))
 			goto done;

