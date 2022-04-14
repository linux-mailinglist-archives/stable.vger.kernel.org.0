Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6E8501144
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245093AbiDNNrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245688AbiDNNiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:38:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7F9931B9;
        Thu, 14 Apr 2022 06:33:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF854B8296A;
        Thu, 14 Apr 2022 13:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1287CC385A1;
        Thu, 14 Apr 2022 13:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943225;
        bh=tV8DEJZGkN5kEFm0cAke6lZHrwnbWk0Ly9SNdnfDtQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNbwgiwBX86Y4NefJqL2amfTxj8nUjjnSNWj+DoYnW19nupb3NAqAK/HGxbDCcHSJ
         lad5TUPapxriMHx3ONoxh9WxX3u1tamOd+9OIoqyJhnheNlIumxfFeWJPNcYMcihJj
         /DdFEX73lYc7eNObAGr6EfJThq71A4FvZ5dQeAgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tadeusz Struk <tadeusz.struk@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 078/475] crypto: rsa-pkcs1pad - fix buffer overread in pkcs1pad_verify_complete()
Date:   Thu, 14 Apr 2022 15:07:43 +0200
Message-Id: <20220414110857.337779253@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
@@ -475,6 +475,8 @@ static int pkcs1pad_verify_complete(stru
 	pos++;
 
 	if (digest_info) {
+		if (digest_info->size > dst_len - pos)
+			goto done;
 		if (crypto_memneq(out_buf + pos, digest_info->data,
 				  digest_info->size))
 			goto done;


