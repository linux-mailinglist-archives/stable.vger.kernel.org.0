Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22514F3AD6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbiDELtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355947AbiDEKWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFD4AA033;
        Tue,  5 Apr 2022 03:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8120661500;
        Tue,  5 Apr 2022 10:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93154C385A1;
        Tue,  5 Apr 2022 10:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153132;
        bh=+3MwjoxU6y9Rz147dPjjPlPFEMsY7UQgaL93494ZQ1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0c+9N1sgS4QH5TQF1mWJ0lbEN6m7LTHWDJrV7xQc15pyTvSbv4LZ/5cYEkBR01VS5
         4OK3OUP3VHnXh9zx9vXYOjmVmji4M0Dw6e+fpnryzggRwUfYWSLP1FMeE0UeGsMwto
         oS64/5IDJ4BvydCg36f3f+Lsku8o6Lxh0BMmsaPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tadeusz Struk <tadeusz.struk@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 112/599] crypto: rsa-pkcs1pad - fix buffer overread in pkcs1pad_verify_complete()
Date:   Tue,  5 Apr 2022 09:26:46 +0200
Message-Id: <20220405070302.170606384@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric Biggers <ebiggers@google.com>

commit a24611ea356c7f3f0ec926da11b9482ac1f414fd upstream.

Before checking whether the expected digest_info is present, we need to
check that there are enough bytes remaining.

Fixes: a49de377e051 ("crypto: Add hash param to pkcs1pad")
Cc: <stable@vger.kernel.org> # v4.6+
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/rsa-pkcs1pad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -476,6 +476,8 @@ static int pkcs1pad_verify_complete(stru
 	pos++;
 
 	if (digest_info) {
+		if (digest_info->size > dst_len - pos)
+			goto done;
 		if (crypto_memneq(out_buf + pos, digest_info->data,
 				  digest_info->size))
 			goto done;


